//
//  BlockViewController.h
//  blockDemo
//
//  Created by 许艳豪 on 16/1/11.
//  Copyright © 2016年 ideal_Mac. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^ReturnTextBlcok)(NSString *);

@interface BlockViewController : UIViewController

@property (nonatomic, copy) ReturnTextBlcok returnTextBlcok;

//- (void)ReturnText:(ReturnTextBlcok)blcok;

@end
