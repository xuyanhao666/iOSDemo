//
//  LMLineChartView.m
//  LMLineChartDemo
//
//  Created by zero on 15/7/29.
//  Copyright (c) 2015年 zero. All rights reserved.
//

#import "LMLineChartView.h"

@interface LMLineChartView()
///
@property (nonatomic,strong) CAShapeLayer* axisLayer;
@property (nonatomic,strong) CAShapeLayer* gridLayer;
@property (nonatomic,strong) NSMutableArray* xAxisTitleLabelArray;
@property (nonatomic,strong) NSMutableArray* yLeftAxisTitleLabelArray;
@property (nonatomic,strong) NSMutableArray* yRightAxisTitleLabelArray;
@property (nonatomic,strong) NSMutableArray* lineLayerArray;
@property (nonatomic,strong) NSMutableArray* pointArray;
@property (nonatomic,strong) NSMutableArray* pointLayerArray;
///坐标轴刻度文字显示Label数组，用于reload时候的remove操作。
@property (nonatomic,strong) NSMutableArray* axisTickMarkLabelArray;
@property (nonatomic,strong) CAGradientLayer* gradientLayer;
@end

@implementation LMLineChartView
@synthesize xAxisTitleArray = _xAxisTitleArray;
@synthesize yAxisTitleArray = _yAxisTitleArray;
@synthesize axisShowType = _axisShowType;
@synthesize axisTickMarkLabelArray = _axisTickMarkLabelArray;
@synthesize axisColor = _axisColor;
@synthesize lineColor = _lineColor;
@synthesize gridType = _gridType;
@synthesize pointColor = _pointColor;

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        self.backgroundColor = [UIColor colorWithWhite:0.95 alpha:1];
        _chartXstartDistance = Default_chartXstartDistance;
        _chartYstartDistance = Default_chartYstartDistance;
        _chartVerticalDistance = Default_ChartVerticalDistance;
        _chartHorizontalDistance = Default_ChartHorizontalDistance;
    }
    return self;
}

#pragma mark -
#pragma mark - Actions
#pragma mark - 

- (void)reloadView{
    [self reloadAxis];
    [self reloadAnimation];
}


- (void)reloadAnimation{
    
    for(NSInteger i=0; i<_pointLayerArray.count; i++){
        CAShapeLayer* lineLayer = _lineLayerArray[i];
        CAShapeLayer* pointLayer = _pointLayerArray[i];
        
        [CATransaction begin];
        pointLayer.strokeEnd = 0.0;
        pointLayer.fillColor = [UIColor whiteColor].CGColor;
        CABasicAnimation *pathAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
        pathAnimation.duration = 3.0;
        pathAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        pathAnimation.fromValue = @0.0f;
        pathAnimation.toValue   = @1.0f;
        [lineLayer addAnimation:pathAnimation forKey:@"strokeEndAnimation"];
        lineLayer.strokeEnd = 1;
        
        CABasicAnimation* fadeAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
        fadeAnimation.fromValue = [NSNumber numberWithFloat:0.0];
        fadeAnimation.toValue = [NSNumber numberWithFloat:1.0];
        fadeAnimation.duration = 4;
//                 [pointLayer addAnimation:fadeAnimation forKey:@"fadeAnimation"];
        [pointLayer addAnimation:pathAnimation forKey:@"strokeEndAnimation"];
        
        pointLayer.strokeEnd = 1.0;
        [CATransaction commit];
    }
    
}


- (void)addLineShadowToView:(NSArray*)values Layer:(id)layer1{
    CAShapeLayer* layer= [self getLineShapeLayer];
    CGMutablePathRef path = CGPathCreateMutable();
    for(NSInteger i=0; i<values.count; i++){
        CGPoint point = [[values objectAtIndex:i]CGPointValue];
        if(i == 0){
            CGPathMoveToPoint(path, NULL, point.x, CGRectGetHeight(self.frame)-_chartVerticalDistance-2);
        }
        CGPathAddLineToPoint(path, NULL, point.x, point.y+2);
        if(i == values.count-1){
            CGPathAddLineToPoint(path, NULL, point.x, CGRectGetHeight(self.frame)-_chartVerticalDistance-2);
            CGPoint originPoint = [[values objectAtIndex:i]CGPointValue];
            CGPathAddLineToPoint(path, NULL, originPoint.x, CGRectGetHeight(self.frame)-_chartVerticalDistance-2);
        }
    }
    layer.path = path;
    CGPathRelease(path);
//    [self.layer addSublayer:layer];
    
    [self.layer addSublayer:self.gradientLayer];
    self.gradientLayer.colors = @[(__bridge id)[UIColor colorWithWhite:0.7 alpha:1].CGColor, (__bridge id)[UIColor colorWithWhite:1 alpha:1].CGColor];
    //set gradient start and end points
    self.gradientLayer.startPoint = CGPointMake(0, 0);
    self.gradientLayer.endPoint = CGPointMake(0, 1);
    [self.gradientLayer setMask:layer];
}

