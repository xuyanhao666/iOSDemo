//
//  StepCircleView.m
//  TianYiHealthy
//
//  Created by 许艳豪 on 15/12/11.
//  Copyright © 2015年 xingzhi. All rights reserved.
//

#import "StepCircleView.h"

@implementation StepCircleView
{
    NSTimer *timer;
    NSInteger tempCount;
    UILabel *label;
    CAGradientLayer *gradientLayer1;
    CAGradientLayer *gradientLayer2;
    CAGradientLayer *gradientLayer3;
    CAGradientLayer *gradientLayer4;
}
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        
        self.backgroundColor = [UIColor colorWithRed:237.0/255 green:238.0/255 blue:241.0/255 alpha:1];
        self.backgroundColor = [UIColor clearColor];
        //  self.layer.backgroundColor = [UIColor lightGrayColor].CGColor;
        _layer_d = [CALayer layer];
        
        //左边的渐变色
        gradientLayer1 =  [CAGradientLayer layer];
        gradientLayer1.frame = CGRectMake(25, 33, 200, 200);


        gradientLayer1.locations = @[@(0.1)];
        [gradientLayer1 setStartPoint:CGPointMake(0,0.5)];
        [gradientLayer1 setEndPoint:CGPointMake(0.5,0)];
        [_layer_d addSublayer:gradientLayer1];
        
        
        //右边的渐变色
        gradientLayer2 =  [CAGradientLayer layer];
        gradientLayer2.frame = CGRectMake(175, 33, 140, 138*2);
        
        [gradientLayer2 setStartPoint:CGPointMake(0.5, 0)];
        [gradientLayer2 setEndPoint:CGPointMake(0.5, 1)];
        [_layer_d addSublayer:gradientLayer2];
        
        
        //下边的渐变色
        gradientLayer3 =  [CAGradientLayer layer];
        gradientLayer3.frame = CGRectMake(25, (36+64), 70/2, 134/2);

        [gradientLayer3 setStartPoint:CGPointMake(0.25, 0.75)];
        [gradientLayer3 setEndPoint:CGPointMake(0, 0.5)];
        
        // gradientLayer3.locations = @[@(0.1/10000000000000),@(0.8),@(0.95)];
        [_layer_d addSublayer:gradientLayer3];
        
        
        
        gradientLayer4 =  [CAGradientLayer layer];
        gradientLayer4.frame = CGRectMake(36+20, (36+64), 77, 134/2);
        
        [gradientLayer4 setStartPoint:CGPointMake(0.5, 1.0)];
        [gradientLayer4 setEndPoint:CGPointMake(0.25, 0.75)];
        
        gradientLayer4.locations = @[@(0.1/10000000000000),@(0.8),@(0.95)];
        [_layer_d addSublayer:gradientLayer4];
        
    }
    return self;
}

