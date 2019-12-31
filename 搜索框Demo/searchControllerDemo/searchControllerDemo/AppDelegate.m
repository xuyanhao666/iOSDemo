//
//  AppDelegate.m
//  searchControllerDemo
//
//  Created by primb_xuyanhao on 2018/12/28.
//  Copyright © 2018 Primb. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"
#import "BaseNavigationController.h"
#import <UserNotifications/UserNotifications.h>
@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    ViewController *vc = [[ViewController alloc] init];
    BaseNavigationController *nav = [[BaseNavigationController alloc] initWithRootViewController:vc];
    UITabBarController *tabBarController = [[UITabBarController alloc]init];
    [tabBarController addChildViewController:nav];
    self.window.rootViewController = tabBarController;
    [self.window makeKeyAndVisible];
    
    // 此处需要写一个异步任务，是因为需要开辟一个新的线程去反复执行你的代码块，否则会阻塞主线程
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        while (true) {
            
            // 每隔5秒执行一次（当前线程阻塞5秒）
            [NSThread sleepForTimeInterval:5];
            
//            UNUserNotificationCenter *notiCenter = [UNUserNotificationCenter currentNotificationCenter];
//            [notiCenter removeAllDeliveredNotifications];
//            UNAuthorizationOptions options = UNAuthorizationOptionBadge | UNAuthorizationOptionSound | UNAuthorizationOptionAlert;
//            [notiCenter requestAuthorizationWithOptions:options completionHandler:^(BOOL granted, NSError * _Nullable error) {
            
//            }];
            
//            UNTimeIntervalNotificationTrigger *trigger = [UNTimeIntervalNotificationTrigger triggerWithTimeInterval:3 repeats:NO];
            
            NSLog(@"***每5秒输出一次这段文字***");
//            UNMutableNotificationContent *content = [[UNMutableNotificationContent alloc] init];
//            content.title = @"title";
//            content.subtitle = @"subtitle";
//            content.body = @"Copyright © 2016年 Hong. All rights reserved.";
//            content.sound = [UNNotificationSound soundNamed:@"test.caf"];
//
//            UNNotificationRequest *requ = [UNNotificationRequest requestWithIdentifier:@"request" content:content trigger:trigger];
//
//            [notiCenter addNotificationRequest:requ withCompletionHandler:^(NSError * _Nullable error) {
//                // 这里写你要反复处理的代码，如网络请求
//                NSLog(@"***每5秒输出一次这段文字***");
//            }];
            
//            [notiCenter removeAllDeliveredNotifications];
        }
    });
    
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
