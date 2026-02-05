//
//  EasingFunctions.m
//  TiTween
//
//  Created by Douglas Alves
//  Copyright (c) 2025. All rights reserved.
//

#import "EasingFunctions.h"
#import <math.h>

#ifndef M_PI
    #define M_PI 3.14159265358979323846
#endif

@implementation EasingFunctions

+ (CGFloat)ease:(CGFloat)t type:(TweenEasingType)type {
    switch (type) {
        case TweenEasingTypeLinear: return [self linear:t];
            
        case TweenEasingTypeInQuad: return [self inQuad:t];
        case TweenEasingTypeOutQuad: return [self outQuad:t];
        case TweenEasingTypeInOutQuad: return [self inOutQuad:t];
            
        case TweenEasingTypeInCubic: return [self inCubic:t];
        case TweenEasingTypeOutCubic: return [self outCubic:t];
        case TweenEasingTypeInOutCubic: return [self inOutCubic:t];
            
        case TweenEasingTypeInQuart: return [self inQuart:t];
        case TweenEasingTypeOutQuart: return [self outQuart:t];
        case TweenEasingTypeInOutQuart: return [self inOutQuart:t];
            
        case TweenEasingTypeInQuint: return [self inQuint:t];
        case TweenEasingTypeOutQuint: return [self outQuint:t];
        case TweenEasingTypeInOutQuint: return [self inOutQuint:t];
            
        case TweenEasingTypeInExpo: return [self inExpo:t];
        case TweenEasingTypeOutExpo: return [self outExpo:t];
        case TweenEasingTypeInOutExpo: return [self inOutExpo:t];
            
        case TweenEasingTypeInSine: return [self inSine:t];
        case TweenEasingTypeOutSine: return [self outSine:t];
        case TweenEasingTypeInOutSine: return [self inOutSine:t];
            
        case TweenEasingTypeInElastic: return [self inElastic:t];
        case TweenEasingTypeOutElastic: return [self outElastic:t];
        case TweenEasingTypeInOutElastic: return [self inOutElastic:t];
            
        case TweenEasingTypeInBack: return [self inBack:t];
        case TweenEasingTypeOutBack: return [self outBack:t];
        case TweenEasingTypeInOutBack: return [self inOutBack:t];
            
        case TweenEasingTypeInBounce: return [self inBounce:t];
        case TweenEasingTypeOutBounce: return [self outBounce:t];
        case TweenEasingTypeInOutBounce: return [self inOutBounce:t];
            
        default: return t;
    }
}

#pragma mark - Linear

+ (CGFloat)linear:(CGFloat)t {
    return t;
}

#pragma mark - Quad

+ (CGFloat)inQuad:(CGFloat)t {
    return t * t;
}

+ (CGFloat)outQuad:(CGFloat)t {
    return t * (2.0 - t);
}

+ (CGFloat)inOutQuad:(CGFloat)t {
    if (t < 0.5) {
        return 2.0 * t * t;
    }
    return -1.0 + (4.0 - 2.0 * t) * t;
}

#pragma mark - Cubic

+ (CGFloat)inCubic:(CGFloat)t {
    return t * t * t;
}

+ (CGFloat)outCubic:(CGFloat)t {
    CGFloat f = t - 1.0;
    return f * f * f + 1.0;
}

+ (CGFloat)inOutCubic:(CGFloat)t {
    if (t < 0.5) {
        return 4.0 * t * t * t;
    }
    CGFloat f = (2.0 * t) - 2.0;
    return 0.5 * f * f * f + 1.0;
}

#pragma mark - Quart

+ (CGFloat)inQuart:(CGFloat)t {
    return t * t * t * t;
}

+ (CGFloat)outQuart:(CGFloat)t {
    CGFloat f = t - 1.0;
    return 1.0 - f * f * f * f;
}

+ (CGFloat)inOutQuart:(CGFloat)t {
    if (t < 0.5) {
        return 8.0 * t * t * t * t;
    }
    CGFloat f = t - 1.0;
    return 1.0 - 8.0 * f * f * f * f;
}

#pragma mark - Quint

+ (CGFloat)inQuint:(CGFloat)t {
    return t * t * t * t * t;
}

+ (CGFloat)outQuint:(CGFloat)t {
    CGFloat f = t - 1.0;
    return f * f * f * f * f + 1.0;
}

+ (CGFloat)inOutQuint:(CGFloat)t {
    if (t < 0.5) {
        return 16.0 * t * t * t * t * t;
    }
    CGFloat f = (2.0 * t) - 2.0;
    return 0.5 * f * f * f * f * f + 1.0;
}

#pragma mark - Expo

+ (CGFloat)inExpo:(CGFloat)t {
    if (t == 0.0) return 0.0;
    return pow(2.0, 10.0 * (t - 1.0));
}

+ (CGFloat)outExpo:(CGFloat)t {
    if (t == 1.0) return 1.0;
    return 1.0 - pow(2.0, -10.0 * t);
}

+ (CGFloat)inOutExpo:(CGFloat)t {
    if (t == 0.0 || t == 1.0) return t;
    
    if (t < 0.5) {
        return 0.5 * pow(2.0, (20.0 * t) - 10.0);
    }
    return 0.5 * (2.0 - pow(2.0, -20.0 * t + 10.0));
}