- (CAGradientLayer*)gradientLayer{
    if(_gradientLayer == nil){
        _gradientLayer = [CAGradientLayer layer];
        _gradientLayer.frame = self.bounds;
    }
    return _gradientLayer;
}

- (void)addLineToView:(NSArray*)values{
    [self addLineToView:values WithStrokeColor:nil];
}

- (void)addLineToView:(NSArray*)values WithStrokeColor:(UIColor*)strokeColor{
    if(_lineLayerArray == nil){
        _lineLayerArray = [NSMutableArray array];
    }
    if(_pointArray == nil){
        _pointArray = [NSMutableArray array];
    }
    if(_pointLayerArray == nil){
        _pointLayerArray = [NSMutableArray array];
    }
    CAShapeLayer* shape = [self getLineShapeLayer];
    if(strokeColor != nil){
        shape.strokeColor = strokeColor.CGColor;
    }
    [self.layer addSublayer:shape];
    CGFloat x=0;
    CGFloat y=0;
    CGFloat distanceYPixel = CGRectGetHeight(self.frame)-_chartYstartDistance*2-_chartVerticalDistance*2;
    CGFloat distanceYValue = _maxValue - _minValue;
    CGFloat distanceXPixel = CGRectGetWidth(self.frame)-_chartXstartDistance*2-_chartHorizontalDistance*2;
    CGFloat distanceXvalue = distanceXPixel/(CGFloat)(values.count-1);
    
    CGMutablePathRef path = CGPathCreateMutable();
    
    for(int i=0; i<values.count; i++){
        y = [values[i]doubleValue] - _minValue;
        y = CGRectGetHeight(self.frame)-_chartVerticalDistance-_chartYstartDistance-(y*distanceYPixel/distanceYValue);
        x = _chartHorizontalDistance+_chartXstartDistance+i*distanceXvalue;
        if(i != 0){
            CGPathAddLineToPoint(path, NULL, x, y);
        }
        CGPathMoveToPoint(path, NULL, x, y);
        [_pointArray addObject:[NSValue valueWithCGPoint:CGPointMake(x, y)]];
        
        //在对应的点上添加点击事件
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.backgroundColor = [UIColor redColor];
        btn.frame = CGRectMake(0, 0, 20, 20);
        btn.center = CGPointMake(x, y);
        [btn addTarget:self action:@selector(gethahaha) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn];
    }
    
    shape.path = path;
    CGPathRelease(path);
    [_lineLayerArray addObject:shape];
//   [self addLineShadowToView:_pointArray Layer:shape];
    
    CAShapeLayer* layer = [self getLineShapeLayer];
    if(strokeColor != nil){
        layer.strokeColor = [UIColor redColor].CGColor;
    }
    [self.layer addSublayer:layer];
    
    UIBezierPath* pointPath = [UIBezierPath bezierPath];
    for(NSValue* value in _pointArray){
        [pointPath moveToPoint:CGPointMake(value.CGPointValue.x+6, value.CGPointValue.y)];
        [pointPath addArcWithCenter:value.CGPointValue radius:6 startAngle:0 endAngle:M_PI*2 clockwise:YES];
//        CGMutablePathRef ref = CGPathCreateMutable();
//        CGPathAddArc(ref, NULL, value.CGPointValue.x, value.CGPointValue.y, 5, 0, M_PI*2, NO);
//        layer.path = ref;
//        layer.strokeEnd = 0.0;
    }
    [pointPath closePath];
    layer.path = pointPath.CGPath;
    [_pointLayerArray addObject:layer];
    
}

- (void)gethahaha{
    NSLog(@"hahaha");
}
- (void)removeAllLines{
    for(NSInteger i=0; i<_pointLayerArray.count; i++){
        CAShapeLayer* lineLayer = _lineLayerArray[i];
        CAShapeLayer* pointLayer = _pointLayerArray[i];
        [lineLayer removeFromSuperlayer];
        [pointLayer removeFromSuperlayer];
    }
}

/// 获取折现shapeLayer

