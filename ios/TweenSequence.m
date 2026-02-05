//
//  TweenSequence.m
//  TiTween
//
//  Created by Douglas Alves
//  Copyright (c) 2025. All rights reserved.
//

#import "TweenSequence.h"

@implementation TweenSequence

+ (instancetype)sequenceWithTweens:(NSArray<Tween *> *)tweens mode:(TweenSequenceMode)mode {
    TweenSequence *sequence = [[TweenSequence alloc] init];
    sequence->_sequenceId = [[NSUUID UUID] UUIDString];
    sequence.tweens = tweens;
    sequence.mode = mode;
    sequence.state = TweenStateIdle;
    sequence.currentTweenIndex = 0;
    return sequence;
}

- (void)start {
    if (self.state == TweenStateRunning) {
        return;
    }
    
    self.state = TweenStateRunning;
    self.currentTweenIndex = 0;
    
    if (self.mode == TweenSequenceModeSerial) {
        [self startNextTween];
    } else {
        // Parallel: start all tweens at once
        for (Tween *tween in self.tweens) {
            [tween start];
        }
    }
}

- (void)startNextTween {
    if (self.currentTweenIndex >= self.tweens.count) {
        [self complete];
        return;
    }
    
    Tween *currentTween = self.tweens[self.currentTweenIndex];
    
    __weak __typeof(self) weakSelf = self;
    currentTween.onComplete = ^(Tween *tween) {
        __strong __typeof(weakSelf) strongSelf = weakSelf;
        if (!strongSelf) return;
        
        strongSelf.currentTweenIndex++;
        [strongSelf startNextTween];
    };
    
    [currentTween start];
}

- (void)pause {
    if (self.state != TweenStateRunning) {
        return;
    }
    
    self.state = TweenStatePaused;
    
    if (self.mode == TweenSequenceModeSerial) {
        if (self.currentTweenIndex < self.tweens.count) {
            [self.tweens[self.currentTweenIndex] pause];
        }
    } else {
        for (Tween *tween in self.tweens) {
            [tween pause];
        }
    }
}

- (void)resume {
    if (self.state != TweenStatePaused) {
        return;
    }
    
    self.state = TweenStateRunning;
    
    if (self.mode == TweenSequenceModeSerial) {
        if (self.currentTweenIndex < self.tweens.count) {
            [self.tweens[self.currentTweenIndex] resume];
        }
    } else {
        for (Tween *tween in self.tweens) {
            [tween resume];
        }
    }
}

- (void)stop {
    self.state = TweenStateCompleted;
    
    for (Tween *tween in self.tweens) {
        [tween stop];
    }
}

- (void)update:(CFTimeInterval)currentTime {
    if (self.state != TweenStateRunning) {
        return;
    }
    
    if (self.mode == TweenSequenceModeSerial) {
        if (self.currentTweenIndex < self.tweens.count) {
            [self.tweens[self.currentTweenIndex] update:currentTime];
        }
    } else {
        // Parallel: update all active tweens
        BOOL allCompleted = YES;
        for (Tween *tween in self.tweens) {
            if (tween.isActive) {
                [tween update:currentTime];
                allCompleted = NO;
            } else if (tween.state != TweenStateCompleted) {
                allCompleted = NO;
            }
        }
        
        if (allCompleted) {
            [self complete];
        }
    }
}

- (void)complete {
    self.state = TweenStateCompleted;
    
    if (self.onComplete) {
        self.onComplete();
    }
}

- (BOOL)isActive {
    return self.state == TweenStateRunning;
}

- (CGFloat)progress {
    if (self.state == TweenStateIdle) {
        return 0.0;
    }
    
    if (self.state == TweenStateCompleted) {
        return 1.0;
    }
    
    if (self.tweens.count == 0) {
        return 0.0;
    }
    
    if (self.mode == TweenSequenceModeSerial) {
        // Progress based on current tween index + current tween progress
        CGFloat completedTweens = self.currentTweenIndex;
        CGFloat currentProgress = 0.0;
        
        if (self.currentTweenIndex < self.tweens.count) {
            currentProgress = [self.tweens[self.currentTweenIndex] progress];
        }
        
        return (completedTweens + currentProgress) / self.tweens.count;
    } else {
        // Parallel: average progress of all tweens
        CGFloat totalProgress = 0.0;
        for (Tween *tween in self.tweens) {
            totalProgress += [tween progress];
        }
        return totalProgress / self.tweens.count;
    }
}

@end
