//
//  ViewController.m
//  BounceDemo
//
//  Created by xietao on 2017/5/11.
//  Copyright © 2017年 xietao3. All rights reserved.
//

#import "ViewController.h"
#import "AnimationViewController.h"

@interface ViewController ()

@property (nonatomic, strong) NSArray *titleList;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    _animation = [FDSpringAnimation animationType:FDAnimationTypeScale];
//    _animation.fromValue = [NSValue valueWithCGSize:CGSizeMake(1.0, 1.0)];
//    _animation.toValue = [NSValue valueWithCGSize:CGSizeMake(5.0,5.0)];
//    _animation.bounce = YES;
//    _animation.speed = 0.005;
//    _animation.needFabs = YES;
//    _animation.completionBlock = ^(FDBaseAnimation *anim,BOOL finished) {
//        NSLog(@"DEMOVIEW");
//    };
    
    _titleList = @[@"bounce",@"easeInOut",@"noneCurve"];
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _titleList.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifier = @"cellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
    }
    cell.textLabel.text = _titleList[indexPath.row];
    
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    AnimationViewController *goVC = [[AnimationViewController alloc] init];

    if (indexPath.row == 0) {
        goVC.bounce = YES;
    }else if (indexPath.row == 1) {
        goVC.bounce = NO;
        goVC.easeInOut = YES;

    }else if (indexPath.row == 2) {
        goVC.bounce = NO;
        goVC.easeInOut = NO;
    }
    [self.navigationController pushViewController:goVC animated:YES];

    
}





@end
