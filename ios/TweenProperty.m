//
//  TweenProperty.m
//  TiTween
//
//  Created by Douglas Alves
//  Copyright (c) 2025. All rights reserved.
//

#import "TweenProperty.h"
#import <QuartzCore/QuartzCore.h>

@implementation TweenProperty

#pragma mark - Factory Methods

+ (instancetype)propertyWithType:(TweenPropertyType)type startValue:(CGFloat)startValue endValue:(CGFloat)endValue {
    TweenProperty *property = [[TweenProperty alloc] init];
    property.type = type;
    property.valueType = TweenPropertyValueTypeFloat;
    property.startValue = startValue;
    property.endValue = endValue;
    return property;
}

+ (instancetype)propertyWithType:(TweenPropertyType)type startColor:(UIColor *)startColor endColor:(UIColor *)endColor {
    TweenProperty *property = [[TweenProperty alloc] init];
    property.type = type;
    property.valueType = TweenPropertyValueTypeColor;
    property.startColor = startColor;
    property.endColor = endColor;
    return property;
}

+ (instancetype)propertyWithType:(TweenPropertyType)type startPoint:(CGPoint)startPoint endPoint:(CGPoint)endPoint {
    TweenProperty *property = [[TweenProperty alloc] init];
    property.type = type;
    property.valueType = TweenPropertyValueTypePoint;
    property.startPoint = startPoint;
    property.endPoint = endPoint;
    return property;
}

#pragma mark - Property Type Mapping

+ (TweenPropertyType)propertyTypeFromString:(NSString *)propertyName {
    static NSDictionary *propertyMap;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        propertyMap = @{
            // Position & Size
            @"top": @(TweenPropertyTypeTop),
            @"left": @(TweenPropertyTypeLeft),
            @"width": @(TweenPropertyTypeWidth),
            @"height": @(TweenPropertyTypeHeight),
            @"centerX": @(TweenPropertyTypeCenterX),
            @"centerY": @(TweenPropertyTypeCenterY),
            
            // Visual
            @"opacity": @(TweenPropertyTypeOpacity),
            @"backgroundColor": @(TweenPropertyTypeBackgroundColor),
            @"tintColor": @(TweenPropertyTypeTintColor),
            @"textColor": @(TweenPropertyTypeTextColor),
            @"color": @(TweenPropertyTypeTextColor),
            
            // Transform
            @"scaleX": @(TweenPropertyTypeScaleX),
            @"scaleY": @(TweenPropertyTypeScaleY),
            @"rotation": @(TweenPropertyTypeRotation),
            @"anchorPoint": @(TweenPropertyTypeAnchorPoint),
            @"zPosition": @(TweenPropertyTypeZPosition),
            
            // Border
            @"borderRadius": @(TweenPropertyTypeBorderRadius),
            @"borderWidth": @(TweenPropertyTypeBorderWidth),
            @"borderColor": @(TweenPropertyTypeBorderColor),
            
            // Shadow
            @"shadowOpacity": @(TweenPropertyTypeShadowOpacity),
            @"shadowRadius": @(TweenPropertyTypeShadowRadius),
            @"shadowOffsetX": @(TweenPropertyTypeShadowOffsetX),
            @"shadowOffsetY": @(TweenPropertyTypeShadowOffsetY),
            @"shadowColor": @(TweenPropertyTypeShadowColor)
        };
    });
    
    NSNumber *typeNumber = propertyMap[propertyName];
    return typeNumber ? [typeNumber integerValue] : -1;
}

+ (NSString *)stringFromPropertyType:(TweenPropertyType)type {
    switch (type) {
        case TweenPropertyTypeTop: return @"top";
        case TweenPropertyTypeLeft: return @"left";
        case TweenPropertyTypeWidth: return @"width";
        case TweenPropertyTypeHeight: return @"height";
        case TweenPropertyTypeCenterX: return @"centerX";
        case TweenPropertyTypeCenterY: return @"centerY";
        case TweenPropertyTypeOpacity: return @"opacity";
        case TweenPropertyTypeBackgroundColor: return @"backgroundColor";
        case TweenPropertyTypeTintColor: return @"tintColor";
        case TweenPropertyTypeScaleX: return @"scaleX";
        case TweenPropertyTypeScaleY: return @"scaleY";
        case TweenPropertyTypeRotation: return @"rotation";
        case TweenPropertyTypeAnchorPoint: return @"anchorPoint";
        case TweenPropertyTypeZPosition: return @"zPosition";
        case TweenPropertyTypeBorderRadius: return @"borderRadius";
        case TweenPropertyTypeBorderWidth: return @"borderWidth";
        case TweenPropertyTypeBorderColor: return @"borderColor";
        case TweenPropertyTypeShadowOpacity: return @"shadowOpacity";
        case TweenPropertyTypeShadowRadius: return @"shadowRadius";
        case TweenPropertyTypeShadowOffsetX: return @"shadowOffsetX";
        case TweenPropertyTypeShadowOffsetY: return @"shadowOffsetY";
        case TweenPropertyTypeShadowColor: return @"shadowColor";
        default: return @"unknown";
    }
}

