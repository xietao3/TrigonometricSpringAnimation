//
//  FDBaseAnimation.h
//  BounceDemo
//
//  Created by xietao on 2017/5/26.
//  Copyright © 2017年 xietao3. All rights reserved.
//

#import <Foundation/Foundation.h>
@import UIKit;

typedef NS_ENUM(NSUInteger, FDAnimationType) {
    FDAnimationTypePosition,
    FDAnimationTypeSize,
    FDAnimationTypeScale
};

@interface FDBaseAnimation : NSObject

#pragma mark required
@property (nonatomic, assign) FDAnimationType animationType;

@property (copy, nonatomic) id fromValue;

@property (copy, nonatomic) id toValue;

@property (nonatomic, weak) id animationTarget;


#pragma mark - optional
// 速度0.001-0.1
@property (nonatomic, assign) CGFloat speed;
// 取绝对值
@property (nonatomic, assign) BOOL needFabs;

@property (nonatomic, copy) void (^completionBlock)(FDBaseAnimation *animation, BOOL finished) ;

#pragma mark - ignore

@property (nonatomic, assign) CGFloat lastY;

@property (nonatomic, assign) float timeLineX;

@property (nonatomic, assign) BOOL finished;


+ (instancetype)animationType:(FDAnimationType)type;

@end
