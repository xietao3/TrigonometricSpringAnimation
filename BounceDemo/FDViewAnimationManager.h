//
//  FDViewAnimationManager.h
//  BounceDemo
//
//  Created by xietao on 2017/5/17.
//  Copyright © 2017年 xietao3. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FDBaseAnimation.h"

@import UIKit;


@interface FDViewAnimationManager : NSObject

+ (instancetype)shareManager;

- (void)springView:(UIView *)view animation:(FDBaseAnimation *)animation ;

@end