+ (TweenPropertyValueType)valueTypeForPropertyType:(TweenPropertyType)type {
    switch (type) {
        case TweenPropertyTypeBackgroundColor:
        case TweenPropertyTypeTintColor:
        case TweenPropertyTypeBorderColor:
        case TweenPropertyTypeShadowColor:
        case TweenPropertyTypeTextColor:
            return TweenPropertyValueTypeColor;
            
        case TweenPropertyTypeAnchorPoint:
            return TweenPropertyValueTypePoint;
            
        default:
            return TweenPropertyValueTypeFloat;
    }
}

#pragma mark - Get Current Values

+ (CGFloat)currentFloatValueForProperty:(TweenPropertyType)type fromView:(UIView *)view {
    switch (type) {
        case TweenPropertyTypeTop:
            return view.frame.origin.y;
            
        case TweenPropertyTypeLeft:
            return view.frame.origin.x;
            
        case TweenPropertyTypeWidth:
            return view.frame.size.width;
            
        case TweenPropertyTypeHeight:
            return view.frame.size.height;
            
        case TweenPropertyTypeCenterX:
            return view.center.x;
            
        case TweenPropertyTypeCenterY:
            return view.center.y;
            
        case TweenPropertyTypeOpacity:
            return view.alpha;
            
        case TweenPropertyTypeScaleX:
            return view.transform.a;
            
        case TweenPropertyTypeScaleY:
            return view.transform.d;
            
        case TweenPropertyTypeRotation: {
            CGFloat radians = atan2(view.transform.b, view.transform.a);
            return radians * (180.0 / M_PI);
        }
            
        case TweenPropertyTypeZPosition:
            return view.layer.zPosition;
            
        case TweenPropertyTypeBorderRadius:
            return view.layer.cornerRadius;
            
        case TweenPropertyTypeBorderWidth:
            return view.layer.borderWidth;
            
        case TweenPropertyTypeShadowOpacity:
            return view.layer.shadowOpacity;
            
        case TweenPropertyTypeShadowRadius:
            return view.layer.shadowRadius;
            
        case TweenPropertyTypeShadowOffsetX:
            return view.layer.shadowOffset.width;
            
        case TweenPropertyTypeShadowOffsetY:
            return view.layer.shadowOffset.height;
            
        default:
            return 0.0;
    }
}

+ (UIColor *)currentColorValueForProperty:(TweenPropertyType)type fromView:(UIView *)view {
    
    NSLog(@"🟡 [TiTween] currentColorValueForProperty called! type=%ld, view=%@",
              (long)type, NSStringFromClass([view class]));
    
    switch (type) {
            
        case TweenPropertyTypeTextColor:
            if ([view isKindOfClass:[UILabel class]]) {
                return ((UILabel *)view).textColor ?: [UIColor blackColor];
            } else if ([view isKindOfClass:[UIButton class]]) {
                return [((UIButton *)view) titleColorForState:UIControlStateNormal] ?: [UIColor blackColor];
            }
            return [UIColor blackColor];
            
        case TweenPropertyTypeBackgroundColor:
            return view.backgroundColor ?: [UIColor clearColor];
            
        case TweenPropertyTypeTintColor:
            return view.tintColor ?: [UIColor clearColor];
            
        case TweenPropertyTypeBorderColor:
            return view.layer.borderColor ? [UIColor colorWithCGColor:view.layer.borderColor] : [UIColor clearColor];
            
        case TweenPropertyTypeShadowColor:
            return view.layer.shadowColor ? [UIColor colorWithCGColor:view.layer.shadowColor] : [UIColor clearColor];
            
        default:
            return [UIColor clearColor];
    }
}

+ (CGPoint)currentPointValueForProperty:(TweenPropertyType)type fromView:(UIView *)view {
    switch (type) {
        case TweenPropertyTypeAnchorPoint:
            return view.layer.anchorPoint;
            
        default:
            return CGPointZero;
    }
}

