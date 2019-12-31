//
//  MyTableViewCell.m
//  MultiBtnCellDemo
//
//  Created by szyl on 16/6/16.
//  Copyright © 2016年 xyh. All rights reserved.
//

#import "MyTableViewCell.h"

@implementation MyTableViewCell

- (void)awakeFromNib {
    // Initialization code
    self.firstPress.backgroundColor = [UIColor whiteColor];
    self.secPress.backgroundColor = [UIColor whiteColor];
    self.backgroundColor = [UIColor grayColor];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
