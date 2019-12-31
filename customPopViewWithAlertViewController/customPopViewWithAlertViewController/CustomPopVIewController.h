//
//  CustomPopVIewController.h
//  customPopViewWithAlertViewController
//
//  Created by primb_xuyanhao on 2018/8/14.
//  Copyright © 2018年 Primb. All rights reserved.
//

#import <UIKit/UIKit.h>
//点击时的回调
typedef void(^CustomAlertDismissBlock)(UIButton *button);

@interface CustomPopVIewController : UIAlertController

@property (nonatomic, weak) CustomAlertDismissBlock dismissBlock;

+ (UIAlertController *)initCustomerAlertViewController;
- (void)showCustomerAlertWithSuperController:(UIViewController *)superController ActionBlock:(CustomAlertDismissBlock)customBlock;
@end
