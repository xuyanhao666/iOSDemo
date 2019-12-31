//
//  B_ViewController.h
//  属性传值
//
//  Created by zyx on 16/3/18.
//  Copyright © 2016年 zyx. All rights reserved.
//

#import <UIKit/UIKit.h>

// 定义一个block
typedef void(^blockCZ)(NSString *string);

@interface B_ViewController : UIViewController

// block 属性
@property (nonatomic, copy)blockCZ block;

@end
