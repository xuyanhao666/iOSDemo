//
//  ViewController.h
//  blockDemo
//
//  Created by 许艳豪 on 16/1/11.
//  Copyright © 2016年 ideal_Mac. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^blcok)(NSString *str1);

@interface ViewController : UIViewController

@property (nonatomic, copy) blcok myblock;

@end