- (CAShapeLayer*)getLineShapeLayerWithColor:(UIColor *)storkColor FillColor:(UIColor*)fillColor LineWidth:(CGFloat)width{
    return nil;
}

- (CAShapeLayer*)getLineShapeLayer{
    CAShapeLayer* layer = [CAShapeLayer layer];
    layer.fillColor = [UIColor clearColor].CGColor;
    layer.lineCap = kCALineCapRound;
    layer.lineJoin = kCALineJoinRound;
    layer.lineWidth = 2;
    layer.strokeColor = [UIColor colorWithRed:77.0 / 255.0 green:176.0 / 255.0 blue:122.0 / 255.0 alpha:1.0f].CGColor;
    layer.fillColor = self.pointColor.CGColor;
    return layer;
}

#pragma mark - 添加坐标轴方法
///刷新坐标轴类型方法
- (void)reloadAxis{
    [self reloadAxisLayer];
    [self reloadAxisTickMark];
    [self reloadGrid];
}

- (void)reloadGrid{
    self.gridLayer.lineDashPattern = nil;
    if(self.gridType != LMLineChartGridTypeNone){
        CGMutablePathRef path = CGPathCreateMutable();
        if(self.gridType == LMLineChartGridTypeOnlyVertical){
            [self addVerticalGridPath:path];
        }else if(self.gridType == LMLineChartGridTypeOnlyHorizontal){
            [self addHorizontalGridPath:path];
        }else if(self.gridType == LMLineChartGridTypeOnlyHorizontalWithDash){
            self.gridLayer.lineDashPattern = @[[NSNumber numberWithInt:1],[NSNumber numberWithInt:3]];
            [self addHorizontalGridPath:path];
        }else if(self.gridType == LMLineChartGridTypeOnlyVerticalWithDash){
            self.gridLayer.lineDashPattern = @[[NSNumber numberWithInt:1],[NSNumber numberWithInt:3]];
            [self addVerticalGridPath:path];
        }else{
            self.gridLayer.lineDashPattern = @[[NSNumber numberWithInt:1],[NSNumber numberWithInt:3]];
            [self addVerticalGridPath:path];
            [self addHorizontalGridPath:path];
        }
        self.gridLayer.path = path;
        CGPathRelease(path);
    }else{
        self.gridLayer.path = nil;
    }
}

- (void)addHorizontalGridPath:(CGMutablePathRef)path{
    CGFloat x,y;
    CGFloat distance,between;
    distance = CGRectGetHeight(self.frame) - _chartYstartDistance*2 - _chartVerticalDistance*2;
    between = distance/(CGFloat)(self.numOfYAxisTickMark-1);
    for(NSInteger i=0; i<self.numOfYAxisTickMark; i++){
        x = _chartHorizontalDistance + Default_tickMarkLenth ;
        y = _chartVerticalDistance+_chartYstartDistance + between*i;
        CGPathMoveToPoint(path, NULL, x, y);
        x = CGRectGetWidth(self.frame) - _chartHorizontalDistance - Default_tickMarkLenth;
        CGPathAddLineToPoint(path, NULL, x, y);
    }
}
- (void)addVerticalGridPath:(CGMutablePathRef)path{
    CGFloat x,y;
    CGFloat distance,between;
    distance = CGRectGetWidth(self.frame) - _chartHorizontalDistance*2 - _chartXstartDistance*2;
    between = distance/(self.xAxisTitleArray.count-1);
    for(NSInteger i=0; i<self.xAxisTitleArray.count; i++){
        x = _chartXstartDistance+_chartHorizontalDistance+i*between;
        y = CGRectGetHeight(self.frame) - _chartVerticalDistance - Default_tickMarkLenth;
        CGPathMoveToPoint(path, NULL, x, y);
        y = _chartVerticalDistance+_chartYstartDistance;
        CGPathAddLineToPoint(path, NULL, x, y);
    }
}

