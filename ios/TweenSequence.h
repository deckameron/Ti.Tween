//
//  TweenSequence.h
//  TiTween
//
//  Created by Douglas Alves
//  Copyright (c) 2025. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Tween.h"

typedef NS_ENUM(NSInteger, TweenSequenceMode) {
    TweenSequenceModeSerial,   // One after another
    TweenSequenceModeParallel  // All at the same time
};

typedef void(^TweenSequenceCompletionBlock)(void);

@interface TweenSequence : NSObject

@property (nonatomic, copy, readonly) NSString *sequenceId;
@property (nonatomic, strong) NSArray<Tween *> *tweens;
@property (nonatomic, assign) TweenSequenceMode mode;
@property (nonatomic, assign) TweenState state;
@property (nonatomic, assign) NSInteger currentTweenIndex; // Only for serial mode
@property (nonatomic, copy) TweenSequenceCompletionBlock onComplete;

+ (instancetype)sequenceWithTweens:(NSArray<Tween *> *)tweens mode:(TweenSequenceMode)mode;

- (void)start;
- (void)pause;
- (void)resume;
- (void)stop;
- (void)update:(CFTimeInterval)currentTime;

- (BOOL)isActive;
- (CGFloat)progress; // 0.0 to 1.0

@end
