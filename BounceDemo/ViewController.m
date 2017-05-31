//
//  ViewController.m
//  BounceDemo
//
//  Created by xietao on 2017/5/11.
//  Copyright © 2017年 xietao3. All rights reserved.
//

#import "ViewController.h"
#import "UIView+FDAnimation.h"
#import "FDBaseAnimation.h"
#import "FDSpringAnimation.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIButton *startButton;

@property (weak, nonatomic) IBOutlet UILabel *tensionLabel;
@property (weak, nonatomic) IBOutlet UILabel *frenLabel;
@property (weak, nonatomic) IBOutlet UILabel *speedLabel;


@property (weak, nonatomic) IBOutlet UIView *demoView;
@property (weak, nonatomic) IBOutlet UIView *demoView2;

@property (nonatomic, strong) FDSpringAnimation *animation;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _animation = [FDSpringAnimation animationType:FDAnimationTypeScale];
    _animation.fromValue = [NSValue valueWithCGSize:CGSizeMake(1.0, 1.0)];
    _animation.toValue = [NSValue valueWithCGSize:CGSizeMake(5.0,5.0)];
    _animation.bounce = YES;
    _animation.speed = 0.005;
    _animation.needFabs = YES;
    _animation.completionBlock = ^(FDBaseAnimation *anim,BOOL finished) {
        NSLog(@"DEMOVIEW");
    };
    _demoView.layer.cornerRadius = _demoView.frame.size.height/2;
    _demoView.layer.masksToBounds = YES;

}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)startAction:(id)sender {
    [_demoView fd_addAnimation:_animation];
    
    FDSpringAnimation *animation = [FDSpringAnimation animationType:FDAnimationTypePosition];
    animation.fromValue = [NSValue valueWithCGSize:CGSizeMake(0, 0)];
    animation.toValue = [NSValue valueWithCGSize:CGSizeMake(100,100)];
    animation.bounce = YES;
    animation.needFabs = YES;
    animation.speed = 0.02;
    animation.completionBlock = ^(FDBaseAnimation *anim,BOOL finished) {
        NSLog(@"DEMO VIEW2");
    };
    [_demoView2 fd_addAnimation:animation];


}

- (IBAction)stepperAction:(id)sender {
    UIStepper *stepper = sender;
    self.animation.damping = stepper.value;
    _tensionLabel.text = [NSString stringWithFormat:@"阻尼%d",(int)self.animation.damping];


}
- (IBAction)frenAction:(id)sender {
    UIStepper *stepper = sender;
    self.animation.frequency = stepper.value;
    _frenLabel.text = [NSString stringWithFormat:@"频率%f",self.animation.frequency];

}

- (IBAction)speedAction:(id)sender {
    UIStepper *stepper = sender;
    self.animation.speed = stepper.value;
    _speedLabel.text = [NSString stringWithFormat:@"速度%f",self.animation.speed];

}





@end
