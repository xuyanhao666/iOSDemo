//
//  ViewController.m
//  HKDemo
//
//  Created by 许艳豪 on 15/12/4.
//  Copyright © 2015年 ideal_Mac. All rights reserved.
//

#import "ViewController.h"
#import <HealthKit/HealthKit.h>
#import "MBProgressHUD+MJ.h"
@interface ViewController ()
@property (nonatomic, strong) UILabel *showLabel;
@property (nonatomic, strong) HKHealthStore *healthStore;
@end

@implementation ViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    if ([HKHealthStore isHealthDataAvailable]) {
        [self requestAuthorization];
    }else{
        [MBProgressHUD showError:@"HealthKit is not available on this iOS device!!"];
    }

}
- (void)requestAuthorization{
    //请求授权，初始化healthStore
    NSSet *datatype = [NSSet setWithArray:[NSArray arrayWithObjects:[HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierStepCount],[HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierDistanceWalkingRunning],[HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierActiveEnergyBurned], nil]];
    _healthStore = [[HKHealthStore alloc] init];
    [_healthStore requestAuthorizationToShareTypes:nil readTypes:datatype completion:^(BOOL success, NSError * _Nullable error) {
        if (!success) {
            [MBProgressHUD showError:error.localizedDescription];
            return ;
        }
    }];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.view.backgroundColor = [UIColor whiteColor];
    _showLabel = [[UILabel alloc]initWithFrame:CGRectMake(5, self.view.frame.size.height/2 + 70, self.view.frame.size.width - 10, 200)];
    _showLabel.numberOfLines = 0;
    _showLabel.backgroundColor = [UIColor yellowColor];
    _showLabel.font = [UIFont systemFontOfSize:12];
    [self.view addSubview:_showLabel];
    [self createButton];
}
- (void)createButton{
    UIButton *getButton = [UIButton buttonWithType:UIButtonTypeCustom];
    getButton.frame = CGRectMake(self.view.bounds.size.width/2 - 40, self.view.bounds.size.height/2 - 20, 80, 40);
    [getButton setTitle:@"获取步数" forState:UIControlStateNormal];
    [getButton setBackgroundColor:[UIColor orangeColor]];
    [getButton addTarget:self action:@selector(getStep) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:getButton];
    
}
- (void)getStep{
    //查询时间
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDate *now = [NSDate date];
    NSDateComponents *components = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay | NSCalendarUnitWeekday fromDate:now];
    NSDate *anchorDate = [calendar dateFromComponents:components];
    NSDateComponents *intervalComponents = [[NSDateComponents alloc] init];
    intervalComponents.day = 1;
    
//    NSPredicate *predicate = [HKQuery predicateForSamplesWithStartDate:startDate
//                                                               endDate:endDate
//                                                               options:HKQueryOptionStrictStartDate];
    //请求的数据类型
    HKQuantityType *qiantityType = [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierStepCount];
//    HKStatisticsOptions options = qiantityType.aggregationStyle == HKQuantityAggregationStyleCumulative ? HKStatisticsOptionCumulativeSum : HKStatisticsOptionDiscreteAverage;
    
    //初始化查询请求
    HKStatisticsCollectionQuery *query = [[HKStatisticsCollectionQuery alloc] initWithQuantityType:qiantityType quantitySamplePredicate:nil options:HKStatisticsOptionCumulativeSum anchorDate:anchorDate intervalComponents:intervalComponents];
    
    //查询结果
    query.initialResultsHandler = ^(HKStatisticsCollectionQuery *query, HKStatisticsCollection *results, NSError *error){
        if (error) {
            [MBProgressHUD showError:error.description];
        }
        /*value 这个参数很重要  －5：表示从今天开始逐步查询后面五天的步数
         NSCalendarUnitDay  表示按照什么类型输出
         */
        NSDate *endDate = [NSDate date];
        NSDate *startDate = [calendar dateByAddingUnit:NSCalendarUnitDay value:0 toDate:endDate options:0];

        [results enumerateStatisticsFromDate:startDate toDate:endDate withBlock:^(HKStatistics * _Nonnull result, BOOL * _Nonnull stop) {
            HKQuantity *quantity = result.sumQuantity;
            double value = [quantity doubleValueForUnit:[HKUnit countUnit]];
            
            //设置时间
            NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
            //设置时区
            [outputFormatter setLocale:[NSLocale currentLocale]];
            [outputFormatter setDateFormat:@"yyyy年MM月dd日 HH时mm分ss秒"];
            //获取开始时间，并转化成字符串
            NSDate *date = result.startDate;
            NSString *timeStr = [outputFormatter stringFromDate:date];
            dispatch_async(dispatch_get_main_queue(), ^{
                _showLabel.text = [NSString stringWithFormat:@"time:%@,value:%f",timeStr,value];
                
            });
            
        }];
    };
    [_healthStore executeQuery:query];
}
+ (HKUnit *)defaultUnitForQuantityType:(HKQuantityType *)type {
    
    NSString *identifier = type.identifier;
    
    if (
        [identifier isEqualToString:HKQuantityTypeIdentifierBodyMassIndex] ||
        [identifier isEqualToString:HKQuantityTypeIdentifierStepCount] ||
        [identifier isEqualToString:HKQuantityTypeIdentifierFlightsClimbed] ||
        [identifier isEqualToString:HKQuantityTypeIdentifierNikeFuel] ||
        [identifier isEqualToString:HKQuantityTypeIdentifierNumberOfTimesFallen] ||
        [identifier isEqualToString:HKQuantityTypeIdentifierInhalerUsage] ||
        [identifier isEqualToString:HKQuantityTypeIdentifierHeartRate] ||
        [identifier isEqualToString:HKQuantityTypeIdentifierRespiratoryRate]
        ){
        return [HKUnit countUnit];
    }
    // length
    else if (
             [identifier isEqualToString:HKQuantityTypeIdentifierHeight] ||
             [identifier isEqualToString:HKQuantityTypeIdentifierDietaryZinc]
             ){
        return [HKUnit meterUnit];
    }
    // energy
    else if (
             [identifier isEqualToString:HKQuantityTypeIdentifierBasalEnergyBurned] ||
             [identifier isEqualToString:HKQuantityTypeIdentifierActiveEnergyBurned] ||
             [identifier isEqualToString:HKQuantityTypeIdentifierDietaryEnergyConsumed]
             )
    {
        return [HKUnit kilocalorieUnit];
    }
    // mass
    else if (
             [identifier isEqualToString:HKQuantityTypeIdentifierBloodGlucose] ||
             [identifier isEqualToString:HKQuantityTypeIdentifierBodyMass] ||
             [identifier isEqualToString:HKQuantityTypeIdentifierLeanBodyMass] ||
             [identifier hasPrefix:@"HKQuantityTypeIdentifierDietary"]
             )
    {
        return [HKUnit gramUnit];
    }
    // Percent
    else if (
             [identifier isEqualToString:HKQuantityTypeIdentifierBodyFatPercentage] ||
             [identifier isEqualToString:HKQuantityTypeIdentifierOxygenSaturation] ||
             [identifier isEqualToString:HKQuantityTypeIdentifierPeripheralPerfusionIndex] ||
             [identifier isEqualToString:HKQuantityTypeIdentifierBloodAlcoholContent]
             )
    {
        return [HKUnit percentUnit];
    }
    
    // TODO: Temperature, Pressure, Volume
    return nil;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
