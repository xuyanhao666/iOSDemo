//
//  ActivityCell.h
//  HttpRequestDemo
//
//  Created by szyl on 16/6/3.
//  Copyright © 2016年 xyh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ActivityModel.h"
@interface ActivityCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *actAddress;
@property (weak, nonatomic) IBOutlet UILabel *actTime;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *actWidthConstraint;
@property (weak, nonatomic) IBOutlet UIImageView *actImage;
@property (weak, nonatomic) IBOutlet UILabel *actTitle;
+(instancetype)loadFromXib;
- (void)initWithMoel:(ActivityModel *)model;
@end
