//
//  AppDelegate.m
//  UISegmentDemo
//
//  Created by 许艳豪 on 15/11/18.
//  Copyright © 2015年 ideal_Mac. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"
#import "LeftView.h"
@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    ViewController *myView = [[ViewController alloc] init];
    UINavigationController *navagation = [[UINavigationController alloc] initWithRootViewController:myView];
//    [navagation.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:20/255.0 green:155/255.0 blue:213/255.0 alpha:1.0]];
    [[UINavigationBar appearance]setBarTintColor:[UIColor colorWithRed:20/255.0 green:155/255.0 blue:213/255.0 alpha:1.0]];
//    navagation.navigationBar.tintColor = [UIColor colorWithRed:20/255.0 green:155/255.0 blue:213/255.0 alpha:1.0];
    LeftView *lef = [[LeftView alloc] init];
    RESideMenu *sideVC = [[RESideMenu alloc] initWithContentViewController:navagation leftMenuViewController:lef rightMenuViewController:nil];
    sideVC.backgroundImage = [UIImage imageNamed:@"Stars"];
    sideVC.menuPreferredStatusBarStyle = 1; // UIStatusBarStyleLightContent
    sideVC.delegate = self;
    sideVC.contentViewShadowColor = [UIColor blackColor];
    sideVC.contentViewShadowOffset = CGSizeMake(0, 0);
    sideVC.contentViewShadowOpacity = 0.6;
    sideVC.contentViewShadowRadius = 12;
    sideVC.contentViewShadowEnabled = YES;
    
    self.window.rootViewController = sideVC;
    [self.window makeKeyAndVisible];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
