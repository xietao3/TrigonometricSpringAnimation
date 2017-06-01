//
//  FDSpringAnimation.m
//  BounceDemo
//
//  Created by xietao on 2017/5/27.
//  Copyright © 2017年 xietao3. All rights reserved.
//

#import "FDSpringAnimation.h"

static const NSUInteger minDamping = 0;
static const NSUInteger maxDamping = 30;

static const NSUInteger minFrequency = 1;
static const NSUInteger maxFrequency = 100;



@implementation FDSpringAnimation
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
}





@end
