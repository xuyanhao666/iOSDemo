//
//  TYMenuViewController.h
//  TianYi_Spark
//
//  Created by 曹 胜全 on 3/31/14.
//  Copyright (c) 2014 曹 胜全. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TYMenuViewController :UIViewController
{
    NSMutableArray *viewControllers;
}

@property (nonatomic, strong) NSString *backgroundImageName;
@property (nonatomic) CGRect transformFrame;

@property (nonatomic, strong, readonly) UIViewController *rootViewController;
@property (nonatomic, strong, readonly) UIViewController *bottomViewController;
@property (nonatomic, strong, readonly) UIViewController *topViewController;


- (id) initWithBottomViewController:(UIViewController *) bottomVc andRootViewController:(UIViewController *) rootVc;

/**
 替换rootViewController
*/
- (void) replaceRootViewControllerWithNewController:(UIViewController *) newRootViewController animate:(BOOL) animated completion:(void(^)()) completionBlock;

/**
 push new rootViewController
*/
- (void) pushNewViewController:(UIViewController *) newViewController animated:(BOOL) animated completion:(void(^)()) completionBlock;

- (void) popCurrentTopViewControllerAnimate:(BOOL) animated;

- (void) popToViewController:(UIViewController *) viewController animated:(BOOL)animated;

@end


@interface UIViewController (TYMenuViewController)

@property (nonatomic, readonly, assign) TYMenuViewController *menuViewController;

@end
