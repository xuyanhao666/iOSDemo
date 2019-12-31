//
//  BaseViewController.h
//  TianYiHealthy
//
//  Created by kevin on 14-6-25.
//  Copyright (c) 2014年 kevin.zhang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseViewController : UIViewController

@property (nonatomic) BOOL trans;
@property (nonatomic, assign)BOOL supportScrollPop;

- (void)toBack:(id)sender;

@end