///添加刻度显示文字方法
- (void)reloadAxisTickMark{
    if(_xAxisTitleLabelArray == nil){
        _xAxisTitleLabelArray = [NSMutableArray array];
    }else{
        for(UILabel* label in _xAxisTitleLabelArray){
            [label removeFromSuperview];
        }
    }
    if(_yLeftAxisTitleLabelArray == nil){
        _yLeftAxisTitleLabelArray = [NSMutableArray array];
    }else{
        for(UILabel* label in _yLeftAxisTitleLabelArray){
            [label removeFromSuperview];
        }
    }
    if(_yRightAxisTitleLabelArray == nil){
        _yRightAxisTitleLabelArray = [NSMutableArray array];
    }else{
        for(UILabel* label in _yRightAxisTitleLabelArray){
            [label removeFromSuperview];
        }
    }
    CGFloat distance = 0;
    CGFloat between = 0;
    CGFloat x = 0;
    CGFloat y = 0;
    if(1){
        distance = CGRectGetWidth(self.frame)-_chartHorizontalDistance*2-_chartXstartDistance*2;
        between = distance/(CGFloat)(self.xAxisTitleArray.count-1);
        y = CGRectGetHeight(self.frame)-_chartVerticalDistance/2.0;
        for(int i=0; i<self.xAxisTitleArray.count;i++){
            x = _chartHorizontalDistance+_chartXstartDistance+i*between;
            UILabel* label = [self getLabelWithFrame:CGRectMake(0, 0, 80, _chartVerticalDistance) Center:CGPointMake(x,y) Title:[self.xAxisTitleArray objectAtIndex:i]];
            [_xAxisTitleLabelArray addObject:label];
            [self addSubview:label];
        }
    }
    if(_axisShowType != LMLineChartAxisShowX){
        distance = CGRectGetHeight(self.frame)-_chartVerticalDistance*2-_chartYstartDistance*2;
        between = distance/(CGFloat)(self.yAxisTitleArray.count-1);
        x = _chartHorizontalDistance/2.0;
        for(int i=0; i<self.yAxisTitleArray.count;i++){
            y = _chartVerticalDistance+_chartYstartDistance+i*between;
            UILabel* label = [self getLabelWithFrame:CGRectMake(0, 0, _chartHorizontalDistance, 20) Center:CGPointMake(x,y) Title:[self.yAxisTitleArray objectAtIndex:self.yAxisTitleArray.count - 1 - i]];
            [_yLeftAxisTitleLabelArray addObject:label];
            [self addSubview:label];
        }
        if(_axisShowType == LMLineChartAxisShowDoubleY){
            x = CGRectGetWidth(self.frame) - _chartHorizontalDistance/2.0;
            for(int i=0; i<self.yAxisTitleArray.count;i++){
                y = _chartVerticalDistance+_chartYstartDistance+i*between;
                UILabel* label = [self getLabelWithFrame:CGRectMake(0, 0, _chartHorizontalDistance, 20) Center:CGPointMake(x,y) Title:[self.yAxisTitleArray objectAtIndex:self.yAxisTitleArray.count - 1 - i]];
                [_yLeftAxisTitleLabelArray addObject:label];
                [self addSubview:label];
            }
        }
    }
}

- (UILabel*)getLabelWithFrame:(CGRect)rect Center:(CGPoint)point Title:(NSString*)title{
    if([title isKindOfClass:[NSNumber class]]){
        title = [NSString stringWithFormat:self.valueFormat,title.doubleValue];
    }
    UILabel* label = [[UILabel alloc]initWithFrame:rect];
    label.center = point;
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:13];
    label.textColor = [UIColor blackColor];
    label.text = title;
    return label;
}

