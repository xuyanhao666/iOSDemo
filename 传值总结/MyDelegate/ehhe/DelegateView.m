//
//  DelegateView.m
//  ehhe
//
//  Created by 许艳豪 on 15/12/9.
//  Copyright © 2015年 ideal_Mac. All rights reserved.
//

#import "DelegateView.h"

@implementation DelegateView

- (instancetype)init{
    if (self = [super init]) {
        self.backgroundColor = [UIColor grayColor];
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.backgroundColor = [UIColor yellowColor];
        btn.frame = CGRectMake(10, 10, 70, 40);
        [btn addTarget:self action:@selector(btnClick) forControlEvents:UIControlEventTouchDown];
        [self addSubview:btn];
    }
    return self;
}
//- (instancetype)initWithFrame:(CGRect)frame{
//    if (self = [super initWithFrame:frame]) {
//        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
//        btn.backgroundColor = [UIColor yellowColor];
//        btn.frame = CGRectMake(10, 10, 70, 40);
//        [btn addTarget:self action:@selector(btnClick) forControlEvents:UIControlEventTouchDown];
//        [self addSubview:btn];
//    }
//    return self;
//}
-(void)btnClick{
    if ([self.delegate respondsToSelector:@selector(transValue:)]){
        [self.delegate transValue:@"haha"];
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
