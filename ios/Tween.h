//
//  Tween.h
//  TiTween
//
//  Created by Douglas Alves
//  Copyright (c) 2025. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "EasingFunctions.h"
#import "TweenProperty.h"

typedef NS_ENUM(NSInteger, TweenState) {
    TweenStateIdle,
    TweenStateDelaying,
    TweenStateRunning,
    TweenStatePaused,
    TweenStateCompleted
};

@class Tween;

typedef void(^TweenCompletionBlock)(Tween *tween);
typedef void(^TweenUpdateBlock)(Tween *tween);

@interface Tween : NSObject

@property (nonatomic, copy, readonly) NSString *tweenId;
@property (nonatomic, weak) UIView *targetView;
@property (nonatomic, strong) NSArray<TweenProperty *> *properties;
@property (nonatomic, assign) CFTimeInterval duration;       // in seconds
@property (nonatomic, assign) CFTimeInterval delay;          // in seconds
@property (nonatomic, assign) TweenEasingType easingType;
@property (nonatomic, assign) TweenState state;

// Cubic bezier parameters (only used when easingType == TweenEasingTypeCubicBezier)
@property (nonatomic, assign) CGFloat bezierP1X;
@property (nonatomic, assign) CGFloat bezierP1Y;
@property (nonatomic, assign) CGFloat bezierP2X;
@property (nonatomic, assign) CGFloat bezierP2Y;

// Callbacks
@property (nonatomic, copy) TweenCompletionBlock onComplete;
@property (nonatomic, copy) TweenUpdateBlock onUpdate;

// Internal timing
@property (nonatomic, assign) CFTimeInterval startTime;
@property (nonatomic, assign) CFTimeInterval pausedTime;
@property (nonatomic, assign) CFTimeInterval accumulatedPausedDuration;

+ (instancetype)tweenWithTarget:(UIView *)target
                     properties:(NSArray<TweenProperty *> *)properties
                       duration:(CFTimeInterval)duration
                          delay:(CFTimeInterval)delay
                     easingType:(TweenEasingType)easingType;

- (void)start;
- (void)pause;
- (void)resume;
- (void)stop;
- (void)update:(CFTimeInterval)currentTime;

- (BOOL)isActive;
- (CGFloat)progress; // 0.0 to 1.0

@end