#pragma mark - Apply Values

+ (void)applyFloatValue:(CGFloat)value forProperty:(TweenPropertyType)type toView:(UIView *)view {
    switch (type) {
        case TweenPropertyTypeTop: {
            CGRect frame = view.frame;
            frame.origin.y = value;
            view.frame = frame;
            break;
        }
            
        case TweenPropertyTypeLeft: {
            CGRect frame = view.frame;
            frame.origin.x = value;
            view.frame = frame;
            break;
        }
            
        case TweenPropertyTypeWidth: {
            CGRect frame = view.frame;
            frame.size.width = value;
            view.frame = frame;
            break;
        }
            
        case TweenPropertyTypeHeight: {
            CGRect frame = view.frame;
            frame.size.height = value;
            view.frame = frame;
            break;
        }
            
        case TweenPropertyTypeCenterX: {
            CGPoint center = view.center;
            center.x = value;
            view.center = center;
            break;
        }
            
        case TweenPropertyTypeCenterY: {
            CGPoint center = view.center;
            center.y = value;
            view.center = center;
            break;
        }
            
        case TweenPropertyTypeOpacity:
            view.alpha = value;
            break;
            
        case TweenPropertyTypeScaleX: {
            CGAffineTransform currentTransform = view.transform;
            CGFloat currentScaleY = currentTransform.d;
            CGFloat currentRotation = atan2(currentTransform.b, currentTransform.a);
            
            CGAffineTransform newTransform = CGAffineTransformMakeRotation(currentRotation);
            newTransform = CGAffineTransformScale(newTransform, value, currentScaleY);
            view.transform = newTransform;
            break;
        }
            
        case TweenPropertyTypeScaleY: {
            CGAffineTransform currentTransform = view.transform;
            CGFloat currentScaleX = currentTransform.a;
            CGFloat currentRotation = atan2(currentTransform.b, currentTransform.a);
            
            CGAffineTransform newTransform = CGAffineTransformMakeRotation(currentRotation);
            newTransform = CGAffineTransformScale(newTransform, currentScaleX, value);
            view.transform = newTransform;
            break;
        }
            
        case TweenPropertyTypeRotation: {
            CGAffineTransform currentTransform = view.transform;
            CGFloat currentScaleX = sqrt(currentTransform.a * currentTransform.a + currentTransform.c * currentTransform.c);
            CGFloat currentScaleY = sqrt(currentTransform.b * currentTransform.b + currentTransform.d * currentTransform.d);
            
            CGFloat radians = value * (M_PI / 180.0);
            CGAffineTransform newTransform = CGAffineTransformMakeRotation(radians);
            newTransform = CGAffineTransformScale(newTransform, currentScaleX, currentScaleY);
            view.transform = newTransform;
            break;
        }
            
        case TweenPropertyTypeZPosition:
            view.layer.zPosition = value;
            break;
            
        case TweenPropertyTypeBorderRadius:
            view.layer.cornerRadius = value;
            break;
            
        case TweenPropertyTypeBorderWidth:
            view.layer.borderWidth = value;
            break;
            
        case TweenPropertyTypeShadowOpacity:
            view.layer.shadowOpacity = value;
            break;
            
        case TweenPropertyTypeShadowRadius:
            view.layer.shadowRadius = value;
            break;
            
        case TweenPropertyTypeShadowOffsetX: {
            CGSize offset = view.layer.shadowOffset;
            offset.width = value;
            view.layer.shadowOffset = offset;
            break;
        }
            
        case TweenPropertyTypeShadowOffsetY: {
            CGSize offset = view.layer.shadowOffset;
            offset.height = value;
            view.layer.shadowOffset = offset;
            break;
        }
            
        default:
            break;
    }
}

