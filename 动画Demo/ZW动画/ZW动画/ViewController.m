//
//  ViewController.m
//  ZW动画
//
//  Created by yuxin on 15/9/21.
//  Copyright (c) 2015年 yuxin. All rights reserved.
//

#import "ViewController.h"
#import "ZWClickView.h"
@interface ViewController ()
@property(nonatomic,strong)UIView * logoView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    ZWClickView * clickView =[[ZWClickView alloc] initWithFrame:CGRectMake(30, 30, self.view.frame.size.width, self.view.frame.size.height)];
    [self.view addSubview:clickView];
    [self heart];
//    UIView * view =[[UIView alloc] initWithFrame:CGRectMake(40, 100, 40, 40)];
//    view.backgroundColor = [UIColor redColor];
//    [self.view addSubview:view];
//    self.logoView = view;
//    
//    [self draw];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(100, 100, 100, 30);
    [btn setTitle:@"登录" forState:UIControlStateNormal];
//    btn.layer.cornerRadius = 10;
//    btn.layer.borderColor = [UIColor redColor].CGColor;
//    btn.layer.borderWidth = 1.0;
//    btn.layer.masksToBounds = NO;
    [self.view addSubview:btn];
    
}

-(void)draw
{
    CGPoint pathCenter = CGPointMake(_logoView.frame.size.width/2, _logoView.frame.size.height/2 - 50);
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:pathCenter radius:40 startAngle:0 endAngle:M_PI*2 clockwise:YES];
    
    path.lineCapStyle = kCGLineCapRound;
    path.lineJoinStyle = kCGLineCapRound;
    
    
    CGFloat x = _logoView.frame.size.width/2.5 + 5;
    CGFloat y = _logoView.frame.size.height/2 - 45;
    //勾的起点
    [path moveToPoint:CGPointMake(x, y)];
    //勾的最底端
    CGPoint p1 = CGPointMake(x+10, y+ 10);
    [path addLineToPoint:p1];
    //勾的最上端
    CGPoint p2 = CGPointMake(x+35,y-20);
    [path addLineToPoint:p2];
    //新建图层——绘制上面的圆圈和勾
    CAShapeLayer *layer = [[CAShapeLayer alloc] init];
    layer.fillColor = [UIColor clearColor].CGColor;
    layer.strokeColor = [UIColor greenColor].CGColor;
    layer.lineWidth = 5;
    layer.path = path.CGPath;
    
//    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:NSStringFromSelector(@selector(strokeEnd))];
//    animation.fromValue = @0;
//    animation.toValue = @1;
//    animation.duration = 0.5;
//    [layer addAnimation:animation forKey:NSStringFromSelector(@selector(strokeEnd))];
    
    [_logoView.layer addSublayer:layer];

}//心扑通扑通跳
-(void)heart
{
    
    UIImageView *showView = [[UIImageView alloc] initWithFrame:CGRectMake(30, 30, 50, 50)];
    showView.image = [UIImage imageNamed:@"3.jpg"];
    [self.view addSubview:showView];
    CABasicAnimation * animation = [CABasicAnimation animation];
//    animation.keyPath =@"transform.scale";
    animation.keyPath = @"transform.scale";
    animation.fromValue = [NSNumber numberWithFloat:0.7];
    animation.toValue = [NSNumber numberWithFloat:1.0];
    animation.duration = 0.5f;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    CAAnimationGroup *animationGroup = [CAAnimationGroup animation];
    animationGroup.duration = 0.5f;
    animationGroup.autoreverses = NO;   //是否重播，原动画的倒播
    animationGroup.repeatCount = NSNotFound;//HUGE_VALF;     //HUGE_VALF,源自math.h
    [animationGroup setAnimations:[NSArray arrayWithObjects:animation, nil]];
    //将上述两个动画编组
    [showView.layer addAnimation:animationGroup forKey:@"animationGroup"];
    
}

@end
