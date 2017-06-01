//
//  FDSpringAnimation.h
//  BounceDemo
//
//  Created by xietao on 2017/5/27.
//  Copyright © 2017年 xietao3. All rights reserved.
//

#import "FDBaseAnimation.h"

@interface FDSpringAnimation : FDBaseAnimation

#pragma mark - optional

// 弹性动画
@property (nonatomic, assign) BOOL bounce;
// 阻尼 0-30
@property (nonatomic, assign) CGFloat damping;
// 频率 1-100
@property (nonatomic, assign) CGFloat frequency;

@end
