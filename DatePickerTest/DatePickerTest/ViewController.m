//
//  ViewController.m
//  DatePickerTest
//
//  Created by DCY on 14-7-24.
//  Copyright (c) 2014年 ZHIYOUEDU. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
{
    UIDatePicker *_datePicker;
}
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
	
    _datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, 100, 320, 400)];
//    设置picker显示的样式
    _datePicker.datePickerMode = UIDatePickerModeDate;
    
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.backgroundColor = [UIColor redColor];
    btn.frame = CGRectMake(50, 70, 100, 50);
    [btn addTarget:self action:@selector(btnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
    [self.view addSubview:_datePicker];
    
}

- (void)btnClick
{
    
    NSDate *selDate = [_datePicker date];
//  时间格式器  
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//    设置时间的格式
    [dateFormatter setDateFormat:@"yyyy-MM-dd / HH-mm"];
//    转换为字符串类型的对象
    NSString *currentDate = [dateFormatter stringFromDate:selDate];
    
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:currentDate delegate:Nil cancelButtonTitle:@"cancel" otherButtonTitles:@"ok", nil];
    [alertView show];
    
    /*
     
     yy: 年的后2位
     yyyy: 完整年
     MM: 月，显示为1-12
     MMM: 月，显示为英文月份简写,如 Jan
     MMMM: 月，显示为英文月份全称，如 Janualy
     dd: 日，2位数表示，如02
     d: 日，1-2位显示，如 2
     EEE: 简写星期几，如Sun
     EEEE: 全写星期几，如Sunday
     aa: 上下午，AM/PM
     H: 时，24小时制，0-23
     K：时，12小时制，0-11
     m: 分，1-2位
     mm: 分，2位
     s: 秒，1-2位
     ss: 秒，2位
     S: 毫秒
     
     常用日期结构：
     yyyy-MM-dd HH:mm:ss.SSS
     yyyy-MM-dd HH:mm:ss
     yyyy-MM-dd
     MM dd yyyy
     
     
     */
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
