//
//  FDViewAnimationManager.m
//  BounceDemo
//
//  Created by xietao on 2017/5/17.
//  Copyright © 2017年 xietao3. All rights reserved.
//

#import "FDViewAnimationManager.h"
#import "FDSpringAnimation.h"

@interface FDViewAnimationManager ()

@property (nonatomic, strong) CADisplayLink *displayLink;

@property (nonatomic,strong) NSMutableArray *animations;

@property (nonatomic, assign) NSInteger animationCount;

@end

@implementation FDViewAnimationManager

+ (instancetype)shareManager {
    static FDViewAnimationManager *shareInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shareInstance = [[FDViewAnimationManager alloc] init];
    });
    return shareInstance;
}


- (instancetype)init
{
    self = [super init];
    if (self) {
        self.displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(updateDisplayLink)];
        [self.displayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
        self.displayLink.paused = YES;
        self.animations = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)springView:(UIView *)view animation:(id)animation {
    if (animation) {
        [self.animations addObject:[animation copy]];
        self.animationCount = self.animations.count;
        [self startDisplayLink];
    }
}


#pragma mark - CADisplayLink
- (void)startDisplayLink {
    self.displayLink.paused = NO;
}

- (void)stopDisplayLink {
    self.displayLink.paused = YES;
}

- (void)updateDisplayLink {
    if (self.animations.count > 0) {
        for (int i = 0; i < self.animations.count; i++) {
            FDBaseAnimation *anim = self.animations[i];
            [self updateAnimation:anim];
        }
    }
    
}

- (void)updateAnimation:(FDBaseAnimation *)animation {
    UIView *animationView = animation.animationTarget;

    
    float timeLineY = 0;
    if ([animation isMemberOfClass:[FDSpringAnimation class]] && ((FDSpringAnimation *)animation).bounce) {
        animation.timeLineX+=animation.speed;
        timeLineY = [self getSpringAnimation:(FDSpringAnimation *)animation springOffset:animation.timeLineX];
        [self checkStopSpringAnimation:animation  timeLineY:timeLineY];

    }else{
        animation.timeLineX+=animation.speed*2;
        timeLineY = [self getAnimation:animation springOffset:animation.timeLineX];
        [self checkStopAnimation:animation  timeLineY:timeLineY];
    }
    
    if (animation.animationType == FDAnimationTypePosition) {
        CGRect tempFrame = animationView.frame;
        NSValue *fromValue = animation.fromValue;
        CGPoint startPoint = fromValue.CGPointValue;
        NSValue *toValue = animation.toValue;
        CGPoint endPoint = toValue.CGPointValue;
        
        tempFrame.origin.x = startPoint.x+(endPoint.x - startPoint.x)*timeLineY;
        tempFrame.origin.y = startPoint.y+(endPoint.y - startPoint.y)*timeLineY;
        animationView.frame = tempFrame;

    }else if (animation.animationType == FDAnimationTypeSize) {
        CGPoint tempCenter = animationView.center;
        CGRect tempFrame = animationView.frame;
        NSValue *fromValue = animation.fromValue;
        CGSize startSize = fromValue.CGSizeValue;
        NSValue *toValue = animation.toValue;
        CGSize endSize = toValue.CGSizeValue;
        tempFrame.size.width = startSize.width+(endSize.width - startSize.width)*timeLineY;
        tempFrame.size.height = startSize.height+(endSize.height - startSize.height)*timeLineY;
        animationView.frame = tempFrame;
        animationView.center = tempCenter;
    }else if (animation.animationType == FDAnimationTypeScale) {
        CGPoint tempCenter = animationView.center;

        NSValue *fromValue = animation.fromValue;
        CGSize startScaleSize = fromValue.CGSizeValue;

        NSValue *toValue = animation.toValue;
        CGSize endScaleSize = toValue.CGSizeValue;

        CGFloat scaleWidth = startScaleSize.width+(endScaleSize.width - startScaleSize.width)*timeLineY;
        CGFloat scaleHeight = startScaleSize.height+(endScaleSize.height - startScaleSize.height)*timeLineY;
//        animationView.transform = CGAffineTransformIdentity;

        animationView.transform = CGAffineTransformMakeScale(scaleWidth,scaleHeight);
        animationView.center = tempCenter;
    }

}

- (void)checkStopAnimation:(FDBaseAnimation *)animation timeLineY:(float)y {
    if (fabs(y)>fabs(animation.lastY) && animation.lastY != 0) {
        animation.timeLineX = 0;
        animation.finished = YES;
        if (animation.completionBlock) {
            animation.completionBlock(animation,animation.finished);
        }
        [self.animations removeObject:animation];
        self.animationCount--;
        if (self.animations.count == 0) {
            [self stopDisplayLink];
        }

    }
    animation.lastY = y;

}

- (void)checkStopSpringAnimation:(FDBaseAnimation *)animation timeLineY:(float)y {
    if (fabs(y-1) < 0.001 && fabs(animation.lastY-1)<0.001) {
        animation.timeLineX = 0;
        animation.finished = YES;
     
        if (animation.completionBlock) {
            animation.completionBlock(animation,animation.finished);
        }
        [self.animations removeObject:animation];
        self.animationCount--;
        if (self.animations.count == 0) {
            [self stopDisplayLink];
        }
        
    }
    animation.lastY = y;
    
}



- (CGFloat)getAnimation:(FDBaseAnimation *)animation springOffset:(CGFloat)x {
    return MIN(-cos(M_PI*animation.timeLineX)/2.0-0.5, 0.000);
}

- (CGFloat)getSpringAnimation:(FDSpringAnimation *)animation springOffset:(CGFloat)x {
    // 偏移后的值
    CGFloat result;
    if (!animation.needFabs) {
        result = -pow(2, -animation.damping * x) * cos(animation.frequency*x)+1;
    }else{
        result = -(fabs(pow(2, -animation.damping * x) * cos(animation.frequency*x)))+1;
    }
    return result;
    
}



@end
