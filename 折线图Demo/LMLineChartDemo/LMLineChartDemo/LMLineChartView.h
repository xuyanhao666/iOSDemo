//
//  LMLineChartView.h
//  LMLineChartDemo
//
//  Created by zero on 15/7/29.
//  Copyright (c) 2015年 zero. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum{
    LMLineChartAxisShowX = 0, // 只显示x轴线
    LMLineChartAxisShowY, // 显示X,Y轴线
    LMLineChartAxisShowDoubleY, //显示双Y轴
}LMLineChartAxisShowType;


typedef NS_ENUM(NSUInteger,LMLineChartPointStyle) {
    LMLineChartPointStyleNone = 0,
    LMLineChartPointStyleCircle = 1,
    LMLineChartPointStyleSquare = 3,
    LMLineChartPointStyleTriangle = 4,
    LMLineChartPointStyleShadow
};

typedef NS_ENUM(NSUInteger, LMLineChartGridType) {
    LMLineChartGridTypeNone = 0,
    LMLineChartGridTypeOnlyHorizontal,
    LMLineChartGridTypeOnlyHorizontalWithDash,
    LMLineChartGridTypeOnlyVertical,
    LMLineChartGridTypeOnlyVerticalWithDash,
    LMLineChartGridTypeBothWithDash
};

#define Default_ChartHorizontalDistance 32
#define Default_ChartVerticalDistance 20
#define Default_chartXstartDistance 15
#define Default_chartYstartDistance 15
#define Default_tickMarkLenth 4

@class LMLineChartView;

@protocol  LMLineChartViewDelegate <NSObject>

- (NSArray*)titleForXAxisInLineChartView:(LMLineChartView*)chartView;
- (NSArray*)titleForYAxisInLineChartView:(LMLineChartView*)chartView;
//- (NSArray*)titleForLeftYAxisInLineChartView:(LMLineChartView*)chartView;
//- (NSArray*)titleForRightYAxisInLineChartView:(LMLineChartView*)chartView;

@end


@interface LMLineChartView : UIView

///轴线的显示方式
@property (nonatomic,assign) LMLineChartAxisShowType axisShowType;
///竖直间距
@property (nonatomic,assign) CGFloat chartVerticalDistance;
///水平间距
@property (nonatomic,assign) CGFloat chartHorizontalDistance;

/// 折线图绘制X轴开始起点，与原点的间距
@property (nonatomic,assign) CGFloat chartXstartDistance;
/// 折线图绘制Y轴开始起点，与原点的间距
@property (nonatomic,assign) CGFloat chartYstartDistance;
/// 点的显示方式
@property (nonatomic,assign) LMLineChartPointStyle inflexionPointStyle;
///网格显示类型
@property (nonatomic,assign) LMLineChartGridType gridType;
///x轴刻度显示文字
@property (nonatomic,strong) NSArray* xAxisTitleArray;
///y轴刻度显示文字
@property (nonatomic,strong) NSArray* yAxisTitleArray;

///y轴刻度数量，赋值会覆盖yAxisTitleArray
@property (nonatomic,assign) NSInteger numOfYAxisTickMark;
///y轴刻度最小值
@property (nonatomic,assign) CGFloat minValue;
///y轴刻度最大值
@property (nonatomic,assign) CGFloat maxValue;
///y轴刻度格式 default is @"%.1f"
@property (nonatomic,assign) NSString* valueFormat;

//@property (nonatomic,strong) NSMutableArray* valuesArray;
@property (nonatomic,assign) id<LMLineChartViewDelegate>delegate;

///坐标轴颜色
@property (nonatomic,strong) UIColor* axisColor;
///折现颜色
@property (nonatomic,strong) UIColor* lineColor;
///point 的填充颜色
@property (nonatomic,strong) UIColor* pointColor;

///改变坐标轴颜色
//- (void)changeAxisColor:(UIColor*)color;
- (void)reloadView;
- (void)addLineToView:(NSArray*)values;
- (void)reloadAnimation;
@end
