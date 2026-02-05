//
//  TiTweenModule.m
//  TiTween
//
//  Created by Douglas Alves
//  Copyright (c) 2025. All rights reserved.
//

#import "TiTweenModule.h"
#import "TiBase.h"
#import "TiHost.h"
#import "TiUtils.h"
#import "TiViewProxy.h"
#import "TweenEngine.h"
#import "Tween.h"
#import "TweenSequence.h"
#import "TweenProperty.h"
#import "EasingFunctions.h"

@implementation TiTweenModule

#pragma mark - Internal

- (id)moduleGUID {
    return @"4e8e3c7d-9f2a-4b1c-8d5e-6f7a8b9c0d1e";
}

- (NSString *)moduleId {
    return @"ti.tween";
}

#pragma mark - Lifecycle

- (void)startup {
    [super startup];
    NSLog(@"[INFO] %@ loaded", self);
}

#pragma mark - Constants - Easing Types

MAKE_SYSTEM_PROP(EASE_LINEAR, TweenEasingTypeLinear);

MAKE_SYSTEM_PROP(EASE_IN_QUAD, TweenEasingTypeInQuad);
MAKE_SYSTEM_PROP(EASE_OUT_QUAD, TweenEasingTypeOutQuad);
MAKE_SYSTEM_PROP(EASE_IN_OUT_QUAD, TweenEasingTypeInOutQuad);

MAKE_SYSTEM_PROP(EASE_IN_CUBIC, TweenEasingTypeInCubic);
MAKE_SYSTEM_PROP(EASE_OUT_CUBIC, TweenEasingTypeOutCubic);
MAKE_SYSTEM_PROP(EASE_IN_OUT_CUBIC, TweenEasingTypeInOutCubic);

MAKE_SYSTEM_PROP(EASE_IN_QUART, TweenEasingTypeInQuart);
MAKE_SYSTEM_PROP(EASE_OUT_QUART, TweenEasingTypeOutQuart);
MAKE_SYSTEM_PROP(EASE_IN_OUT_QUART, TweenEasingTypeInOutQuart);

MAKE_SYSTEM_PROP(EASE_IN_QUINT, TweenEasingTypeInQuint);
MAKE_SYSTEM_PROP(EASE_OUT_QUINT, TweenEasingTypeOutQuint);
MAKE_SYSTEM_PROP(EASE_IN_OUT_QUINT, TweenEasingTypeInOutQuint);

MAKE_SYSTEM_PROP(EASE_IN_EXPO, TweenEasingTypeInExpo);
MAKE_SYSTEM_PROP(EASE_OUT_EXPO, TweenEasingTypeOutExpo);
MAKE_SYSTEM_PROP(EASE_IN_OUT_EXPO, TweenEasingTypeInOutExpo);

MAKE_SYSTEM_PROP(EASE_IN_SINE, TweenEasingTypeInSine);
MAKE_SYSTEM_PROP(EASE_OUT_SINE, TweenEasingTypeOutSine);
MAKE_SYSTEM_PROP(EASE_IN_OUT_SINE, TweenEasingTypeInOutSine);

MAKE_SYSTEM_PROP(EASE_IN_ELASTIC, TweenEasingTypeInElastic);
MAKE_SYSTEM_PROP(EASE_OUT_ELASTIC, TweenEasingTypeOutElastic);
MAKE_SYSTEM_PROP(EASE_IN_OUT_ELASTIC, TweenEasingTypeInOutElastic);

MAKE_SYSTEM_PROP(EASE_IN_BACK, TweenEasingTypeInBack);
MAKE_SYSTEM_PROP(EASE_OUT_BACK, TweenEasingTypeOutBack);
MAKE_SYSTEM_PROP(EASE_IN_OUT_BACK, TweenEasingTypeInOutBack);

MAKE_SYSTEM_PROP(EASE_IN_BOUNCE, TweenEasingTypeInBounce);
MAKE_SYSTEM_PROP(EASE_OUT_BOUNCE, TweenEasingTypeOutBounce);
MAKE_SYSTEM_PROP(EASE_IN_OUT_BOUNCE, TweenEasingTypeInOutBounce);

