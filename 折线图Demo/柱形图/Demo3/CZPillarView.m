//
//  CZPillarView.m
//  Demo3
//
//  Created by 少年 on 14/11/4.
//  Copyright (c) 2014年 少年. All rights reserved.
//

#import "CZPillarView.h"

#define StartX 40
#define StartY 40
#define DistanceX 50
#define LabelWidth 25
#define LabelHeight 20
@interface CZPillarView ()

@property (nonatomic,strong) UIScrollView* bgscrollView;


@property (nonatomic,assign) float totalX;
@property (nonatomic,assign) float totalY;
@end

@implementation CZPillarView


- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        self.backgroundColor = [UIColor clearColor];
        _bgscrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(StartX, 0, CGRectGetWidth(self.frame)-StartX, CGRectGetHeight(self.frame))];
        _bgscrollView.backgroundColor = [UIColor clearColor];
        _bgscrollView.showsHorizontalScrollIndicator = NO;
        _bgscrollView.showsVerticalScrollIndicator = NO;
        [self addSubview:_bgscrollView];
    }
    return self;
}
- (void)reloadData{
//    _minY = [[_valueArray firstObject] floatValue];
//    _maxY = [[_valueArray lastObject]floatValue];
//    _minY = 0;
//    _maxY = 99;
    _totalX = _valueArray.count* DistanceX + _valueArray.count*LabelWidth;
    _totalY = CGRectGetHeight(self.frame)-StartY;
    _bgscrollView.contentSize = CGSizeMake(_totalX, _totalY+StartY);
    [self addXY];
    [self addLabelWithY];
    [self addLabelWithX];
    [self addLabelWithValue];
}
- (void)addLabelWithY{
    __block float distance = _totalY/(float)_numberOfY;
    __block float y = 0;
    for (int i = 0 ; i<=_numberOfY; i++) {
        y = _totalY- i*distance - LabelHeight/2;
        UILabel* label = [[UILabel alloc]initWithFrame:CGRectMake(0, y, StartX, LabelHeight)];
        label.backgroundColor = [UIColor clearColor];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont systemFontOfSize:14];
        label.text = [NSString stringWithFormat:@"%.0f",(_maxY-_minY)/_totalY*(i*distance)+_minY];
        [self addSubview:label];
    }
}
- (void)addLabelWithX{
    __block float x = DistanceX/2.0;
    __block float y = 0;
    [_titleForXArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        NSLog(@"%f",y);
        UILabel* label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 80, LabelHeight)];
        if(idx%2 == 0){
            label.center = CGPointMake(x+LabelWidth/2.0, _totalY+LabelHeight/2.0);
        }else{
            label.center = CGPointMake(x+LabelWidth/2.0, _totalY+LabelHeight/2.0+LabelHeight);
        }
        
        label.backgroundColor = [UIColor clearColor];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont systemFontOfSize:14];
        label.text = obj;
        [_bgscrollView addSubview:label];
        x += LabelWidth+DistanceX;
    }];
}
- (void)addLabelWithValue{
    __block float x = DistanceX/2.0;
    __block float y = 0;
    [_valueArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        y = _totalY/(_maxY-_minY)*([obj floatValue]-_minY);
        NSLog(@"%f",y);
        NSLog(@"%f",x);
        UILabel* label = [[UILabel alloc]initWithFrame:CGRectMake(x, _totalY-y, LabelWidth, y)];
        label.backgroundColor = _pillarColor;
        [_bgscrollView addSubview:label];
        x += LabelWidth+DistanceX;
    }];
}
- (void)addXY{
    CAShapeLayer* x = [self addLine:0 tox:_totalX y:CGRectGetHeight(self.frame)-StartY toY:CGRectGetHeight(self.frame)-StartY];
    [_bgscrollView.layer addSublayer:x];
    CAShapeLayer* y = [self addLine:StartX-3 tox:StartX-3 y:0 toY:CGRectGetHeight(self.frame)-StartY];
    [self.layer addSublayer:y];
}
-(CAShapeLayer*)addLine:(int)x tox:(int)toX y:(int)y toY:(int)toY
{
    CAShapeLayer *lineShape = nil;
    CGMutablePathRef linePath = nil;
    linePath = CGPathCreateMutable();
    lineShape = [CAShapeLayer layer];
    lineShape.lineWidth = 0.5f;
    lineShape.lineCap = kCALineCapRound;;
    lineShape.strokeColor = [UIColor darkGrayColor].CGColor;
    
    CGPathMoveToPoint(linePath, NULL, x, y);
    CGPathAddLineToPoint(linePath, NULL, toX, toY);
    lineShape.path = linePath;
    CGPathRelease(linePath);
//    [_bgscrollView.layer addSublayer:lineShape];
    return lineShape;
}/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
