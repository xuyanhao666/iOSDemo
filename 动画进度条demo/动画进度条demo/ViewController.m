//
//  ViewController.m
//  动画进度条demo
//
//  Created by primb_xuyanhao on 2018/8/15.
//  Copyright © 2018年 Primb. All rights reserved.
//

#import "ViewController.h"

#define CGColorToNSObject(x) (__bridge id)x.CGColor

static const CGFloat radius = 150;
static const CGFloat lineWidth = 40;

@interface ViewController ()<UITextFieldDelegate>
@property (nonatomic, strong) CAShapeLayer *maskLayer;
@property (nonatomic, strong) CAGradientLayer *layer;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, strong) UILabel *textLabel;
@property (nonatomic, strong) UITextField *textFiled;
@property (nonatomic, strong) UIButton *getCodeBtn;
@property (assign) float timeLevel;
@property (assign) float num;
@property (assign) float count;
@property (assign) NSInteger countNum;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    _timeLevel = 4;
    _num = 70;
    

    [self simpleLayer];
    [self complexLayer];
    [self giveMeTextFiled];

    
    _getCodeBtn = [[UIButton alloc] initWithFrame:CGRectMake(140, 600, 100, 40)];
    _getCodeBtn.layer.borderWidth = 2;
    _getCodeBtn.layer.borderColor = [UIColor greenColor].CGColor;
    _getCodeBtn.layer.masksToBounds = YES;
    _getCodeBtn.layer.cornerRadius = 4;
    [_getCodeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
    [_getCodeBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    _getCodeBtn.titleLabel.font = [UIFont systemFontOfSize:14];
//    [_getCodeBtn setBackgroundImage:[UIImage imageNamed:@"green"] forState:UIControlStateNormal];
    [_getCodeBtn setBackgroundColor:[UIColor greenColor]];
    [_getCodeBtn addTarget:self action:@selector(huoquEaxmCode) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_getCodeBtn];
}
- (void)huoquEaxmCode{
    _countNum = 59;
    _getCodeBtn.userInteractionEnabled = NO;
    [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(dumiao:) userInfo:nil repeats:YES];
//    [self performSelectorInBackground:@selector(wait) withObject:nil];
}
- (void)wait
{
    @autoreleasepool {
        [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(dumiao:) userInfo:nil repeats:YES];
    }
    [[NSRunLoop currentRunLoop] run];
}

- (void)dumiao:(NSTimer *)timer
{
    if (_countNum == 0) {
        [timer invalidate];
        _getCodeBtn.userInteractionEnabled = YES;
        [_getCodeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
        return;
    }
    [_getCodeBtn setBackgroundColor:[UIColor whiteColor]];
    [_getCodeBtn setTitle:[NSString stringWithFormat:@"剩余(%ld)秒",(long)_countNum] forState:UIControlStateNormal];
    _countNum --;
}
- (void)giveMeTextFiled{
    _textFiled = [[UITextField alloc] initWithFrame:CGRectMake(40, 140, 300, 40)];
    _textFiled.layer.borderWidth = 2;
    _textFiled.layer.borderColor = [UIColor greenColor].CGColor;
    _textFiled.layer.masksToBounds = YES;
    _textFiled.layer.cornerRadius = 4;
//    _textFiled.backgroundColor = [UIColor grayColor];
    _textFiled.placeholder = @"输入(0-100分)的成绩，不要调皮哟~";
    [self.view addSubview:_textFiled];
    
    UIButton *myBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    myBtn.frame = CGRectMake(150, 190, 70, 40);
    [myBtn setTitle:@"确定" forState:UIControlStateNormal];
    [myBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    myBtn.layer.borderWidth = 3;
    myBtn.layer.borderColor = [UIColor greenColor].CGColor;
    myBtn.layer.masksToBounds = YES;
    myBtn.layer.cornerRadius = 4;
    [myBtn addTarget:self action:@selector(startJudge) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:myBtn];
}
- (void)startJudge{
    _num = [_textFiled.text intValue];
    [self owesomeAnimation];
}
//- (void)textFieldDidEndEditing:(UITextField *)textField{
//    _num = (NSInteger)textField.text;
//    [self owesomeAnimation];
//}
- (void)simpleLayer{
    _layer = [CAGradientLayer layer];
    _layer.frame = CGRectMake(40, 100, 300, 20);
    // 结合无限轮播广告图的思路，在左边和右边多预备一块
    _layer.colors = @[CGColorToNSObject([UIColor cyanColor]),CGColorToNSObject([UIColor yellowColor]), CGColorToNSObject([UIColor cyanColor]), CGColorToNSObject([UIColor yellowColor]),CGColorToNSObject([UIColor cyanColor])];
    _layer.startPoint = CGPointMake(0, 0);
    _layer.endPoint = CGPointMake(1, 0);
    _layer.locations = @[@-1,@-0.5,@0,@0.5,@1];
    [self.view.layer addSublayer:_layer];
    
}
- (void)complexLayer{
    
    _textLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, radius, radius)];
    _textLabel.center = self.view.center;
    _textLabel.layer.cornerRadius = radius/2;
    _textLabel.layer.masksToBounds = YES;
    _textLabel.textAlignment = NSTextAlignmentCenter;
    _textLabel.backgroundColor = [UIColor redColor];
    _textLabel.textColor = [UIColor whiteColor];
    [self.view addSubview:_textLabel];
    
    CGFloat length = radius * 2 + lineWidth;
    // 左面半边的gradientLayer，高度减掉了一个线宽
    CAGradientLayer *leftGLayer = [CAGradientLayer layer];
    leftGLayer.frame = CGRectMake(0, 0, length/2, length - lineWidth);
    leftGLayer.colors = @[CGColorToNSObject([UIColor greenColor]),CGColorToNSObject([UIColor yellowColor])];
    leftGLayer.startPoint = CGPointMake(0, 0);
    leftGLayer.endPoint = CGPointMake(0, 1);
    
    // 右边半边的gradientLayer，高度减掉了一个线宽
    CAGradientLayer *rightGLayer = [CAGradientLayer layer];
    rightGLayer.frame = CGRectMake(length/2, 0, length/2, length - lineWidth);
    rightGLayer.colors = @[CGColorToNSObject([UIColor redColor]),CGColorToNSObject([UIColor yellowColor])];
    rightGLayer.startPoint = CGPointMake(0, 0);
    rightGLayer.endPoint = CGPointMake(0, 1);
    
    //底部补偿layer，高度为一个线宽lineWidth
    CALayer *bottomLayer = [CALayer layer];
    bottomLayer.frame = CGRectMake(0, length - lineWidth, length, lineWidth);
    bottomLayer.backgroundColor = [UIColor yellowColor].CGColor;
    
    // 作为被蒙版的  (容器layer)
    // 这样就相当于容器layer的绘制内容就是leftLayer+rightLayer的内容，然后设置好蒙版效果就有了
    CALayer *containerLayer = [CALayer layer];
    containerLayer.frame = CGRectMake(0, 0, length, length);
    containerLayer.position = self.view.center;
    [containerLayer addSublayer:leftGLayer];
    [containerLayer addSublayer:rightGLayer];
    [containerLayer addSublayer:bottomLayer];
    [self.view.layer addSublayer:containerLayer];
    
    //蒙板
    self.maskLayer = [CAShapeLayer layer];
    UIBezierPath *bezierPath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(length/2, length/2) radius:radius startAngle:-M_PI_2 endAngle:M_PI_2*3 clockwise:YES];
    self.maskLayer.path = bezierPath.CGPath;
    self.maskLayer.lineWidth = lineWidth;
    // shapeLayer的描线内容为蒙版内容，所以要设置描线颜色，随便什么颜色都可以
    self.maskLayer.strokeColor = [UIColor redColor].CGColor;
    self.maskLayer.fillColor = [UIColor clearColor].CGColor;
    self.maskLayer.backgroundColor = [UIColor clearColor].CGColor;
    
    containerLayer.mask = self.maskLayer;
    
    [self owesomeAnimation];
}
//- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
//    [self owesomeAnimation];
//}
- (void)owesomeAnimation{
    
    _layer.frame = CGRectMake(40, 100, 300*(_num/100), 20);
    [_timer invalidate];
    CGFloat timeDis =   _timeLevel / _num;
    _timer = [NSTimer scheduledTimerWithTimeInterval:timeDis target:self selector:@selector(changeLabelValue) userInfo:nil repeats:YES];
    _count = 0;
    
    CABasicAnimation * animation = [CABasicAnimation animation];
    animation.keyPath = @"strokeEnd";
    animation.duration = _timeLevel;
    animation.fromValue = @0;
    self.maskLayer.strokeEnd = _num/100;
    [self.maskLayer addAnimation:animation forKey:nil];
    
    //这部分代码是进度条动画的代码。
    CABasicAnimation * animation1 = [CABasicAnimation animation];
    animation1.keyPath = @"locations";
    animation1.duration = 2;
    animation1.fromValue = @[@-1,@-0.5,@0,@0.5,@1];
    animation1.toValue = @[@0,@0.5,@1,@1.5,@2];
    animation1.repeatCount = CGFLOAT_MAX;
    [_layer addAnimation:animation1 forKey:nil];
    // 关键！
    // 用一个新的layer作为gradientLayer的蒙版，然后给这个蒙版添加动画
    // 蒙版的内容逐渐变宽的话，gradientLayer的内容看起来也就是逐渐变宽的效果
    CALayer * mask = [CALayer layer];
    mask.frame = _layer.bounds;
    mask.backgroundColor = [UIColor redColor].CGColor;
    _layer.mask = mask;
    
    // 动画实际上是加给这个蒙版的
    CABasicAnimation * boundsAnimation = [CABasicAnimation animation];
    boundsAnimation.keyPath = @"bounds";
    boundsAnimation.duration = _timeLevel;
    // 长度从0开始
    boundsAnimation.fromValue = [NSValue valueWithCGRect:CGRectMake(0, 0, 0, 20)];
    // 根据modelLayer和presentationLayer的关系，我们不设置toValue则系统会自动把modelLayer的值作为toValue
    [mask addAnimation:boundsAnimation forKey:nil];
    
    CABasicAnimation * positionAnimation = [CABasicAnimation animation];
    positionAnimation.keyPath = @"position";
    positionAnimation.duration = _timeLevel;
    // 这里要注意参考系为gradientLayer本身
    positionAnimation.fromValue = [NSValue valueWithCGPoint:CGPointMake(0, 10)];
    [mask addAnimation:positionAnimation forKey:nil];
}

-(void)changeLabelValue{
    _count++;
    
    NSString *string = [NSString stringWithFormat:@"%ld分",(long)_count];
    _textLabel.text = string;
    if (_count < 50) {
        _textLabel.backgroundColor = [UIColor redColor];
    }
    
    if (_count >= 50 && _count < 70) {
        _textLabel.backgroundColor = [UIColor colorWithRed:254.0/255 green:210.0/255 blue:0 alpha:1];
    }
    
    if (_count >= 70 && _count < 90) {
        _textLabel.backgroundColor = [UIColor greenColor];
    }
    
    if (_count >= 90) {
        _textLabel.backgroundColor = [UIColor colorWithRed:34.0/255 green:149.0/255 blue:7.0/255 alpha:1];
        
    }
    if (_count == _num) {
        [_timer invalidate];
    }
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
