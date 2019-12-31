//
//  TableViewCell.m
//  pengyouquan
//
//  Created by 青创汇 on 16/1/8.
//  Copyright © 2016年 青创汇. All rights reserved.
//

#import "TableViewCell.h"
#import "UIView+SDAutoLayout.h"
#import "SDWeiXinPhotoContainerView.h"
//#import "Model.h"
@implementation TableViewCell
{
    UIImageView *_iconView;
    UILabel *_nameLable;
    UILabel *_contentLabel;
    SDWeiXinPhotoContainerView *_picContainerView;
    UILabel *_timeLabel;
    UIButton *_commentBtn;
    UILabel *_showCommentLabel;
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setup];
    }
    return self;
}

- (void)setup
{
    _iconView = [UIImageView new];
    
    _nameLable = [UILabel new];
    _nameLable.font = [UIFont systemFontOfSize:14];
    _nameLable.textColor = [UIColor colorWithRed:(54 / 255.0) green:(71 / 255.0) blue:(121 / 255.0) alpha:0.9];
    
    _contentLabel = [UILabel new];
    _contentLabel.font = [UIFont systemFontOfSize:15];
    
    _picContainerView = [SDWeiXinPhotoContainerView new];
    
    _timeLabel = [UILabel new];
    _timeLabel.font = [UIFont systemFontOfSize:13];
    _timeLabel.textColor = [UIColor lightGrayColor];
    
    _commentBtn = [UIButton new];
    [_commentBtn setTitle:@"评论^-^" forState:UIControlStateNormal];
    [_commentBtn setTitleColor:[UIColor colorWithRed:(54 / 255.0) green:(71 / 255.0) blue:(121 / 255.0) alpha:0.9] forState:UIControlStateNormal];
    
    NSArray *views = @[_iconView, _nameLable, _contentLabel, _picContainerView, _timeLabel, _commentBtn];
    
    [views enumerateObjectsUsingBlock:^(UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [self.contentView addSubview:obj];
    }];
    
    UIView *contentView = self.contentView;
    CGFloat margin = 10;
    
    _iconView.sd_layout
    .leftSpaceToView(contentView, margin)
    .topSpaceToView(contentView, margin + 5)
    .widthIs(40)
    .heightIs(40);
    
    _nameLable.sd_layout
    .leftSpaceToView(_iconView, margin)
    .topEqualToView(_iconView)
    .heightIs(18)
    .widthRatioToView(contentView,0.7);
//    [_nameLable setSingleLineAutoResizeWithMaxWidth:300];
    
    _contentLabel.sd_layout
    .leftEqualToView(_nameLable)
    .topSpaceToView(_nameLable, margin)
    .rightSpaceToView(contentView, margin)
    .autoHeightRatio(0);// autoHeightRatio() 传0则根据文字自动计算高度（传大于0的值则根据此数值设置高度和宽度的比值）
    
    _picContainerView.sd_layout
    .leftEqualToView(_contentLabel);
//    .topSpaceToView(_contentLabel, margin)
//    .rightEqualToView(_contentLabel);
//    .autoHeightRatio(0);
    
    _timeLabel.sd_layout
    .leftEqualToView(_contentLabel)
    .topSpaceToView(_picContainerView, margin)
    .heightIs(15);
    [_timeLabel setSingleLineAutoResizeWithMaxWidth:200];
    [self setupAutoHeightWithBottomView:_timeLabel bottomMargin:margin + 5];
    
    _commentBtn.sd_layout
    .rightEqualToView(_contentLabel)
    .topEqualToView(_timeLabel)
    .heightIs(18)
    .widthIs(70);
    [_commentBtn addTarget:self action:@selector(showComment) forControlEvents:UIControlEventTouchUpInside];
}
- (void)showComment{
    if (!_showCommentLabel) {
        _showCommentLabel = [UILabel new];
    }
    _showCommentLabel.text = _nameLable.text;
    _showCommentLabel.font = [UIFont systemFontOfSize:13];
    [self.contentView addSubview:_showCommentLabel];
    
    _showCommentLabel.sd_layout
    .leftSpaceToView(self.contentView,5)
    .topSpaceToView(_timeLabel,10)
    .widthRatioToView(self.contentView,0.8)
    .autoHeightRatio(0);
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"showCommentLabel" object:nil];
}
- (void)setModel:(Model *)model
{
    _model = model;
    
    _iconView.image = [UIImage imageNamed:model.iconName];
    _nameLable.text = model.name;
    _contentLabel.text = model.content;
    _picContainerView.picPathStringsArray = model.picNamesArray;
    CGFloat picContainerTopMargin = 0;
    if (model.picNamesArray.count) {
        picContainerTopMargin = 10;
    }
    _picContainerView.sd_layout.topSpaceToView(_contentLabel, picContainerTopMargin);
    _timeLabel.text = @"1分钟前";
}

@end
