//
//  B_ViewController.h
//  属性传值
//
//  Created by zyx on 16/3/18.
//  Copyright © 2016年 zyx. All rights reserved.
//

#import <UIKit/UIKit.h>

// 定义代理
@protocol Nextprotocol <NSObject>

// 代理方法
- (void)transferString:(NSString *)string;

@end


@interface B_ViewController : UIViewController

// 代理属性
@property (nonatomic, weak) id<Nextprotocol> delegate;

@end