#pragma mark - Sine

+ (CGFloat)inSine:(CGFloat)t {
    return 1.0 - cos(t * M_PI_2);
}

+ (CGFloat)outSine:(CGFloat)t {
    return sin(t * M_PI_2);
}

+ (CGFloat)inOutSine:(CGFloat)t {
    return 0.5 * (1.0 - cos(M_PI * t));
}

#pragma mark - Elastic

+ (CGFloat)inElastic:(CGFloat)t {
    if (t == 0.0 || t == 1.0) return t;
    
    CGFloat p = 0.3;
    CGFloat s = p / 4.0;
    CGFloat postFix = pow(2.0, 10.0 * (t - 1.0));
    return -(postFix * sin((t - 1.0 - s) * (2.0 * M_PI) / p));
}

+ (CGFloat)outElastic:(CGFloat)t {
    if (t == 0.0 || t == 1.0) return t;
    
    CGFloat p = 0.3;
    CGFloat s = p / 4.0;
    return pow(2.0, -10.0 * t) * sin((t - s) * (2.0 * M_PI) / p) + 1.0;
}

+ (CGFloat)inOutElastic:(CGFloat)t {
    if (t == 0.0 || t == 1.0) return t;
    
    CGFloat p = 0.3 * 1.5;
    CGFloat s = p / 4.0;
    
    if (t < 0.5) {
        CGFloat postFix = pow(2.0, 10.0 * (2.0 * t - 1.0));
        return -0.5 * (postFix * sin((2.0 * t - 1.0 - s) * (2.0 * M_PI) / p));
    }
    
    CGFloat postFix = pow(2.0, -10.0 * (2.0 * t - 1.0));
    return postFix * sin((2.0 * t - 1.0 - s) * (2.0 * M_PI) / p) * 0.5 + 1.0;
}

#pragma mark - Back

+ (CGFloat)inBack:(CGFloat)t {
    CGFloat s = 1.70158;
    return t * t * ((s + 1.0) * t - s);
}

+ (CGFloat)outBack:(CGFloat)t {
    CGFloat s = 1.70158;
    CGFloat f = t - 1.0;
    return f * f * ((s + 1.0) * f + s) + 1.0;
}

+ (CGFloat)inOutBack:(CGFloat)t {
    CGFloat s = 1.70158 * 1.525;
    
    if (t < 0.5) {
        CGFloat f = 2.0 * t;
        return 0.5 * (f * f * ((s + 1.0) * f - s));
    }
    
    CGFloat f = 2.0 * t - 2.0;
    return 0.5 * (f * f * ((s + 1.0) * f + s) + 2.0);
}

#pragma mark - Bounce

+ (CGFloat)outBounce:(CGFloat)t {
    if (t < (1.0 / 2.75)) {
        return 7.5625 * t * t;
    } else if (t < (2.0 / 2.75)) {
        CGFloat f = t - (1.5 / 2.75);
        return 7.5625 * f * f + 0.75;
    } else if (t < (2.5 / 2.75)) {
        CGFloat f = t - (2.25 / 2.75);
        return 7.5625 * f * f + 0.9375;
    } else {
        CGFloat f = t - (2.625 / 2.75);
        return 7.5625 * f * f + 0.984375;
    }
}

+ (CGFloat)inBounce:(CGFloat)t {
    return 1.0 - [self outBounce:(1.0 - t)];
}

+ (CGFloat)inOutBounce:(CGFloat)t {
    if (t < 0.5) {
        return [self inBounce:(t * 2.0)] * 0.5;
    }
    return [self outBounce:(t * 2.0 - 1.0)] * 0.5 + 0.5;
}

#pragma mark - Cubic Bezier

+ (CGFloat)cubicBezier:(CGFloat)t p1x:(CGFloat)p1x p1y:(CGFloat)p1y p2x:(CGFloat)p2x p2y:(CGFloat)p2y {
    // Simplified cubic bezier using Newton-Raphson iteration
    // For x(t) = 3(1-t)²t*p1x + 3(1-t)t²*p2x + t³
    // We need to find t for a given x, then compute y(t)
    
    CGFloat epsilon = 1e-6;
    CGFloat x = t;
    CGFloat t2 = t;
    
    // Newton-Raphson iteration (max 8 iterations)
    for (int i = 0; i < 8; i++) {
        CGFloat x2 = 3.0 * (1.0 - t2) * (1.0 - t2) * t2 * p1x +
                     3.0 * (1.0 - t2) * t2 * t2 * p2x +
                     t2 * t2 * t2;
        
        if (fabs(x2 - x) < epsilon) break;
        
        CGFloat d = 3.0 * (1.0 - t2) * (1.0 - t2) * p1x +
                    6.0 * (1.0 - t2) * t2 * (p2x - p1x) +
                    3.0 * t2 * t2 * (1.0 - p2x);
        
        if (fabs(d) < epsilon) break;
        
        t2 = t2 - (x2 - x) / d;
    }
    
    // Compute y(t2)
    CGFloat y = 3.0 * (1.0 - t2) * (1.0 - t2) * t2 * p1y +
                3.0 * (1.0 - t2) * t2 * t2 * p2y +
                t2 * t2 * t2;
    
    return y;
}

@end
