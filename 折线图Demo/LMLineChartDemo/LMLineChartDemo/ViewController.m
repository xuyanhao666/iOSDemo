//
//  ViewController.m
//  LMLineChartDemo
//
//  Created by zero on 15/7/29.
//  Copyright (c) 2015年 zero. All rights reserved.
//

#import "ViewController.h"
#import "LMLineChartView.h"
@interface ViewController ()<LMLineChartViewDelegate>
@property (nonatomic,strong) UISegmentedControl* axisShowSegmentControl;
@property (nonatomic,strong) UISegmentedControl* colorSegmentControl;
@property (nonatomic,strong) UISegmentedControl* gridSegmentControl;
@property (nonatomic,strong) LMLineChartView* lineChart;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _lineChart = [[LMLineChartView alloc]initWithFrame:CGRectMake(0, 50, CGRectGetWidth(self.view.frame), 300)];
    [self.view addSubview:_lineChart];
    _lineChart.yAxisTitleArray = @[@"10",@"20",@"30",@"40",@"50"];
    _lineChart.xAxisTitleArray = @[@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"1",@"2",@"3",@"4",@"5",@"6",@"7"];
//    _lineChart.minValue = 0;
//    _lineChart.maxValue = 80.0;
    _lineChart.valueFormat = @"%.f";
    _lineChart.numOfYAxisTickMark = 6;
    _lineChart.gridType = LMLineChartGridTypeBothWithDash;
    [_lineChart addLineToView:@[@11,@22,@25,@52,@34,@19,@43]];
//    [_lineChart addLineToView:@[@21,@32,@11,@32,@54,@48,@10,@29]];
    [_lineChart reloadView];
    [self colorSegmentControl];
    [self gridSegmentControl];
}


- (void)didChangeTypeWithAxisShow{
    if(_axisShowSegmentControl.selectedSegmentIndex == 0){
        self.lineChart.axisShowType = LMLineChartAxisShowX;
        [self.lineChart reloadView];
    }else if(_axisShowSegmentControl.selectedSegmentIndex == 1){
        self.lineChart.axisShowType = LMLineChartAxisShowY;
        [self.lineChart reloadView];
    }else{
        self.lineChart.axisShowType = LMLineChartAxisShowDoubleY;
        [self.lineChart reloadView];
    }
}

- (void)didChangeColorWithAxis{
    if(_colorSegmentControl.selectedSegmentIndex == 0){
        self.lineChart.axisColor = [UIColor greenColor];
    }else{
        self.lineChart.axisColor = [UIColor blackColor];
    }
}

- (void)didChangeGridType{
    switch (self.gridSegmentControl.selectedSegmentIndex) {
        case 0:{
            self.lineChart.gridType = LMLineChartGridTypeNone;
            break;
        }
        case 1:{
            self.lineChart.gridType = LMLineChartGridTypeOnlyHorizontal;
            break;
        }
        case 2:{
            self.lineChart.gridType = LMLineChartGridTypeOnlyHorizontalWithDash;
            break;
        }
        case 3:{
            self.lineChart.gridType = LMLineChartGridTypeOnlyVertical;
            break;
        }
        case 4:{
            self.lineChart.gridType = LMLineChartGridTypeOnlyVerticalWithDash;
            break;
        }
        case 5:{
            self.lineChart.gridType = LMLineChartGridTypeBothWithDash;
            break;
        }
            
        default:
            break;
    }
}

- (UISegmentedControl*)gridSegmentControl{  
    if(!_gridSegmentControl){
        _gridSegmentControl = [[UISegmentedControl alloc]initWithItems:@[@"None",@"Horizontal",@"H_Dash",@"Vertical",@"V_Dash",@"Both"]];
        _gridSegmentControl.frame = CGRectMake(0, CGRectGetMaxY(self.colorSegmentControl.frame)+10, CGRectGetWidth(self.view.frame), 30);
        [_gridSegmentControl addTarget:self action:@selector(didChangeGridType) forControlEvents:UIControlEventValueChanged];
        [self.view addSubview:_gridSegmentControl];
    }
    return _gridSegmentControl;
}

- (UISegmentedControl*)colorSegmentControl{
    if(!_colorSegmentControl){
        _colorSegmentControl = [[UISegmentedControl alloc]initWithItems:@[@"Green",@"Black"]];
        _colorSegmentControl.frame = CGRectMake(CGRectGetMinX(self.axisShowSegmentControl.frame), CGRectGetMaxY(self.axisShowSegmentControl.frame)+10, CGRectGetWidth(self.axisShowSegmentControl.frame), CGRectGetHeight(self.axisShowSegmentControl.frame));
        [self.view addSubview:_colorSegmentControl];
        [_colorSegmentControl addTarget:self action:@selector(didChangeColorWithAxis) forControlEvents:UIControlEventValueChanged];
    }
    return _colorSegmentControl;
}

- (UISegmentedControl*)axisShowSegmentControl{
    if(!_axisShowSegmentControl){
        _axisShowSegmentControl = [[UISegmentedControl alloc]initWithItems:@[@"ShowX",@"ShowY",@"ShowDoubleY"]];
        _axisShowSegmentControl.frame = CGRectMake(30, 400, CGRectGetWidth(self.view.frame)-60, 30);
        _axisShowSegmentControl.selectedSegmentIndex = 0;
        [_axisShowSegmentControl addTarget:self action:@selector(didChangeTypeWithAxisShow) forControlEvents:UIControlEventValueChanged];
        [self.view addSubview:_axisShowSegmentControl];
    }
    return _axisShowSegmentControl;
}
//- (NSArray*)titleForXAxisInLineChartView:(LMLineChartView*)chartView{
//    NSArray *arr = @[@"12",@"13",@"24"];
//    return arr;
//}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
