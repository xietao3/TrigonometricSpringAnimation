//
//  UIView+FDAnimation.h
//  BounceDemo
//
//  Created by xietao on 2017/5/22.
//  Copyright © 2017年 xietao3. All rights reserved.
//

#import <UIKit/UIKit.h>
@class FDBaseAnimation;
@interface UIView (FDAnimation)


- (void)fd_addAnimation:(FDBaseAnimation *)animation;
@end