-(void)drawRect:(CGRect)rect
{
//    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(100, 100) radius:62 startAngle:-M_PI_2 + 5.0/100 endAngle:M_PI*2-M_PI_2 clockwise:YES];
    if ([_isDefualt isEqualToString:@"isDefualt"]) {
        [gradientLayer1 setColors:[NSArray arrayWithObjects:(id)[[UIColor lightGrayColor] CGColor],(id)[[UIColor lightGrayColor] CGColor], nil]];
    }else{
        [gradientLayer1 setColors:[NSArray arrayWithObjects:(id)[[UIColor greenColor] CGColor],(id)[[UIColor greenColor] CGColor], nil]];
    }
    
    if ([_isDefualt isEqualToString:@"isDefualt"]) {
        [gradientLayer2 setColors:[NSArray arrayWithObjects:(id)[[UIColor lightGrayColor] CGColor],(id)[[UIColor lightGrayColor] CGColor], nil]];
    }else{
        [gradientLayer2 setColors:[NSArray arrayWithObjects:(id)[[UIColor greenColor] CGColor],(id)[[UIColor greenColor] CGColor], nil]];
    }
    
    if ([_isDefualt isEqualToString:@"isDefualt"]) {
        [gradientLayer3 setColors:[NSArray arrayWithObjects:(id)[[UIColor lightGrayColor] CGColor],(id)[[UIColor lightGrayColor] CGColor], nil]];
    }else{
        [gradientLayer3 setColors:[NSArray arrayWithObjects:(id)[[UIColor greenColor] CGColor],(id)[[UIColor greenColor] CGColor], nil]];
    }
    
    if ([_isDefualt isEqualToString:@"isDefualt"]) {
        [gradientLayer4 setColors:[NSArray arrayWithObjects:(id)[[UIColor lightGrayColor] CGColor],(id)[[UIColor lightGrayColor] CGColor], nil]];
    }else{
        [gradientLayer4 setColors:[NSArray arrayWithObjects:(id)[[UIColor greenColor] CGColor],(id)[[UIColor greenColor] CGColor], nil]];
    }

    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(200, 200) radius:100 startAngle:M_PI endAngle:M_PI*2 clockwise:YES];
    
    _progressLayer = [CAShapeLayer layer];
    _progressLayer.frame = rect;
    _progressLayer.fillColor =  [[UIColor clearColor] CGColor];
    _progressLayer.strokeColor  = [[UIColor redColor] CGColor];
    _progressLayer.lineCap = kCALineCapRound;
    _progressLayer.lineJoin =kCALineJoinRound;
    _progressLayer.lineWidth = 15;
    _progressLayer.path = [path CGPath];
    
    //值大小
    _progressLayer.strokeEnd = _score;
    [_layer_d setMask:_progressLayer]; //用progressLayer来截取渐变层
    [self.layer addSublayer:_layer_d];
    
    
    CGRect frame = CGRectMake(43.5, 43.5, 113, 113);
    label = [[UILabel alloc]initWithFrame:frame];
    label.layer.cornerRadius = label.frame.size.width/2;
    label.layer.masksToBounds = YES;
    label.textAlignment = NSTextAlignmentCenter ;
    label.font = [UIFont systemFontOfSize:35.0f];
    label.backgroundColor = [UIColor redColor];
    label.textColor = [UIColor whiteColor];
//    [self addSubview:label];
    
    //动画实现
   
    [self startAnimation];
 
    
    
    
}

-(void)startAnimation{
    CABasicAnimation *pathAnim = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    pathAnim.fromValue = @0;
    pathAnim.toValue = @(_progressLayer.strokeEnd);
    pathAnim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    if ([_isDefualt isEqualToString:@"isDefualt"]) {
       pathAnim.duration = 0.01;
    }else{
       pathAnim.duration = 3.0f*_score;
    }
//    pathAnim.duration = 3.0f*_score;
    pathAnim.fillMode = kCAFillModeForwards;
    [_progressLayer addAnimation:pathAnim forKey:nil];
    
   
    NSThread *newThread = [[NSThread alloc]initWithTarget:self selector:@selector(onNewThread) object:nil];
    
    
     [self changeLabelValue];
    
    
}

-(void)onNewThread{
    
    if (_score != 0) {
        CGFloat timeDis =   (3.0*_score)/(100*_score);
        timer = [NSTimer scheduledTimerWithTimeInterval:timeDis target:self selector:@selector(changeLabelValue) userInfo:nil repeats:YES];
        tempCount = 0;
        [[NSRunLoop currentRunLoop]run];
        
    }else{
        label.text = @"0分";
    }
    
}
-(void)changeLabelValue{
    
    //    NSString *string = [NSString string];
    //    string = [NSString stringWithFormat:@"%.2f",_score];
    NSInteger count = _score*100;

    tempCount++;
    
    NSString *string = [NSString stringWithFormat:@"%ld分",(long)tempCount];
    label.text = string;
    if (tempCount < 60) {
        label.backgroundColor = [UIColor redColor];
    }
    
    if (tempCount >= 60 && tempCount < 70) {
        label.backgroundColor = [UIColor colorWithRed:254.0/255 green:210.0/255 blue:0 alpha:1];
    }
    
    if (tempCount >= 70 && tempCount < 80) {
        label.backgroundColor = [UIColor greenColor];
    }
    
    if (tempCount >= 80) {
        label.backgroundColor = [UIColor colorWithRed:34.0/255 green:149.0/255 blue:7.0/255 alpha:1];
        
    }
    
    
    if (tempCount == count) {
        [timer invalidate];
        
    }
    
}


@end

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

