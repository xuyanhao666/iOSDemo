//
//  HalfPageScrollVIew.m
//  scrollPage
//
//  Created by szyl on 16/8/1.
//  Copyright © 2016年 xyh. All rights reserved.
//

#import "HalfPageScrollVIew.h"

#define WIDTH self.frame.size.width

@implementation HalfPageScrollVIew

-(instancetype)initWithFrame:(CGRect)frame
{
    self=[super initWithFrame:frame];
    if (self) {
        //添加ScrollView
        [self addScrollView];
        //添加图片控件
        [self addImageView]; 
        self.clipsToBounds = YES;
        self.backgroundColor = [UIColor yellowColor];
    }
    return self;
}
#pragma mark---添加ScrollView
-(void)addScrollView
{
    _myScrollView=[[UIScrollView alloc]initWithFrame:CGRectMake(WIDTH/4, 0, WIDTH/2, self.bounds.size.height)];
    _myScrollView.pagingEnabled=YES;
    _myScrollView.clipsToBounds=NO;
    _myScrollView.bounces=NO;
    _myScrollView.showsHorizontalScrollIndicator=NO;
    _myScrollView.scrollEnabled = YES;
    _myScrollView.contentSize=CGSizeMake(WIDTH/2*self.dataArr.count, self.bounds.size.height);
    [self addSubview:_myScrollView];
}
#pragma mark---添加图片控件
-(void)addImageView
{
    self.dataArr = @[@"huoying1.jpg",@"huoying2.jpg",@"huoying3.jpg",@"huoying4.jpg",@"huoying5.jpg",@"huoying6.jpg",@"huoying7.jpg"];
    for (NSInteger i=0; i<self.dataArr.count; i++) {
        _myImageView=[[UIImageView alloc]initWithFrame:CGRectMake(WIDTH/2*i, 0, WIDTH/2, self.bounds.size.height)];
        _myImageView.image=[UIImage imageNamed:self.dataArr[i]];
        [_myScrollView addSubview:_myImageView];
    }
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(10, 10, 100, 100);
    btn.layer.masksToBounds  = YES;
    btn.layer.borderWidth = 2;
    btn.layer.borderColor = [UIColor yellowColor].CGColor;
    [self addSubview:btn];
}
#pragma mark---修改hitTest方法
- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    UIView *view = [super hitTest:point withEvent:event];
    if ([view isEqual:self]){
        for (UIView *subview in _myScrollView.subviews){
            CGPoint offset = CGPointMake(point.x - _myScrollView.frame.origin.x + _myScrollView.contentOffset.x - subview.frame.origin.x, point.y - _myScrollView.frame.origin.y + _myScrollView.contentOffset.y - subview.frame.origin.y);
            
            if ((view = [subview hitTest:offset withEvent:event])){
                return view;
            }
        }
        return _myScrollView;
    }
    return view;    
}   

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
