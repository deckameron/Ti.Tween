//
//  Tween.m
//  TiTween
//
//  Created by Douglas Alves
//  Copyright (c) 2025. All rights reserved.
//

#import "Tween.h"
#import "EasingFunctions.h"
#import "TweenProperty.h"

@implementation Tween

+ (instancetype)tweenWithTarget:(UIView *)target
                     properties:(NSArray<TweenProperty *> *)properties
                       duration:(CFTimeInterval)duration
                          delay:(CFTimeInterval)delay
                     easingType:(TweenEasingType)easingType {
    Tween *tween = [[Tween alloc] init];
    tween->_tweenId = [[NSUUID UUID] UUIDString];
    tween.targetView = target;
    tween.properties = properties;
    tween.duration = duration;
    tween.delay = delay;
    tween.easingType = easingType;
    tween.state = TweenStateIdle;
    tween.accumulatedPausedDuration = 0.0;
    return tween;
}

- (void)start {
    if (self.state == TweenStateRunning) {
        return;
    }
    
    // Capture start values from current view state
    NSMutableArray *updatedProperties = [NSMutableArray array];
    for (TweenProperty *prop in self.properties) {
        TweenPropertyValueType valueType = [TweenProperty valueTypeForPropertyType:prop.type];
        
        if (valueType == TweenPropertyValueTypeFloat) {
            CGFloat currentValue = [TweenProperty currentFloatValueForProperty:prop.type fromView:self.targetView];
            TweenProperty *updatedProp = [TweenProperty propertyWithType:prop.type
                                                              startValue:currentValue
                                                                endValue:prop.endValue];
            [updatedProperties addObject:updatedProp];
        }
        else if (valueType == TweenPropertyValueTypeColor) {
            UIColor *currentColor = [TweenProperty currentColorValueForProperty:prop.type fromView:self.targetView];
            TweenProperty *updatedProp = [TweenProperty propertyWithType:prop.type
                                                              startColor:currentColor
                                                                endColor:prop.endColor];
            [updatedProperties addObject:updatedProp];
        }
        else if (valueType == TweenPropertyValueTypePoint) {
            CGPoint currentPoint = [TweenProperty currentPointValueForProperty:prop.type fromView:self.targetView];
            TweenProperty *updatedProp = [TweenProperty propertyWithType:prop.type
                                                              startPoint:currentPoint
                                                                endPoint:prop.endPoint];
            [updatedProperties addObject:updatedProp];
        }
    }
    self.properties = [updatedProperties copy];
    
    self.startTime = CFAbsoluteTimeGetCurrent();
    self.state = self.delay > 0 ? TweenStateDelaying : TweenStateRunning;
    self.accumulatedPausedDuration = 0.0;
}

- (void)pause {
    if (self.state != TweenStateRunning && self.state != TweenStateDelaying) {
        return;
    }
    
    self.pausedTime = CFAbsoluteTimeGetCurrent();
    self.state = TweenStatePaused;
}

- (void)resume {
    if (self.state != TweenStatePaused) {
        return;
    }
    
    CFTimeInterval pauseDuration = CFAbsoluteTimeGetCurrent() - self.pausedTime;
    self.accumulatedPausedDuration += pauseDuration;
    self.state = TweenStateRunning;
}

- (void)stop {
    self.state = TweenStateCompleted;
    
    // Snap to end values
    for (TweenProperty *prop in self.properties) {
        if (prop.valueType == TweenPropertyValueTypeFloat) {
            [TweenProperty applyFloatValue:prop.endValue forProperty:prop.type toView:self.targetView];
        }
        else if (prop.valueType == TweenPropertyValueTypeColor) {
            [TweenProperty applyColorValue:prop.endColor forProperty:prop.type toView:self.targetView];
        }
        else if (prop.valueType == TweenPropertyValueTypePoint) {
            [TweenProperty applyPointValue:prop.endPoint forProperty:prop.type toView:self.targetView];
        }
    }
}

- (void)update:(CFTimeInterval)currentTime {
    if (self.state == TweenStatePaused || self.state == TweenStateCompleted) {
        return;
    }
    
    CFTimeInterval elapsed = currentTime - self.startTime - self.accumulatedPausedDuration;
    
    // Handle delay
    if (self.state == TweenStateDelaying) {
        if (elapsed >= self.delay) {
            self.state = TweenStateRunning;
            elapsed -= self.delay;
        } else {
            return;
        }
    }
    
    // Calculate progress (0.0 to 1.0)
    CGFloat t = fmin(elapsed / self.duration, 1.0);
    
    // Apply easing
    CGFloat easedT;
    if (self.easingType == TweenEasingTypeCubicBezier) {
        easedT = [EasingFunctions cubicBezier:t
                                          p1x:self.bezierP1X
                                          p1y:self.bezierP1Y
                                          p2x:self.bezierP2X
                                          p2y:self.bezierP2Y];
    } else {
        easedT = [EasingFunctions ease:t type:self.easingType];
    }
    
    // Interpolate and apply properties
    for (TweenProperty *prop in self.properties) {
        if (prop.valueType == TweenPropertyValueTypeFloat) {
            CGFloat value = prop.startValue + (prop.endValue - prop.startValue) * easedT;
            [TweenProperty applyFloatValue:value forProperty:prop.type toView:self.targetView];
        }
        else if (prop.valueType == TweenPropertyValueTypeColor) {
            UIColor *interpolatedColor = [TweenProperty interpolateFromColor:prop.startColor
                                                                     toColor:prop.endColor
                                                                    progress:easedT];
            [TweenProperty applyColorValue:interpolatedColor forProperty:prop.type toView:self.targetView];
        }
        else if (prop.valueType == TweenPropertyValueTypePoint) {
            CGFloat x = prop.startPoint.x + (prop.endPoint.x - prop.startPoint.x) * easedT;
            CGFloat y = prop.startPoint.y + (prop.endPoint.y - prop.startPoint.y) * easedT;
            CGPoint interpolatedPoint = CGPointMake(x, y);
            [TweenProperty applyPointValue:interpolatedPoint forProperty:prop.type toView:self.targetView];
        }
    }
    
    // Trigger update callback
    if (self.onUpdate) {
        self.onUpdate(self);
    }
    
    // Check completion
    if (t >= 1.0) {
        self.state = TweenStateCompleted;
        
        // Ensure final values are exact
        for (TweenProperty *prop in self.properties) {
            if (prop.valueType == TweenPropertyValueTypeFloat) {
                [TweenProperty applyFloatValue:prop.endValue forProperty:prop.type toView:self.targetView];
            }
            else if (prop.valueType == TweenPropertyValueTypeColor) {
                [TweenProperty applyColorValue:prop.endColor forProperty:prop.type toView:self.targetView];
            }
            else if (prop.valueType == TweenPropertyValueTypePoint) {
                [TweenProperty applyPointValue:prop.endPoint forProperty:prop.type toView:self.targetView];
            }
        }
        
        if (self.onComplete) {
            self.onComplete(self);
        }
    }
}

- (BOOL)isActive {
    return self.state == TweenStateDelaying || 
           self.state == TweenStateRunning;
}

- (CGFloat)progress {
    if (self.state == TweenStateIdle || self.state == TweenStateDelaying) {
        return 0.0;
    }
    
    if (self.state == TweenStateCompleted) {
        return 1.0;
    }
    
    CFTimeInterval elapsed = CFAbsoluteTimeGetCurrent() - self.startTime - self.accumulatedPausedDuration - self.delay;
    return fmin(fmax(elapsed / self.duration, 0.0), 1.0);
}

@end
