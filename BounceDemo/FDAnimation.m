//
//  FDAnimation.m
//  BounceDemo
//
//  Created by xietao on 2017/5/21.
//  Copyright © 2017年 xietao3. All rights reserved.
//

#import "FDAnimation.h"

static const NSUInteger minDamping = 0;
static const NSUInteger maxDamping = 30;

static const NSUInteger minFrequency = 1;
static const NSUInteger maxFrequency = 100;

static const CGFloat minSpeed = 0.001;
static const CGFloat maxSpeed = 0.1;


@implementation FDAnimation

+ (instancetype)animationType:(FDAnimationType)type {
    FDAnimation *animation = [[self alloc] init];
    animation.animationType = type;
    return animation;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.damping = 10;
        self.frequency = 21;
        self.speed = 0.01;
    }
    return self;
}

- (void)setSpeed:(CGFloat)speed {
    _speed = speed;
    [self checkData];
}

- (void)setDamping:(CGFloat)damping {
    _damping = damping;
    [self checkData];
}

- (void)setFrequency:(CGFloat)frequency {
    _frequency = frequency;
    [self checkData];
}

#pragma mark - PrivateMethod
- (void)checkData {
    _damping    = MAX(MIN(_damping, maxDamping), minDamping);
    _frequency  = MAX(MIN(_frequency, maxFrequency), minFrequency);
    _speed      = MAX(MIN(_speed, maxSpeed), minSpeed);
}


@end
