//
//  AppDelegate.m
//  代理传值
//
//  Created by zyx on 16/3/19.
//  Copyright © 2016年 zyx. All rights reserved.
//

#import "AppDelegate.h"
#import "A_ViewController.h"


@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    A_ViewController *a = [[A_ViewController alloc] init];
    self.window.rootViewController = [[UINavigationController alloc] initWithRootViewController:a];
    
    [self.window makeKeyAndVisible];
    
    
    return YES;
}

@end
