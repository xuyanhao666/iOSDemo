//
//  ViewController.h
//  XibDemo
//
//  Created by wanghp on 16/5/18.
//  Copyright © 2016年 wanghp. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
@property (strong, nonatomic) NSMutableArray *dataArray;


@end

