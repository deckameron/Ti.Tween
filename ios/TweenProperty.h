//
//  TweenProperty.h
//  TiTween
//
//  Created by Douglas Alves
//  Copyright (c) 2025. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, TweenPropertyType) {
    // Position & Size
    TweenPropertyTypeTop,
    TweenPropertyTypeLeft,
    TweenPropertyTypeWidth,
    TweenPropertyTypeHeight,
    TweenPropertyTypeCenterX,
    TweenPropertyTypeCenterY,
    
    // Visual
    TweenPropertyTypeOpacity,
    TweenPropertyTypeBackgroundColor,
    TweenPropertyTypeTintColor,
    TweenPropertyTypeTextColor,
    
    // Transform
    TweenPropertyTypeScaleX,
    TweenPropertyTypeScaleY,
    TweenPropertyTypeRotation,
    TweenPropertyTypeAnchorPoint,
    TweenPropertyTypeZPosition,
    
    // Border
    TweenPropertyTypeBorderRadius,
    TweenPropertyTypeBorderWidth,
    TweenPropertyTypeBorderColor,
    
    // Shadow
    TweenPropertyTypeShadowOpacity,
    TweenPropertyTypeShadowRadius,
    TweenPropertyTypeShadowOffsetX,
    TweenPropertyTypeShadowOffsetY,
    TweenPropertyTypeShadowColor
};

typedef NS_ENUM(NSInteger, TweenPropertyValueType) {
    TweenPropertyValueTypeFloat,
    TweenPropertyValueTypeColor,
    TweenPropertyValueTypePoint
};

@interface TweenProperty : NSObject

@property (nonatomic, assign) TweenPropertyType type;
@property (nonatomic, assign) TweenPropertyValueType valueType;

// Float values
@property (nonatomic, assign) CGFloat startValue;
@property (nonatomic, assign) CGFloat endValue;

// Color values
@property (nonatomic, strong) UIColor *startColor;
@property (nonatomic, strong) UIColor *endColor;

// Point values
@property (nonatomic, assign) CGPoint startPoint;
@property (nonatomic, assign) CGPoint endPoint;

+ (instancetype)propertyWithType:(TweenPropertyType)type startValue:(CGFloat)startValue endValue:(CGFloat)endValue;
+ (instancetype)propertyWithType:(TweenPropertyType)type startColor:(UIColor *)startColor endColor:(UIColor *)endColor;
+ (instancetype)propertyWithType:(TweenPropertyType)type startPoint:(CGPoint)startPoint endPoint:(CGPoint)endPoint;

+ (TweenPropertyType)propertyTypeFromString:(NSString *)propertyName;
+ (NSString *)stringFromPropertyType:(TweenPropertyType)type;
+ (TweenPropertyValueType)valueTypeForPropertyType:(TweenPropertyType)type;

// Extract current value from view
+ (CGFloat)currentFloatValueForProperty:(TweenPropertyType)type fromView:(UIView *)view;
+ (UIColor *)currentColorValueForProperty:(TweenPropertyType)type fromView:(UIView *)view;
+ (CGPoint)currentPointValueForProperty:(TweenPropertyType)type fromView:(UIView *)view;

// Apply interpolated value to view
+ (void)applyFloatValue:(CGFloat)value forProperty:(TweenPropertyType)type toView:(UIView *)view;
+ (void)applyColorValue:(UIColor *)color forProperty:(TweenPropertyType)type toView:(UIView *)view;
+ (void)applyPointValue:(CGPoint)point forProperty:(TweenPropertyType)type toView:(UIView *)view;

// Color utilities
+ (UIColor *)colorFromHexString:(NSString *)hexString;
+ (UIColor *)interpolateFromColor:(UIColor *)startColor toColor:(UIColor *)endColor progress:(CGFloat)progress;

@end
