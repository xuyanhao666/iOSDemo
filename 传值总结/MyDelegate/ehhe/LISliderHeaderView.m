//
//  LISliderHeaderView.m
//  LIGHTinvesting
//
//  Created by hundsun on 15/11/30.
//  Copyright © 2015年 Hundsun. All rights reserved.
//

#import "LISliderHeaderView.h"
#import "Masonry.h"
#import "LISkinCss.h"
@interface LISliderHeaderView ()<UIScrollViewDelegate>{
    CGSize _labelSize;
}
@property (nonatomic, strong) NSMutableArray *titleArray;
@property (nonatomic, strong) NSMutableArray *buttonArray;
@end

@implementation LISliderHeaderView
#pragma  init method
- (instancetype)init{
    if (self = [super init]) {
        [self initWithData];
        [self initWithUI];
    }
    return self;
}
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self initWithData];
        [self initWithUI];
    }
    return self;
}
#pragma mark - response method
- (void)initWithData{
    _labelSize = CGSizeMake(80, 40);
    _titleArray = [NSMutableArray arrayWithObjects:@"最近发布",@"收益最高",@"门槛最低",@"领投成功率",@"历史最牛",@"你真厉害",@"我最厉害", nil];
    _buttonArray = [NSMutableArray array];
}
- (void)initWithUI{
    self.backgroundColor = [UIColor redColor];
    for (NSInteger i = 0; i < _titleArray.count; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.tag = i;
        [button setTitle:self.titleArray[i] forState:UIControlStateNormal];
        button.titleLabel.font = [LISkinCss fontSize13];
        [button setTitleColor:[LISkinCss colorRGB3b3f4a] forState:UIControlStateNormal];
        button.titleLabel.textAlignment = NSTextAlignmentCenter;
        [button addTarget:self action:@selector(switchToNextPage:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];
        [_buttonArray addObject:button];
    }
    [self layoutSubPages];
}

- (void)layoutSubPages{
    for (NSInteger i = 0; i < _buttonArray.count; i++) {
        [self.buttonArray[i] mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.mas_top);
            make.left.mas_equalTo(self.mas_left).offset(_labelSize.width * i);
            make.size.mas_equalTo(_labelSize);
        }];
    }
}
- (void)switchToNextPage:(UIButton *)sender{
    if ([self.delegate respondsToSelector:@selector(switchPageByIndex:)]) {
        [self.delegate switchPageByIndex:sender.tag];
    }
}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