MAKE_SYSTEM_PROP(CUBIC_BEZIER, TweenEasingTypeCubicBezier);

#pragma mark - Constants - Sequence Modes

MAKE_SYSTEM_PROP(SEQUENCE_SERIAL, TweenSequenceModeSerial);
MAKE_SYSTEM_PROP(SEQUENCE_PARALLEL, TweenSequenceModeParallel);

#pragma mark - Public API - start

- (id)start:(id)args {
    ENSURE_SINGLE_ARG(args, NSDictionary);
    
    TiViewProxy *targetProxy = [args objectForKey:@"target"];
    NSDictionary *properties = [args objectForKey:@"properties"];
    NSNumber *duration = [args objectForKey:@"duration"];
    NSNumber *delay = [args objectForKey:@"delay"];
    id easingArg = [args objectForKey:@"easing"];
    KrollCallback *onComplete = [args objectForKey:@"onComplete"];
    KrollCallback *onUpdate = [args objectForKey:@"onUpdate"];
    
    // Validate required parameters
    if (!targetProxy || ![targetProxy isKindOfClass:[TiViewProxy class]]) {
        NSLog(@"[ERROR] TiTween.start: 'target' must be a valid view proxy");
        return nil;
    }
    
    if (!properties || ![properties isKindOfClass:[NSDictionary class]] || properties.count == 0) {
        NSLog(@"[ERROR] TiTween.start: 'properties' must be a non-empty dictionary");
        return nil;
    }
    
    if (!duration) {
        NSLog(@"[ERROR] TiTween.start: 'duration' is required");
        return nil;
    }
    
    // Parse easing
    TweenEasingType easingType = TweenEasingTypeLinear;
    CGFloat bezierP1X = 0, bezierP1Y = 0, bezierP2X = 0, bezierP2Y = 0;
    
    if ([easingArg isKindOfClass:[NSNumber class]]) {
        easingType = [easingArg integerValue];
    } else if ([easingArg isKindOfClass:[NSDictionary class]]) {
        NSDictionary *easingDict = (NSDictionary *)easingArg;
        NSNumber *typeNum = [easingDict objectForKey:@"type"];
        if (typeNum && [typeNum integerValue] == TweenEasingTypeCubicBezier) {
            easingType = TweenEasingTypeCubicBezier;
            NSArray *points = [easingDict objectForKey:@"points"];
            if (points && [points isKindOfClass:[NSArray class]] && points.count == 4) {
                bezierP1X = [points[0] floatValue];
                bezierP1Y = [points[1] floatValue];
                bezierP2X = [points[2] floatValue];
                bezierP2Y = [points[3] floatValue];
            }
        }
    }
    
    // Parse properties
    NSMutableArray *tweenProperties = [NSMutableArray array];
    for (NSString *propName in properties) {
        NSLog(@"🔵 [Module] Parsing property name: %@", propName);
        
        TweenPropertyType propType = [TweenProperty propertyTypeFromString:propName];
        NSLog(@"🔵 [Module] propertyTypeFromString returned: %ld", (long)propType);
        NSLog(@"🔵 [Module] TweenPropertyTypeTextColor constant value: %ld", (long)TweenPropertyTypeTextColor);
        
        if (propType == -1) {
            NSLog(@"[WARN] TiTween.start: Unknown property '%@'", propName);
            continue;
        }
        
        TweenPropertyValueType valueType = [TweenProperty valueTypeForPropertyType:propType];
        NSLog(@"🔵 [Module] valueType: %ld", (long)valueType);
        
        id propValue = [properties objectForKey:propName];
        
        TweenProperty *prop = nil;
        
        if (valueType == TweenPropertyValueTypeFloat) {
            CGFloat endValue = [propValue floatValue];
            prop = [TweenProperty propertyWithType:propType startValue:0 endValue:endValue];
        }
        else if (valueType == TweenPropertyValueTypeColor) {
            UIColor *endColor = nil;
            if ([propValue isKindOfClass:[NSString class]]) {
                endColor = [TweenProperty colorFromHexString:propValue];
            } else {
                NSLog(@"[WARN] TiTween.start: Color property '%@' must be a hex string", propName);
                continue;
            }
            prop = [TweenProperty propertyWithType:propType startColor:nil endColor:endColor];
        }
        else if (valueType == TweenPropertyValueTypePoint) {
            CGPoint endPoint = CGPointZero;
            if ([propValue isKindOfClass:[NSDictionary class]]) {
                NSDictionary *pointDict = (NSDictionary *)propValue;
                endPoint.x = [[pointDict objectForKey:@"x"] floatValue];
                endPoint.y = [[pointDict objectForKey:@"y"] floatValue];
            } else if ([propValue isKindOfClass:[NSArray class]]) {
                NSArray *pointArray = (NSArray *)propValue;
                if (pointArray.count >= 2) {
                    endPoint.x = [pointArray[0] floatValue];
                    endPoint.y = [pointArray[1] floatValue];
                }
            } else {
                NSLog(@"[WARN] TiTween.start: Point property '%@' must be a dictionary {x,y} or array [x,y]", propName);
                continue;
            }
            prop = [TweenProperty propertyWithType:propType startPoint:CGPointZero endPoint:endPoint];
        }
        
        if (prop) {
            [tweenProperties addObject:prop];
        }
    }
    
    if (tweenProperties.count == 0) {
        NSLog(@"[ERROR] TiTween.start: No valid properties to animate");
        return nil;
    }
    
    // Create tween
    UIView *targetView = [targetProxy view];
    CFTimeInterval durationSeconds = [duration floatValue] / 1000.0; // Convert ms to seconds
    CFTimeInterval delaySeconds = delay ? [delay floatValue] / 1000.0 : 0.0;
    
    Tween *tween = [Tween tweenWithTarget:targetView
                               properties:tweenProperties
                                 duration:durationSeconds
                                    delay:delaySeconds
                               easingType:easingType];
    
    // Set cubic bezier parameters if needed
    if (easingType == TweenEasingTypeCubicBezier) {
        tween.bezierP1X = bezierP1X;
        tween.bezierP1Y = bezierP1Y;
        tween.bezierP2X = bezierP2X;
        tween.bezierP2Y = bezierP2Y;
    }
    
    // Set callbacks
    if (onComplete) {
        tween.onComplete = ^(Tween *t) {
            [onComplete call:nil thisObject:nil];
        };
    }
    
    if (onUpdate) {
        tween.onUpdate = ^(Tween *t) {
            [onUpdate call:@[@{@"progress": @(t.progress)}] thisObject:nil];
        };
    }
    
    // Add to engine
    [[TweenEngine sharedInstance] addTween:tween];
    
    return tween.tweenId;
}

