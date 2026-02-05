//
//  EasingFunctions.h
//  TiTween
//
//  Created by Douglas Alves
//  Copyright (c) 2025. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, TweenEasingType) {
    TweenEasingTypeLinear = 0,
    
    // Quad
    TweenEasingTypeInQuad,
    TweenEasingTypeOutQuad,
    TweenEasingTypeInOutQuad,
    
    // Cubic
    TweenEasingTypeInCubic,
    TweenEasingTypeOutCubic,
    TweenEasingTypeInOutCubic,
    
    // Quart
    TweenEasingTypeInQuart,
    TweenEasingTypeOutQuart,
    TweenEasingTypeInOutQuart,
    
    // Quint
    TweenEasingTypeInQuint,
    TweenEasingTypeOutQuint,
    TweenEasingTypeInOutQuint,
    
    // Expo
    TweenEasingTypeInExpo,
    TweenEasingTypeOutExpo,
    TweenEasingTypeInOutExpo,
    
    // Sine
    TweenEasingTypeInSine,
    TweenEasingTypeOutSine,
    TweenEasingTypeInOutSine,
    
    // Elastic
    TweenEasingTypeInElastic,
    TweenEasingTypeOutElastic,
    TweenEasingTypeInOutElastic,
    
    // Back
    TweenEasingTypeInBack,
    TweenEasingTypeOutBack,
    TweenEasingTypeInOutBack,
    
    // Bounce
    TweenEasingTypeInBounce,
    TweenEasingTypeOutBounce,
    TweenEasingTypeInOutBounce,
    
    // Custom cubic-bezier
    TweenEasingTypeCubicBezier
};

@interface EasingFunctions : NSObject

// Main easing function dispatcher
+ (CGFloat)ease:(CGFloat)t type:(TweenEasingType)type;

// Cubic bezier (for custom easing)
+ (CGFloat)cubicBezier:(CGFloat)t p1x:(CGFloat)p1x p1y:(CGFloat)p1y p2x:(CGFloat)p2x p2y:(CGFloat)p2y;

// Individual easing functions
+ (CGFloat)linear:(CGFloat)t;

+ (CGFloat)inQuad:(CGFloat)t;
+ (CGFloat)outQuad:(CGFloat)t;
+ (CGFloat)inOutQuad:(CGFloat)t;

+ (CGFloat)inCubic:(CGFloat)t;
+ (CGFloat)outCubic:(CGFloat)t;
+ (CGFloat)inOutCubic:(CGFloat)t;

+ (CGFloat)inQuart:(CGFloat)t;
+ (CGFloat)outQuart:(CGFloat)t;
+ (CGFloat)inOutQuart:(CGFloat)t;

+ (CGFloat)inQuint:(CGFloat)t;
+ (CGFloat)outQuint:(CGFloat)t;
+ (CGFloat)inOutQuint:(CGFloat)t;

+ (CGFloat)inExpo:(CGFloat)t;
+ (CGFloat)outExpo:(CGFloat)t;
+ (CGFloat)inOutExpo:(CGFloat)t;

+ (CGFloat)inSine:(CGFloat)t;
+ (CGFloat)outSine:(CGFloat)t;
+ (CGFloat)inOutSine:(CGFloat)t;

+ (CGFloat)inElastic:(CGFloat)t;
+ (CGFloat)outElastic:(CGFloat)t;
+ (CGFloat)inOutElastic:(CGFloat)t;

+ (CGFloat)inBack:(CGFloat)t;
+ (CGFloat)outBack:(CGFloat)t;
+ (CGFloat)inOutBack:(CGFloat)t;

+ (CGFloat)inBounce:(CGFloat)t;
+ (CGFloat)outBounce:(CGFloat)t;
+ (CGFloat)inOutBounce:(CGFloat)t;

@end
