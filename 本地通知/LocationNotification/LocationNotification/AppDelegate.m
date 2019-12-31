//
//  AppDelegate.m
//  LocationNotification
//
//  Created by primb on 2018/1/4.
//  Copyright © 2018年 Primb. All rights reserved.
//

#import "AppDelegate.h"
#import <UserNotifications/UserNotifications.h>

@interface AppDelegate ()<UNUserNotificationCenterDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    // 使用 UNUserNotificationCenter 来管理通知
    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
    //监听回调事件
    center.delegate = self;
    
    //iOS 10 使用以下方法注册，才能得到授权
    [center requestAuthorizationWithOptions:UNAuthorizationOptionAlert | UNAuthorizationOptionBadge | UNAuthorizationOptionSound completionHandler:^(BOOL granted, NSError * _Nullable error) {
        
    }];
    
    return YES;
}
//实现UNUserNotificationCenterDelegate代理方法
- (void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler{
//    这个方法中的那句话就是，当应用在前台的时候，收到本地通知，是用什么方式来展现。系统给了三种形式
    completionHandler(UNNotificationPresentationOptionSound);
    if ([UIApplication sharedApplication].applicationIconBadgeNumber > 0) {
        [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    }
//    typedef NS_OPTIONS(NSUInteger, UNNotificationPresentationOptions) {
//        UNNotificationPresentationOptionBadge   = (1 << 0),
//        UNNotificationPresentationOptionSound   = (1 << 1),
//        UNNotificationPresentationOptionAlert   = (1 << 2),
//    }
}

//这个方法是在后台或者程序被杀死的时候，点击通知栏调用的，在前台的时候不会被调用
- (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)(void))completionHandler{
    if ([UIApplication sharedApplication].applicationIconBadgeNumber > 0) {
        [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    }
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Title" message:@"message" delegate:self cancelButtonTitle:@"cancel" otherButtonTitles:@"ok", nil];
    [alert show];
    
    completionHandler();
}
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken{
    NSString *versionStr = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
    NSString *appName = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleDisplayName"];
    
    NSLog(@"app版本号：%@",versionStr);
    NSLog(@"app名称：%@",appName);
    
    NSString *deviceTokenString = [[[[deviceToken description]
                                     stringByReplacingOccurrencesOfString:@"<"withString:@""]
                                    stringByReplacingOccurrencesOfString:@">" withString:@""]
                                   stringByReplacingOccurrencesOfString: @" " withString: @""];
    
    //然后通过请求的方法把deviceToken传给后天，后台发起推送请求给APNso苹果服务器，APNs再根据服务器中与deviceToken对应的映射表，找到对应的设备与app，发送远程推送消息。
    //iOS设备的UDID(Unique Device Identifier:唯一设备标识码，用来标识唯一一台苹果设备)和应用的Bundle Identifier通过长连接发送给APNs服务器，然后苹果通过这两个的值根据一定的加密算法得出deviceToken，并将deviceToken返回给iOS设备。(注：APNs服务器会留有UDID+Bundle Identifier+deviceToken的映射表)
    NSLog(@"deviceToken：%@",deviceTokenString);
}
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error{
    
    // 说明注册远程通知失败
    NSLog(@"注册推送失败，error = %@", error);
}
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler{
    NSLog(@"推送消息的信息字典：%@",userInfo);
    
    if ([UIApplication sharedApplication].applicationIconBadgeNumber > 0) {
        [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    }
    
    NSDictionary *apsInfo = [userInfo objectForKey:@"aps"];
    
    NSString *alert = [apsInfo objectForKey:@"alert"];
    NSLog(@"Received Push Alert: %@", alert);
    NSString *sound = [apsInfo objectForKey:@"sound"];
    NSLog(@"Received Push Sound: %@", sound);
    NSString *badge = [apsInfo objectForKey:@"badge"];
    NSLog(@"Received Push Badge: %@", badge);
    
    //这是播放音效
//    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
    
    //处理customInfo
    if ([userInfo objectForKey:@"custom"] != nil) {
        //custom handle code here...
    }
    
    completionHandler(UIBackgroundFetchResultNoData);
}
//这个是最新的iOS9之后的  openURL所走的方法
-(BOOL) application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString *,id> *)options
{
//    [[KODSDK defaultSDK]  kodDealWithApplication:app openURL:url sourceApplication:options[@"UIApplicationOpenURLOptionsSourceApplicationKey"] annotation:options[@"UIApplicationOpenURLOptionsOpenInPlaceKey"]];
    return YES;
}

//这个是iOS9之前的，9之后废弃

-(BOOL) application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation{
    
//    [[KODSDK defaultSDK]  kodDealWithApplication:application openURL:url
//                               sourceApplication:sourceApplication annotation:annotation];
    
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
