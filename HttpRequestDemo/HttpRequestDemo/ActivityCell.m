//
//  ActivityCell.m
//  HttpRequestDemo
//
//  Created by szyl on 16/6/3.
//  Copyright © 2016年 xyh. All rights reserved.
//

#import "ActivityCell.h"
#import "UIImageView+WebCache.h"
@implementation ActivityCell

- (void)awakeFromNib {
    // Initialization code
}
- (void)initWithMoel:(ActivityModel *)model{
    self.actTime.text = model.activityStartTime;
    self.actTitle.text = model.activityName;
    NSString *addressStr = [NSString stringWithFormat:@"%@%@%@%@%@%@%@",model.activityAddress,model.activityAddress,model.activityAddress,model.activityAddress,model.activityAddress,model.activityAddress,model.activityAddress];
    self.actAddress.text = addressStr;
    [self.actImage sd_setImageWithURL:[NSURL URLWithString:model.smallPicId]];
}
+(instancetype)loadFromXib{
    return [[[NSBundle mainBundle]loadNibNamed:@"MyTableViewCell" owner:nil options:nil]lastObject];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
