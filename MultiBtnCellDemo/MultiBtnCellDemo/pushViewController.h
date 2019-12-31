//
//  pushViewController.h
//  MultiBtnCellDemo
//
//  Created by szyl on 16/6/16.
//  Copyright © 2016年 xyh. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef enum : NSUInteger {
    EditYellow = 0,
    EditGreen
} EditAction;

@interface pushViewController : UIViewController

@property (nonatomic, assign) EditAction editAction;

@end
