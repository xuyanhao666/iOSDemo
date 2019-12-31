//
//  CZTabBarView.h
//  CZBarDemo
//
//  Created by 少年 on 14-10-23.
//  Copyright (c) 2014年 少年. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol CZTabBarViewDelegate <NSObject>

- (void)czTabBarViewDidSelectInRow:(NSInteger)row;
- (BOOL)czTabBarViewShouldSelectInRow:(NSInteger)row;
@end

@interface CZTabBarView : UIView
@property (nonatomic,assign) id<CZTabBarViewDelegate> delegate;
@property (nonatomic,assign) NSInteger currentIndex;
- (id)initWithFrame:(CGRect)frame Title:(NSArray*)array SelectImageView:(UIImageView*)imageView;
@end
