//
//  ViewController.m
//  LocationNotification
//
//  Created by primb on 2018/1/4.
//  Copyright © 2018年 Primb. All rights reserved.
//

#import "ViewController.h"
#import <UserNotifications/UserNotifications.h>

@interface ViewController ()

@property(nonatomic,copy) NSDate *fireDate;
@property(nonatomic,copy) NSTimeZone *timeZone; //时区

@property(nonatomic) NSCalendarUnit repeatInterval; //重复间隔(枚举)
@property(nonatomic,copy) NSCalendar *repeatCalendar; //重复日期(NSCalendar)

@property(nonatomic,copy) CLRegion *region; //设置区域(设置当进入某一个区域时,发出一个通知)

@property(nonatomic,assign) BOOL regionTriggersOnce; //YES,只会在第一次进入某一个区域时发出通知.NO,每次进入该区域都会发通知
@property(nonatomic,copy) NSString *alertBody;

@property(nonatomic) BOOL hasAction;                //是否隐藏锁屏界面设置的alertAction
@property(nonatomic,copy) NSString *alertAction;    //设置锁屏界面一个文字

@property(nonatomic,copy) NSString *alertLaunchImage;   //启动图片
@property(nonatomic,copy) NSString *alertTitle;

@property(nonatomic,copy) NSString *soundName;
@property(nonatomic) NSInteger applicationIconBadgeNumber;
@property(nonatomic,copy) NSDictionary *userInfo; // 设置通知的额外的数据

@end


@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    UIButton *fireBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    fireBtn.frame = CGRectMake(100, 300, 300, 100);
    fireBtn.center = self.view.center;
    [fireBtn setTitle:@"hotShoot" forState:UIControlStateNormal];
    [fireBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    fireBtn.layer.cornerRadius = 20;
    fireBtn.layer.borderWidth = 2;
    fireBtn.layer.borderColor = [UIColor yellowColor].CGColor;
    fireBtn.clipsToBounds = YES;
    [self.view addSubview:fireBtn];
    
    [fireBtn addTarget:self action:@selector(AddNotification) forControlEvents:UIControlEventTouchUpInside];
    
}

- (void)AddNotification{

    // 使用 UNUserNotificationCenter 来管理通知
    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
    //需创建一个包含待通知内容的 UNMutableNotificationContent 对象，注意不是 UNNotificationContent ,此对象为不可变对象。
    UNMutableNotificationContent *content = [[UNMutableNotificationContent alloc] init];
    content.title = [NSString localizedUserNotificationStringForKey:@"本地推送Title" arguments:nil];
    content.body = [NSString localizedUserNotificationStringForKey:@"本地推送Body" arguments:nil];
    content.sound = [UNNotificationSound defaultSound];

    // 在设定时间后推送本地推送
    UNTimeIntervalNotificationTrigger *trigger = [UNTimeIntervalNotificationTrigger triggerWithTimeInterval:7 repeats:NO];
    UNNotificationRequest *request = [UNNotificationRequest requestWithIdentifier:@"bingo" content:content trigger:trigger];
    [center addNotificationRequest:request withCompletionHandler:^(NSError * _Nullable error) {
    }];
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:1];
    
//    UIImageView *annimationImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 300, 300)];
//    annimationImgView.animationImages = nil;
//    annimationImgView.animationRepeatCount = 0;
//    annimationImgView.animationDuration = 3;
//    [annimationImgView startAnimating];
//    [self.view addSubview:annimationImgView];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
//     Dispose of any resources that can be recreated.
}


@end
