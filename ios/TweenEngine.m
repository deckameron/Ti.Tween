//
//  TweenEngine.h
//  TiTween
//
//  Created by Douglas Alves
//  Copyright (c) 2025. All rights reserved.
//

#import "TweenEngine.h"

@implementation TweenEngine

+ (instancetype)sharedInstance {
    static TweenEngine *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _activeTweens = [NSMutableDictionary dictionary];
        _activeSequences = [NSMutableDictionary dictionary];
        [self setupDisplayLink];
    }
    return self;
}

- (void)setupDisplayLink {
    self.displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(update:)];
    
    // Set to highest frame rate possible (120Hz on ProMotion, 60Hz on standard)
    if (@available(iOS 15.0, *)) {
        self.displayLink.preferredFrameRateRange = CAFrameRateRangeMake(80, 120, 120);
    } else {
        self.displayLink.preferredFramesPerSecond = 120;
    }
    
    [self.displayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
}

- (void)update:(CADisplayLink *)displayLink {
    CFTimeInterval currentTime = CFAbsoluteTimeGetCurrent();
    
    // Update all active tweens
    NSMutableArray *completedTweenIds = [NSMutableArray array];
    for (NSString *tweenId in self.activeTweens) {
        Tween *tween = self.activeTweens[tweenId];
        [tween update:currentTime];
        
        if (tween.state == TweenStateCompleted) {
            [completedTweenIds addObject:tweenId];
        }
    }
    
    // Remove completed tweens
    for (NSString *tweenId in completedTweenIds) {
        [self.activeTweens removeObjectForKey:tweenId];
    }
    
    // Update all active sequences
    NSMutableArray *completedSequenceIds = [NSMutableArray array];
    for (NSString *sequenceId in self.activeSequences) {
        TweenSequence *sequence = self.activeSequences[sequenceId];
        [sequence update:currentTime];
        
        if (sequence.state == TweenStateCompleted) {
            [completedSequenceIds addObject:sequenceId];
        }
    }
    
    // Remove completed sequences
    for (NSString *sequenceId in completedSequenceIds) {
        [self.activeSequences removeObjectForKey:sequenceId];
    }
    
    // Pause display link if no active animations
    if (self.activeTweens.count == 0 && self.activeSequences.count == 0) {
        self.displayLink.paused = YES;
    }
}

#pragma mark - Tween Management

- (void)addTween:(Tween *)tween {
    if (!tween || !tween.tweenId) {
        return;
    }
    
    self.activeTweens[tween.tweenId] = tween;
    [tween start];
    
    // Ensure display link is running
    self.displayLink.paused = NO;
}

- (void)removeTween:(NSString *)tweenId {
    if (!tweenId) {
        return;
    }
    
    [self.activeTweens removeObjectForKey:tweenId];
}

- (Tween *)getTween:(NSString *)tweenId {
    if (!tweenId) {
        return nil;
    }
    
    return self.activeTweens[tweenId];
}

#pragma mark - Sequence Management

- (void)addSequence:(TweenSequence *)sequence {
    if (!sequence || !sequence.sequenceId) {
        return;
    }
    
    self.activeSequences[sequence.sequenceId] = sequence;
    [sequence start];
    
    // Ensure display link is running
    self.displayLink.paused = NO;
}

- (void)removeSequence:(NSString *)sequenceId {
    if (!sequenceId) {
        return;
    }
    
    [self.activeSequences removeObjectForKey:sequenceId];
}

- (TweenSequence *)getSequence:(NSString *)sequenceId {
    if (!sequenceId) {
        return nil;
    }
    
    return self.activeSequences[sequenceId];
}

#pragma mark - Control

- (void)pauseTween:(NSString *)tweenId {
    Tween *tween = [self getTween:tweenId];
    if (tween) {
        [tween pause];
    }
}

- (void)resumeTween:(NSString *)tweenId {
    Tween *tween = [self getTween:tweenId];
    if (tween) {
        [tween resume];
        self.displayLink.paused = NO;
    }
}

- (void)stopTween:(NSString *)tweenId {
    Tween *tween = [self getTween:tweenId];
    if (tween) {
        [tween stop];
        [self removeTween:tweenId];
    }
}

- (void)pauseSequence:(NSString *)sequenceId {
    TweenSequence *sequence = [self getSequence:sequenceId];
    if (sequence) {
        [sequence pause];
    }
}

- (void)resumeSequence:(NSString *)sequenceId {
    TweenSequence *sequence = [self getSequence:sequenceId];
    if (sequence) {
        [sequence resume];
        self.displayLink.paused = NO;
    }
}

- (void)stopSequence:(NSString *)sequenceId {
    TweenSequence *sequence = [self getSequence:sequenceId];
    if (sequence) {
        [sequence stop];
        [self removeSequence:sequenceId];
    }
}

- (void)killAll {
    // Stop and remove all tweens
    for (NSString *tweenId in [self.activeTweens allKeys]) {
        Tween *tween = self.activeTweens[tweenId];
        [tween stop];
    }
    [self.activeTweens removeAllObjects];
    
    // Stop and remove all sequences
    for (NSString *sequenceId in [self.activeSequences allKeys]) {
        TweenSequence *sequence = self.activeSequences[sequenceId];
        [sequence stop];
    }
    [self.activeSequences removeAllObjects];
    
    // Pause display link
    self.displayLink.paused = YES;
}

- (void)dealloc {
    [self.displayLink invalidate];
    self.displayLink = nil;
}

@end
