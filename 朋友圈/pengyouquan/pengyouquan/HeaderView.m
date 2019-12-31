//
//  HeaderView.m
//  pengyouquan
//
//  Created by 青创汇 on 16/1/8.
//  Copyright © 2016年 青创汇. All rights reserved.
//

#import "HeaderView.h"
#import "UIView+SDAutoLayout.h"
@implementation HeaderView{
    UIImageView *_backgroundImageView;
    UIImageView *_iconView;
    UILabel *_nameLabel;
}
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setup];
    }
    return self;
}
- (void)setup
{
    _backgroundImageView = [UIImageView new];
    _backgroundImageView.backgroundColor = [UIColor lightGrayColor];
    _backgroundImageView.image = [UIImage imageNamed:@"pbg.jpg"];
    [self addSubview:_backgroundImageView];
    
    _iconView = [UIImageView new];
    _iconView.layer.borderWidth = 3;
    _iconView.image = [UIImage imageNamed:@"picon.jpg"];
    _iconView.layer.borderColor = [UIColor whiteColor].CGColor;
    [self addSubview:_iconView];
    
    _nameLabel = [UILabel new];
    _nameLabel.text = @"iOS";
    _nameLabel.textColor = [UIColor whiteColor];
    _nameLabel.textAlignment = NSTextAlignmentCenter;
    _nameLabel.font = [UIFont boldSystemFontOfSize:15];
    [self addSubview:_nameLabel];
    
    _backgroundImageView.sd_layout.spaceToSuperView(UIEdgeInsetsMake(0, 0, 40, 0));
    
    _iconView.sd_layout
    .widthIs(70)
    .heightIs(70)       
    .rightSpaceToView(self, 15)
    .bottomSpaceToView(self, 20);
    
    
    _nameLabel.tag = 1000;
    [_nameLabel setSingleLineAutoResizeWithMaxWidth:200];
    _nameLabel.sd_layout
    .rightSpaceToView(_iconView, 20)
    .bottomSpaceToView(_iconView, -35)
    .heightIs(20);
    
    
}

@end
