//
//  TableViewCell.m
//  XibDemo
//
//  Created by wanghp on 16/5/18.
//  Copyright © 2016年 wanghp. All rights reserved.
//

#import "TableViewCell.h"

@implementation TableViewCell

- (void)awakeFromNib {
    self.m_labelText.textColor = [UIColor redColor];
    [self.m_btn setTitleColor:[UIColor greenColor] forState:UIControlStateNormal];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
+(instancetype)loadFromXib{
    return [[[NSBundle mainBundle]loadNibNamed:@"TableViewCell" owner:nil options:nil]lastObject];
}
@end
