//
//  A_ViewController.h
//  属性传值
//
//  Created by zyx on 16/3/18.
//  Copyright © 2016年 zyx. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol myDelegate <NSObject>

- (void)transVlaue:(NSString *)vaule;

@end

@interface A_ViewController : UIViewController

@property (nonatomic, weak) id<myDelegate> delegate;

@end
