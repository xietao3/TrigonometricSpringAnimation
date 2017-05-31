//
//  UIView+FDAnimation.m
//  BounceDemo
//
//  Created by xietao on 2017/5/22.
//  Copyright © 2017年 xietao3. All rights reserved.
//

#import "UIView+FDAnimation.h"
#import "FDViewAnimationManager.h"

@implementation UIView (FDAnimation)

- (void)fd_addAnimation:(FDBaseAnimation *)animation {
    animation.animationTarget = self;
    [[FDViewAnimationManager shareManager] springView:self animation:animation];
}

@end