+ (void)applyColorValue:(UIColor *)color forProperty:(TweenPropertyType)type toView:(UIView *)view {
    if (!color) return;
    
    NSLog(@"🟢 [TiTween] applyColorValue called! type=%ld, color=%@, view=%@",
              (long)type, color, NSStringFromClass([view class]));
        
    NSLog(@"🟣 TweenPropertyTypeTextColor enum value = %ld", (long)TweenPropertyTypeTextColor);
    NSLog(@"🟣 TweenPropertyTypeBackgroundColor enum value = %ld", (long)TweenPropertyTypeBackgroundColor);
    NSLog(@"🟣 Incoming type value = %ld", (long)type);
    NSLog(@"🟣 Does type == TweenPropertyTypeTextColor? %@", type == TweenPropertyTypeTextColor ? @"YES" : @"NO");
    
    switch (type) {
        
        case TweenPropertyTypeTextColor: {
            if (!color) break;
            
            NSLog(@"🔴 [TiTween] Trying to apply textColor to TiUILabel");
            
            // Try to access .label property (TiUILabel wrapper)
            @try {
                id nativeLabel = [view valueForKey:@"label"];
                NSLog(@"🔴 [TiTween] valueForKey:@\"label\" returned: %@ (class: %@)",
                      nativeLabel,
                      nativeLabel ? NSStringFromClass([nativeLabel class]) : @"nil");
                
                if (nativeLabel) {
                    BOOL isUILabel = [nativeLabel isKindOfClass:[UILabel class]];
                    NSLog(@"🔴 [TiTween] isKindOfClass:[UILabel class] = %@", isUILabel ? @"YES" : @"NO");
                    
                    if (isUILabel) {
                        NSLog(@"🔴 [TiTween] ✅ SUCCESS! Setting textColor");
                        ((UILabel *)nativeLabel).textColor = color;
                    }
                }
            } @catch (NSException *exception) {
                NSLog(@"🔴 [TiTween] ⚠️ EXCEPTION: %@", exception);
            }
            
            // Try button
            @try {
                id nativeButton = [view valueForKey:@"button"];
                if (nativeButton && [nativeButton isKindOfClass:[UIButton class]]) {
                    NSLog(@"🔴 [TiTween] Setting textColor on UIButton");
                    [((UIButton *)nativeButton) setTitleColor:color forState:UIControlStateNormal];
                }
            } @catch (NSException *exception) {
                NSLog(@"🔴 [TiTween] Button exception: %@", exception);
            }
            
            break;
        }
            
        case TweenPropertyTypeBackgroundColor:
            view.backgroundColor = color;
            break;
            
        case TweenPropertyTypeTintColor:
            view.tintColor = color;
            break;
            
        case TweenPropertyTypeBorderColor:
            view.layer.borderColor = color.CGColor;
            break;
            
        case TweenPropertyTypeShadowColor:
            view.layer.shadowColor = color.CGColor;
            break;
            
        default:
            break;
    }
}

+ (void)applyPointValue:(CGPoint)point forProperty:(TweenPropertyType)type toView:(UIView *)view {
    switch (type) {
        case TweenPropertyTypeAnchorPoint:
            view.layer.anchorPoint = point;
            break;
            
        default:
            break;
    }
}

#pragma mark - Color Utilities

+ (UIColor *)colorFromHexString:(NSString *)hexString {
    if (!hexString || hexString.length == 0) {
        return [UIColor clearColor];
    }
    
    NSString *cleanString = [hexString stringByReplacingOccurrencesOfString:@"#" withString:@""];
    cleanString = [cleanString stringByReplacingOccurrencesOfString:@"0x" withString:@""];
    
    unsigned int rgb = 0;
    NSScanner *scanner = [NSScanner scannerWithString:cleanString];
    [scanner scanHexInt:&rgb];
    
    CGFloat red, green, blue, alpha = 1.0;
    
    if (cleanString.length == 8) {
        // RGBA
        red = ((rgb >> 24) & 0xFF) / 255.0;
        green = ((rgb >> 16) & 0xFF) / 255.0;
        blue = ((rgb >> 8) & 0xFF) / 255.0;
        alpha = (rgb & 0xFF) / 255.0;
    } else {
        // RGB
        red = ((rgb >> 16) & 0xFF) / 255.0;
        green = ((rgb >> 8) & 0xFF) / 255.0;
        blue = (rgb & 0xFF) / 255.0;
    }
    
    return [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
}

+ (UIColor *)interpolateFromColor:(UIColor *)startColor toColor:(UIColor *)endColor progress:(CGFloat)progress {
    if (!startColor || !endColor) {
        return startColor ?: endColor;
    }
    
    CGFloat r1, g1, b1, a1;
    CGFloat r2, g2, b2, a2;
    
    [startColor getRed:&r1 green:&g1 blue:&b1 alpha:&a1];
    [endColor getRed:&r2 green:&g2 blue:&b2 alpha:&a2];
    
    CGFloat r = r1 + (r2 - r1) * progress;
    CGFloat g = g1 + (g2 - g1) * progress;
    CGFloat b = b1 + (b2 - b1) * progress;
    CGFloat a = a1 + (a2 - a1) * progress;
    
    return [UIColor colorWithRed:r green:g blue:b alpha:a];
}

@end
