//
//  ViewController.m
//  TimerScrolImageDemo
//
//  Created by 许艳豪 on 16/3/18.
//  Copyright © 2016年 ideal_Mac. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property (nonatomic, strong)UIImageView *nextImageView;
@property (nonatomic, copy) NSString *str1;
@end

@implementation ViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    NSString  *a = @"1";
    NSMutableString *mutStr = [NSMutableString stringWithFormat:@"1"];
    self.str1 = mutStr;
//    a = @"2";
    [mutStr appendString:@" ----"];
    
    NSLog(@"======%@",self.str1);
    
    _nextImageView = [[UIImageView alloc] init];
    _nextImageView.frame = CGRectMake(100, 100, 101, 100);
    _nextImageView.backgroundColor = [UIColor yellowColor];
    [self.view addSubview:_nextImageView];
    
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(goFire:)];
    [_nextImageView setUserInteractionEnabled:YES];
    [_nextImageView addGestureRecognizer:pan];
    
    //添加轻扫手势
    UISwipeGestureRecognizer *swipeGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeGesture:)];
    //设置轻扫的方向
    swipeGesture.direction = UISwipeGestureRecognizerDirectionRight; //默认向右
    [self.view addGestureRecognizer:swipeGesture];
    
    //添加轻扫手势
    UISwipeGestureRecognizer *swipeGestureLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeGesture:)];
    //设置轻扫的方向
    swipeGestureLeft.direction = UISwipeGestureRecognizerDirectionLeft; //默认向右
    [self.view addGestureRecognizer:swipeGestureLeft];
    
    

    
}
- (void)goFire:(UIPanGestureRecognizer *)sender{
    CGPoint po = [sender translationInView:self.view];
    sender.view.center = CGPointMake(sender.view.center.x+po.x, sender.view.center.y+po.y);
    [sender setTranslation:CGPointMake(0, 0) inView:self.view];
//    if (sender.state == UIGestureRecognizerStateBegan) {
//        CGPoint startPoint = [sender locationInView:sender.view];
//        sender.view.center = CGPointMake(startPoint.x, startPoint.y);
//    }else if(sender.state == UIGestureRecognizerStateChanged){
//        CGPoint movePoint = [sender locationInView:sender.view];
//        sender.view.center = CGPointMake(sender.view.center.x+movePoint.x, sender.view.center.y+movePoint.y);
//        [sender setTranslation:CGPointMake(0, 0) inView:self.view];
//    }
}
//轻扫手势触发方法
-(void)swipeGesture:(id)sender
{
    
    UISwipeGestureRecognizer *swipe = sender;
    
    if (swipe.direction == UISwipeGestureRecognizerDirectionLeft)
        
    {
        NSLog(@"左左。。");
        //向左轻扫做的事情
        [UIView animateWithDuration:1 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
            _nextImageView.frame = CGRectMake(100, 200, 200, 200);
            
        } completion:nil];
        
    }
    
    if (swipe.direction == UISwipeGestureRecognizerDirectionRight){
        NSLog(@"右边。。");
        //向右轻扫做的事情
        [UIView animateWithDuration:1 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
            _nextImageView.frame = CGRectMake(100, 100, 100, 100);
            
        } completion:nil];
    }
}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
    
    // Dispose of any resources that can be recreated.
    
}



@end
