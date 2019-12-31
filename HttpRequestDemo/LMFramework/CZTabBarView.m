//
//  CZTabBarView.m
//  CZBarDemo
//
//  Created by 少年 on 14-10-23.
//  Copyright (c) 2014年 少年. All rights reserved.
//

#import "CZTabBarView.h"

#define  Color(r,g,b,a) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:a]
#define  GrayColor1 Color(235,235,235,1)

@interface CZTabBarView ()

@property (nonatomic,strong) NSArray* titleArray;
@property (nonatomic,strong) NSMutableArray* buttonArray;
@property (nonatomic,strong) UIImageView* selectImageView;

@end

@implementation CZTabBarView

- (id)initWithFrame:(CGRect)frame Title:(NSArray*)array SelectImageView:(UIImageView*)imageView{
    self = [super initWithFrame:frame];
    if(self){
        self.backgroundColor = [UIColor groupTableViewBackgroundColor];
        _titleArray = array;
        float width = CGRectGetWidth(frame)/(float)_titleArray.count;
        float height = CGRectGetHeight(frame);
        _buttonArray = [NSMutableArray arrayWithCapacity:array.count];
        for (int i=0; i<array.count; i++) {
            UIButton* btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.frame = CGRectMake(i*width, 0, width, height);
            [btn setTitle:[array objectAtIndex:i] forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
            btn.titleLabel.font = [UIFont systemFontOfSize:15];
            btn.tag = i;
            [btn addTarget:self action:@selector(didTapButton:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:btn];
            [_buttonArray addObject:btn];
            if(i == 0){
                [btn setTitleColor:Color(127 , 29, 19, 0.8) forState:UIControlStateNormal];
            }
        }
        _selectImageView = imageView;
        _selectImageView.center = CGPointMake(width/2.0, height-CGRectGetHeight(_selectImageView.bounds));
        [self addSubview:_selectImageView];
        _currentIndex = 0;
    }
    return self;
}

- (void)didTapButton:(UIButton*)btn{
    float width = CGRectGetWidth(self.frame)/(float)_titleArray.count;
    float height = CGRectGetHeight(self.frame);
    
    NSLog(@"%f",width*btn.tag/2.0);
    UIButton* lastBtn = [_buttonArray objectAtIndex:_currentIndex];
    [lastBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    _currentIndex = btn.tag;
    [btn setTitleColor:Color(127 , 29, 19, 0.8) forState:UIControlStateNormal];
    if([_delegate respondsToSelector:@selector(czTabBarViewShouldSelectInRow:)]){
        BOOL shouldGO = [_delegate czTabBarViewShouldSelectInRow:btn.tag];
        if(!shouldGO){
            return;
        }
    }
    if([_delegate respondsToSelector:@selector(czTabBarViewDidSelectInRow:)]){
        [_delegate czTabBarViewDidSelectInRow:btn.tag];
    }
    [UIView animateWithDuration:0.2 animations:^{
        _selectImageView.center = CGPointMake(width*btn.tag+width/2.0, height-CGRectGetHeight(_selectImageView.bounds));
    } completion:^(BOOL finished) {
        _selectImageView.center = CGPointMake(width*btn.tag+width/2.0, height-CGRectGetHeight(_selectImageView.bounds));
    }];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
