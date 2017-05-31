//
//  FDAnimation.h
//  BounceDemo
//
//  Created by xietao on 2017/5/21.
//  Copyright © 2017年 xietao3. All rights reserved.
//

#import <Foundation/Foundation.h>
@import UIKit;

typedef NS_ENUM(NSUInteger, FDAnimationType) {
    FDAnimationTypePosition,
    FDAnimationTypeSize
};


@interface FDAnimation : NSObject

+ (instancetype)animationType:(FDAnimationType)type;

#pragma mark required
@property (nonatomic, assign) FDAnimationType animationType;

@property (copy, nonatomic) id fromValue;

@property (copy, nonatomic) id toValue;

#pragma mark - optional
// 速度0.001-0.1
@property (nonatomic, assign) CGFloat speed;
// 阻尼 0-30
@property (nonatomic, assign) CGFloat damping;
// 频率 1-100
@property (nonatomic, assign) CGFloat frequency;
// 取绝对值
@property (nonatomic, assign) BOOL needFabs;

@end