///刷新或者加载坐标轴
- (void)reloadAxisLayer{
    CGMutablePathRef path = CGPathCreateMutable();
    CGFloat x,y;
    if(_yAxisTitleArray.count == 0 || _numOfYAxisTickMark != 0){
        NSMutableArray* store = [NSMutableArray array];
        CGFloat distance = (_maxValue - _minValue)/(CGFloat)(self.numOfYAxisTickMark-1);
        for(NSInteger i=0; i<self.numOfYAxisTickMark;i++){
            [store addObject:@(distance*i+_minValue)];
        }
        _yAxisTitleArray = store;
    }
    if(_axisShowType == LMLineChartAxisShowX){
        ///添加x轴path
        x = _chartHorizontalDistance;
        y = CGRectGetHeight(self.frame)-_chartVerticalDistance;
        CGPathMoveToPoint(path, NULL, x, y);
        x = CGRectGetWidth(self.frame)-_chartHorizontalDistance;
        CGPathAddLineToPoint(path, NULL, x, y);
        ///添加x轴刻度
        CGFloat distance = CGRectGetWidth(self.frame)-_chartHorizontalDistance*2-_chartXstartDistance*2;
        CGFloat between = distance/(CGFloat)(self.xAxisTitleArray.count-1);
        for(int i=0; i<self.xAxisTitleArray.count;i++){
            x = _chartXstartDistance+_chartHorizontalDistance+i*between;
            y = CGRectGetHeight(self.frame)-_chartVerticalDistance;
            CGPathMoveToPoint(path, NULL, x, y);
            y -= Default_tickMarkLenth;
            CGPathAddLineToPoint(path, NULL, x, y);
        }
        self.axisLayer.path = path;
    }else if(_axisShowType == LMLineChartAxisShowY){
        ///添加x和y轴path
        x = _chartHorizontalDistance;
        y = _chartVerticalDistance;
        CGPathMoveToPoint(path, NULL, x, y);
        y = CGRectGetHeight(self.frame)-_chartVerticalDistance;
        CGPathAddLineToPoint(path, NULL, x, y);
        x = CGRectGetWidth(self.frame)-_chartHorizontalDistance;
        CGPathAddLineToPoint(path, NULL, x, y);
        
        ///添加x刻度path
        CGFloat distance = CGRectGetWidth(self.frame)-_chartHorizontalDistance*2-_chartXstartDistance*2;
        CGFloat between = distance/(CGFloat)(self.xAxisTitleArray.count-1);
        for(int i=0; i<self.xAxisTitleArray.count;i++){
            x = _chartXstartDistance+_chartHorizontalDistance+i*between;
            y = CGRectGetHeight(self.frame)-_chartVerticalDistance;
            CGPathMoveToPoint(path, NULL, x, y);
            y -= Default_tickMarkLenth;
            CGPathAddLineToPoint(path, NULL, x, y);
        }
        
        ///添加y轴刻度path
        distance = CGRectGetHeight(self.frame)-_chartVerticalDistance*2 - _chartYstartDistance*2;
        between = distance/(CGFloat)(self.yAxisTitleArray.count-1);
        for (int i=0; i<self.yAxisTitleArray.count; i++) {
            x = _chartHorizontalDistance;
            y = _chartVerticalDistance + _chartYstartDistance +i*between;
            CGPathMoveToPoint(path, NULL, x, y);
            x = _chartHorizontalDistance+Default_tickMarkLenth;
            CGPathAddLineToPoint(path, NULL, x, y);
        }
        
        self.axisLayer.path = path;
    }else if(_axisShowType == LMLineChartAxisShowDoubleY){
        x = _chartHorizontalDistance;
        y = _chartVerticalDistance;
        CGPathMoveToPoint(path, NULL, x, y);
        y = CGRectGetHeight(self.frame)-_chartVerticalDistance;
        CGPathAddLineToPoint(path, NULL, x, y);
        x = CGRectGetWidth(self.frame)-_chartHorizontalDistance;
        CGPathAddLineToPoint(path, NULL, x, y);
        y = _chartVerticalDistance;
        CGPathAddLineToPoint(path, NULL, x, y);
        
        ///添加y轴path
        CGFloat distance = CGRectGetWidth(self.frame)-_chartHorizontalDistance*2-_chartXstartDistance*2;
        CGFloat between = distance/(CGFloat)(self.xAxisTitleArray.count-1);
        for(int i=0; i<self.xAxisTitleArray.count;i++){
            x = _chartXstartDistance+_chartHorizontalDistance+i*between;
            y = CGRectGetHeight(self.frame)-_chartVerticalDistance;
            CGPathMoveToPoint(path, NULL, x, y);
            y -= Default_tickMarkLenth;
            CGPathAddLineToPoint(path, NULL, x, y);
        }
        
        ///添加y轴刻度path
        distance = CGRectGetHeight(self.frame)-_chartVerticalDistance*2 - _chartYstartDistance*2;
        between = distance/(CGFloat)(self.yAxisTitleArray.count-1);
        for (int i=0; i<self.yAxisTitleArray.count; i++) {
            x = _chartHorizontalDistance;
            y = _chartVerticalDistance + _chartYstartDistance +i*between;
            CGPathMoveToPoint(path, NULL, x, y);
            x = _chartHorizontalDistance+Default_tickMarkLenth;
            CGPathAddLineToPoint(path, NULL, x, y);
        }
        
        distance = CGRectGetHeight(self.frame)-_chartVerticalDistance*2 - _chartYstartDistance*2;
        between = distance/(CGFloat)(self.yAxisTitleArray.count-1);
        for (int i=0; i<self.yAxisTitleArray.count; i++) {
            x = CGRectGetWidth(self.frame)-_chartHorizontalDistance;
            y = _chartVerticalDistance + _chartYstartDistance +i*between;
            CGPathMoveToPoint(path, NULL, x, y);
            x -= Default_tickMarkLenth;
            CGPathAddLineToPoint(path, NULL, x, y);
        }
        
        self.axisLayer.path = path;
    }
    CGPathRelease(path);
}


