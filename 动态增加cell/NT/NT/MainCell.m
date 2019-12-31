//
//  MainCell.m
//  NT
//
//  Created by Kohn on 14-5-27.
//  Copyright (c) 2014年 Pem. All rights reserved.
//

#import "MainCell.h"

@implementation MainCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        UIImageView *photoImgView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 5, 70, 70)];
        self.Headerphoto = photoImgView;
        [self.contentView addSubview:self.Headerphoto];
    
        UILabel *nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(100, 5, 200, 25)];
        self.nameLabel = nameLabel;
        self.nameLabel.text = @"name";
        [self.contentView addSubview:self.nameLabel];
        
        UILabel *postLable = [[UILabel alloc]initWithFrame:CGRectMake(100, 30, 200, 25)];
        self.positionLabel = postLable;
        self.positionLabel.text = @"position";
        [self.contentView addSubview:self.positionLabel];
        
        UILabel *comLable = [[UILabel alloc]initWithFrame:CGRectMake(100, 55, 200, 25)];
        self.companyLabel = comLable;
        self.companyLabel.text = @"company";
        [self.contentView addSubview:self.companyLabel];
        
        
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

}

- (void)setMainCell
{
    
}

@end
