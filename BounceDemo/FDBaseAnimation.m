//
//  FDBaseAnimation.m
//  BounceDemo
//
//  Created by xietao on 2017/5/26.
//  Copyright © 2017年 xietao3. All rights reserved.
//

#import "FDBaseAnimation.h"

static const CGFloat minSpeed = 0.001;
static const CGFloat maxSpeed = 0.1;


@implementation FDBaseAnimation

+ (instancetype)animationType:(FDAnimationType)type {
    FDBaseAnimation *animation = [[self alloc] init];
    animation.animationType = type;
    return animation;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.timeLineX = 0;
        self.lastY = 0;
        self.finished = NO;
    }
    return self;
}


- (void)setSpeed:(CGFloat)speed {
    _speed = speed;
    [self checkData];
}

#pragma mark - PrivateMethod
- (void)checkData {
    _speed      = MAX(MIN(_speed, maxSpeed), minSpeed);
}

@end
