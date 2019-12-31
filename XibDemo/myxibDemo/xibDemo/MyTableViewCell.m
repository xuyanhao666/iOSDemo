//
//  MyTableViewCell.m
//  xibDemo
//
//  Created by szyl on 16/5/18.
//  Copyright © 2016年 szyl. All rights reserved.
//

#import "MyTableViewCell.h"

@implementation MyTableViewCell

- (void)awakeFromNib {
    // Initialization code
}
////动态计算cell的高度
//- (void)heightForCell:(NSString *)str{
//    self.messageLabel.lineBreakMode = NSLineBreakByWordWrapping;
//    self.messageLabel.preferredMaxLayoutWidth = CGRectGetWidth(self.messageLabel.frame);
//    self.messageLabel.text = str;
//}
+(instancetype)loadFromXib{
    return [[[NSBundle mainBundle]loadNibNamed:@"MyTableViewCell" owner:nil options:nil]lastObject];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
