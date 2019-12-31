//
//  SystemSetAlterView.h
//  aktyFull
//
//  Created by administrator on 14-4-23.
//  Copyright (c) 2014年 administrator. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    up,
    down,
    left,
    right
}ShowDirection;//TODO:暂时没做  应在初始化时传入方向

@protocol SystemSetAlterViewDelegate<NSObject>

- (void)didSelectedRow:(NSInteger)selectedIndex :(NSInteger)setNumber;
@end

@interface SystemSetAlterView : UIWindow<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong)  NSMutableArray *childViewDataSource;
@property (nonatomic, strong)  UITableView *childTableView;
@property (nonatomic, strong) id<SystemSetAlterViewDelegate>alterDelegate;
@property (nonatomic, assign) NSInteger selectedIndex;
@property (nonatomic, assign) NSInteger setNumber;//弹出视图者的标记
@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, copy) NSString *headerViewTitle;
@property (nonatomic, assign) ShowDirection direction;//视图从那边出来

+ (SystemSetAlterView *)getAlterViewWithTitle:(NSString *)title andFrame:(CGRect)frame dataSource:(NSMutableArray *)dataSource direction:(ShowDirection)direction;

+ (SystemSetAlterView *)getAlterViewWithTitle:(NSString *)title andCenterViewSize:(CGSize)centerViewSize dataSource:(NSMutableArray *)dataSource direction:(ShowDirection)direction;

/// 显示弹出框   参数(1、选中第几个 2、设置者编号用于记录是谁设置的)
- (void)ShowAlterViewWithSelectedIndex:(NSInteger)selectedIndex setNum:(NSInteger)setNumber;

///标记
- (void)ShowAlterViewWithFlag:(NSInteger)flag;

- (void)HiddenAlterView;

- (void)rellocView;

@end
