//
//  TweenEngine.h
//  TiTween
//
//  Created by Douglas Alves
//  Copyright (c) 2025. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>
#import "Tween.h"
#import "TweenSequence.h"

@interface TweenEngine : NSObject

@property (nonatomic, strong) CADisplayLink *displayLink;
@property (nonatomic, strong) NSMutableDictionary<NSString *, Tween *> *activeTweens;
@property (nonatomic, strong) NSMutableDictionary<NSString *, TweenSequence *> *activeSequences;

+ (instancetype)sharedInstance;

// Tween management
- (void)addTween:(Tween *)tween;
- (void)removeTween:(NSString *)tweenId;
- (Tween *)getTween:(NSString *)tweenId;

// Sequence management
- (void)addSequence:(TweenSequence *)sequence;
- (void)removeSequence:(NSString *)sequenceId;
- (TweenSequence *)getSequence:(NSString *)sequenceId;

// Control
- (void)pauseTween:(NSString *)tweenId;
- (void)resumeTween:(NSString *)tweenId;
- (void)stopTween:(NSString *)tweenId;

- (void)pauseSequence:(NSString *)sequenceId;
- (void)resumeSequence:(NSString *)sequenceId;
- (void)stopSequence:(NSString *)sequenceId;

- (void)killAll;

@end