#pragma mark -
#pragma mark - Setup
#pragma mark -

#pragma mark - set

- (void)setGridType:(LMLineChartGridType)gridType{
    if(_gridType != gridType){
        _gridType = gridType;
        [self reloadGrid];
    }
}

- (void)setXAxisTitleArray:(NSArray *)xAxisTitleArray{
    if(_xAxisTitleArray != xAxisTitleArray){
        _xAxisTitleArray = xAxisTitleArray;
    }
}

- (void)setYAxisTitleArray:(NSArray *)yAxisTitleArray{
    if (_yAxisTitleArray != yAxisTitleArray) {
        _yAxisTitleArray = yAxisTitleArray;
        _numOfYAxisTickMark = _yAxisTitleArray.count;
        _minValue = [[_yAxisTitleArray firstObject] doubleValue];
        _maxValue = [[_yAxisTitleArray lastObject]doubleValue];
    }
}


- (void)setAxisColor:(UIColor *)axisColor{
    if(axisColor == nil){
        _axisColor = [UIColor blackColor];
    }else if(axisColor != _axisColor){
        _axisColor = axisColor;
        self.axisLayer.strokeColor = _axisColor.CGColor;
    }
}

- (void)setAxisShowType:(LMLineChartAxisShowType)axisShowType{
    if(_axisShowType != axisShowType){
        _axisShowType = axisShowType;
        [self reloadAxis];
    }
}


#pragma mark - get


- (NSString*)valueFormat{
    if(_valueFormat == nil || [_valueFormat isEqualToString:@""]){
        _valueFormat = @"%.1f";
    }
    return _valueFormat;
}

- (UIColor*)pointColor{
    if(!_pointColor){
        _pointColor = [UIColor whiteColor];
    }
    return _pointColor;
}

- (UIColor*)lineColor{
    if(_lineColor == nil){
        _lineColor = [UIColor colorWithRed:77.0 / 255.0 green:186.0 / 255.0 blue:122.0 / 255.0 alpha:1.0f];
    }
    return _lineColor;
}

- (NSArray*)xAxisTitleArray{
    if(_xAxisTitleArray == nil && _delegate != nil){
        if([_delegate respondsToSelector:@selector(titleForXAxisInLineChartView:)]){
            _xAxisTitleArray = [_delegate titleForXAxisInLineChartView:self];
        }
    }
    return _xAxisTitleArray;
}

- (NSArray*)yAxisTitleArray{
    if(_yAxisTitleArray == nil && _delegate != nil){
        if([_delegate respondsToSelector:@selector(titleForYAxisInLineChartView:)]){
            _yAxisTitleArray = [_delegate titleForYAxisInLineChartView:self];
        }
    }
    return _yAxisTitleArray;
}


- (UIColor*)axisColor{
    if(!_axisColor){
        _axisColor = [UIColor colorWithRed:77.0 / 255.0 green:186.0 / 255.0 blue:122.0 / 255.0 alpha:1.0f];
    }
    return _axisColor;
}

- (CAShapeLayer*)gridLayer{
    if(_gridLayer == nil){
        _gridLayer = [CAShapeLayer layer];
        _gridLayer.strokeColor = [UIColor lightGrayColor].CGColor;
        _gridLayer.lineCap = kCALineCapRound;
        _gridLayer.lineJoin = kCALineJoinRound;
        _gridLayer.lineWidth = 1.0;
//        _gridLayer.lineDashPattern = @[[NSNumber numberWithInt:1],[NSNumber numberWithInt:3]];
    }
    return _gridLayer;
}


- (CAShapeLayer*)axisLayer{
    if(!_axisLayer){
        _axisLayer = [CAShapeLayer layer];
        _axisLayer.fillColor = [UIColor clearColor].CGColor;
        _axisLayer.lineCap = kCALineCapRound;
        _axisLayer.lineJoin = kCALineJoinRound;
        _axisLayer.lineWidth = 1.0;
        _axisLayer.strokeColor = self.axisColor.CGColor;
        [self.layer addSublayer:_axisLayer];
        [self.layer addSublayer:self.gridLayer];
    }
    return _axisLayer;
}

- (NSMutableArray*)axisTickMarkArray{
    if(_axisTickMarkLabelArray == nil){
        _axisTickMarkLabelArray = [NSMutableArray array];
    }
    return _axisTickMarkLabelArray;
}


@end
