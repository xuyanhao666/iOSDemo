//
//  ZWClickView.m
//  ZW动画
//
//  Created by yuxin on 15/9/21.
//  Copyright (c) 2015年 yuxin. All rights reserved.
//

#import "ZWClickView.h"
#define pi 3.14159265359
#define DEGREES_TO_RADIANS(degrees) ((pi * degrees)/ 180)
@implementation ZWClickView

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    CGPoint  touchPoint = [[touches anyObject] locationInView:self];
    CALayer * waveLayer = [CALayer layer];
    waveLayer.frame = CGRectMake(touchPoint.x-1, touchPoint.y-1, 10, 10);
    waveLayer.borderWidth =0.2;
    waveLayer.cornerRadius =5.0;
    waveLayer.borderColor = [UIColor redColor].CGColor;
    [self.layer addSublayer:waveLayer];
    [self scaleBegin:waveLayer];
    
}
-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    CGPoint  touchPoint = [[touches anyObject] locationInView:self];
    CALayer * waveLayer = [CALayer layer];
    waveLayer.frame = CGRectMake(touchPoint.x-1, touchPoint.y-1, 10, 10);
    waveLayer.borderWidth =0.2;
    waveLayer.cornerRadius =5.0;
    waveLayer.borderColor = [UIColor redColor].CGColor;
    [self.layer addSublayer:waveLayer];
    [self scaleBegin:waveLayer];

}
-(void)scaleBegin:(CALayer *)layer
{
    const float maxScale=120.0;
    if (layer.transform.m11<maxScale) {
        if (layer.transform.m11==1.0) {
            [layer setTransform:CATransform3DMakeScale( 1.1, 1.1, 1.0)];
        }else{
            [layer setTransform:CATransform3DScale(layer.transform, 1.1, 1.1, 1.0)];
        }
        [self performSelector:_cmd withObject:layer afterDelay:0.05];
    }else [layer removeFromSuperlayer];
}

@end
