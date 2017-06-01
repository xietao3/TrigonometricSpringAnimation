//
//  AnimationViewController.m
//  BounceDemo
//
//  Created by xietao on 2017/6/1.
//  Copyright © 2017年 xietao3. All rights reserved.
//

#import "AnimationViewController.h"
#import "FDAnimation.h"

@interface AnimationViewController ()
@property (weak, nonatomic) IBOutlet UIView *demoView;

@property (weak, nonatomic) IBOutlet UILabel *tensionLabel;
@property (weak, nonatomic) IBOutlet UILabel *frenLabel;
@property (weak, nonatomic) IBOutlet UILabel *speedLabel;


@property (nonatomic, strong) FDSpringAnimation *animation;
@end

@implementation AnimationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    __weak typeof(self) weakSelf = self;

    _animation = [FDSpringAnimation animationType:FDAnimationTypePosition];
    _animation.bounce = _bounce;
    _animation.easeInOut = _easeInOut;
    _animation.speed = 0.01;
    _animation.completionBlock = ^(FDBaseAnimation *anim,BOOL finished) {

    };
    [self startAnimation];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - IBAction
- (IBAction)startAction:(id)sender {
    [self startAnimation];
}

- (IBAction)stepperAction:(id)sender {
    UIStepper *stepper = sender;
    _animation.damping = stepper.value;
    _tensionLabel.text = [NSString stringWithFormat:@"阻尼%.0f",stepper.value];
    
    
}
- (IBAction)frenAction:(id)sender {
    UIStepper *stepper = sender;
    _animation.frequency = stepper.value;
    _frenLabel.text = [NSString stringWithFormat:@"频率%.0f",stepper.value];
    
}

- (IBAction)speedAction:(id)sender {
    UIStepper *stepper = sender;
    _animation.speed = stepper.value;
    _speedLabel.text = [NSString stringWithFormat:@"速度%.4f",stepper.value];
    
}

- (IBAction)segmentValueChange:(id)sender {
    UISegmentedControl *segment = sender;
    [self.demoView setFrame:CGRectMake(50, 300, 50, 50)];
    [self.demoView setCenter:CGPointMake([UIScreen mainScreen].bounds.size.width/2, [UIScreen mainScreen].bounds.size.height/2)];
    
    _animation.animationType = segment.selectedSegmentIndex;
}

#pragma mark - PrivateMethod

- (void)startAnimation {
    if (_animation.animationType == FDAnimationTypePosition) {
        _animation.fromValue = [NSValue valueWithCGPoint:CGPointMake(50, 300)];
        _animation.toValue = [NSValue valueWithCGPoint:CGPointMake(250,300.0)];
    }else if (_animation.animationType == FDAnimationTypeSize) {
        _animation.fromValue = [NSValue valueWithCGSize:CGSizeMake(50, 50)];
        _animation.toValue = [NSValue valueWithCGSize:CGSizeMake(200,200)];
    }else if (_animation.animationType == FDAnimationTypeScale) {
        _animation.fromValue = [NSValue valueWithCGSize:CGSizeMake(1.0, 1.0)];
        _animation.toValue = [NSValue valueWithCGSize:CGSizeMake(4.0,4.0)];
    }
    [_demoView fd_addAnimation:_animation];
}



@end