#pragma mark - Public API - sequence

- (id)sequence:(id)args {
    ENSURE_ARG_COUNT(args, 2);
    
    NSArray *tweensConfig = [args objectAtIndex:0];
    NSDictionary *options = [args objectAtIndex:1];
    
    if (!tweensConfig || ![tweensConfig isKindOfClass:[NSArray class]]) {
        NSLog(@"[ERROR] TiTween.sequence: First argument must be an array of tween configs");
        return nil;
    }
    
    NSNumber *modeNum = [options objectForKey:@"mode"];
    TweenSequenceMode mode = modeNum ? [modeNum integerValue] : TweenSequenceModeSerial;
    KrollCallback *onComplete = [options objectForKey:@"onComplete"];
    
    // Create tweens
    NSMutableArray *tweens = [NSMutableArray array];
    for (NSDictionary *tweenConfig in tweensConfig) {
        if (![tweenConfig isKindOfClass:[NSDictionary class]]) {
            continue;
        }
        
        TiViewProxy *targetProxy = [tweenConfig objectForKey:@"target"];
        NSDictionary *properties = [tweenConfig objectForKey:@"properties"];
        NSNumber *duration = [tweenConfig objectForKey:@"duration"];
        NSNumber *delay = [tweenConfig objectForKey:@"delay"];
        id easingArg = [tweenConfig objectForKey:@"easing"];
        
        if (!targetProxy || !properties || !duration) {
            continue;
        }
        
        // Parse easing
        TweenEasingType easingType = TweenEasingTypeLinear;
        if ([easingArg isKindOfClass:[NSNumber class]]) {
            easingType = [easingArg integerValue];
        }
        
        // Parse properties
        NSMutableArray *tweenProperties = [NSMutableArray array];
        for (NSString *propName in properties) {
            TweenPropertyType propType = [TweenProperty propertyTypeFromString:propName];
            if (propType == -1) continue;
            
            TweenPropertyValueType valueType = [TweenProperty valueTypeForPropertyType:propType];
            id propValue = [properties objectForKey:propName];
            
            TweenProperty *prop = nil;
            
            if (valueType == TweenPropertyValueTypeFloat) {
                CGFloat endValue = [propValue floatValue];
                prop = [TweenProperty propertyWithType:propType startValue:0 endValue:endValue];
            }
            else if (valueType == TweenPropertyValueTypeColor) {
                if ([propValue isKindOfClass:[NSString class]]) {
                    UIColor *endColor = [TweenProperty colorFromHexString:propValue];
                    prop = [TweenProperty propertyWithType:propType startColor:nil endColor:endColor];
                }
            }
            else if (valueType == TweenPropertyValueTypePoint) {
                CGPoint endPoint = CGPointZero;
                if ([propValue isKindOfClass:[NSDictionary class]]) {
                    NSDictionary *pointDict = (NSDictionary *)propValue;
                    endPoint.x = [[pointDict objectForKey:@"x"] floatValue];
                    endPoint.y = [[pointDict objectForKey:@"y"] floatValue];
                } else if ([propValue isKindOfClass:[NSArray class]]) {
                    NSArray *pointArray = (NSArray *)propValue;
                    if (pointArray.count >= 2) {
                        endPoint.x = [pointArray[0] floatValue];
                        endPoint.y = [pointArray[1] floatValue];
                    }
                }
                prop = [TweenProperty propertyWithType:propType startPoint:CGPointZero endPoint:endPoint];
            }
            
            if (prop) {
                [tweenProperties addObject:prop];
            }
        }
        
        if (tweenProperties.count == 0) continue;
        
        UIView *targetView = [targetProxy view];
        CFTimeInterval durationSeconds = [duration floatValue] / 1000.0;
        CFTimeInterval delaySeconds = delay ? [delay floatValue] / 1000.0 : 0.0;
        
        Tween *tween = [Tween tweenWithTarget:targetView
                                   properties:tweenProperties
                                     duration:durationSeconds
                                        delay:delaySeconds
                                   easingType:easingType];
        
        [tweens addObject:tween];
    }
    
    if (tweens.count == 0) {
        NSLog(@"[ERROR] TiTween.sequence: No valid tweens created");
        return nil;
    }
    
    // Create sequence
    TweenSequence *sequence = [TweenSequence sequenceWithTweens:tweens mode:mode];
    
    if (onComplete) {
        sequence.onComplete = ^{
            [onComplete call:nil thisObject:nil];
        };
    }
    
    // Add to engine
    [[TweenEngine sharedInstance] addSequence:sequence];
    
    return sequence.sequenceId;
}

#pragma mark - Public API - Control

- (void)pause:(id)args {
    ENSURE_SINGLE_ARG(args, NSString);
    [[TweenEngine sharedInstance] pauseTween:args];
}

- (void)resume:(id)args {
    ENSURE_SINGLE_ARG(args, NSString);
    [[TweenEngine sharedInstance] resumeTween:args];
}

- (void)stop:(id)args {
    ENSURE_SINGLE_ARG(args, NSString);
    [[TweenEngine sharedInstance] stopTween:args];
}

- (void)pauseSequence:(id)args {
    ENSURE_SINGLE_ARG(args, NSString);
    [[TweenEngine sharedInstance] pauseSequence:args];
}

- (void)resumeSequence:(id)args {
    ENSURE_SINGLE_ARG(args, NSString);
    [[TweenEngine sharedInstance] resumeSequence:args];
}

- (void)stopSequence:(id)args {
    ENSURE_SINGLE_ARG(args, NSString);
    [[TweenEngine sharedInstance] stopSequence:args];
}

- (void)killAll:(id)args {
    [[TweenEngine sharedInstance] killAll];
}

@end

