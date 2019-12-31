//
//  AppDelegate.m
//  workUp
//
//  Created by szyl on 16/6/8.
//  Copyright © 2016年 xyh. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"
#import "SecViewController.h"
@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    UIImage *unSelected = [[UIImage imageNamed:@"AppIcon29x29"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIImage *selectedImg = [[UIImage imageNamed:@"AppIcon29x29"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
//    UIImage *unSelected = [UIImage imageNamed:@"AppIcon29x29"];
//    UIImage *selectedImg = [UIImage imageNamed:@"AppIcon29x29"];
    UITabBarItem *item1 = [[UITabBarItem alloc] initWithTitle:@"1" image:unSelected selectedImage:selectedImg];
    item1.imageInsets = UIEdgeInsetsMake(5, 0, -5, 0);
    
    ViewController *myvc = [[ViewController alloc] init];
    myvc.tabBarItem = item1;
    
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:myvc];
    SecViewController *secVC = [[SecViewController alloc] init];
    
    UITabBarController *tabbar = [[UITabBarController alloc] init];
    tabbar.viewControllers = @[nav,secVC];
    tabbar.selectedIndex = 0;
    
    self.window.rootViewController = tabbar;
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
