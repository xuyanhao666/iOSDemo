//
//  MyTableViewCell.h
//  xibDemo
//
//  Created by szyl on 16/5/18.
//  Copyright © 2016年 szyl. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titileLabel;
@property (weak, nonatomic) IBOutlet UILabel *messageLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *messageLabelConstrains;
@property (weak, nonatomic) IBOutlet UIImageView *iconImg;
+(instancetype)loadFromXib;
//- (void)heightForCell:(NSString *)str;
@end
