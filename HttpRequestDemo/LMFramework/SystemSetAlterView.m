//
//  SystemSetAlterView.m
//  aktyFull
//
//  Created by administrator on 14-4-23.
//  Copyright (c) 2014年 administrator. All rights reserved.
//

#import "SystemSetAlterView.h"

#define SECTION_HEADERVIEW_HEIGHT 45
#define Animation_Time 0.3f

#define Right_Rect CGRectMake(MAIN_SCREEN_SIZE.width, 0, MAIN_SCREEN_SIZE.width, MAIN_SCREEN_SIZE.height)
#define Left_Rect CGRectMake(-MAIN_SCREEN_SIZE.width, 0, MAIN_SCREEN_SIZE.width, MAIN_SCREEN_SIZE.height)
#define Up_Rect CGRectMake(0, -MAIN_SCREEN_SIZE.height, MAIN_SCREEN_SIZE.width, MAIN_SCREEN_SIZE.height)
#define Down_Rect CGRectMake(0, MAIN_SCREEN_SIZE.height, MAIN_SCREEN_SIZE.width, MAIN_SCREEN_SIZE.height)

#define MAIN_SCREEN_BOUNDS [UIScreen mainScreen].bounds
#define MAIN_SCREEN_SIZE MAIN_SCREEN_BOUNDS.size
@implementation SystemSetAlterView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
       
        
    }
    return self;
}

- (UITableView *)childTableView
{
    if (_childTableView == nil) {
        
        _childTableView = [[UITableView alloc] init];
        _childTableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
        _childTableView.dataSource = self;
        _childTableView.delegate = self;
        _childTableView.tableFooterView = [UIView new];
    }
    return _childTableView;
}

- (UIView *)bgView
{
    if (_bgView == nil) {
        _bgView = [[UIView alloc] initWithFrame:MAIN_SCREEN_BOUNDS];
        _bgView.backgroundColor = [UIColor clearColor];
    }
    return _bgView;
}

+ (SystemSetAlterView *)getAlterViewWithTitle:(NSString *)title andFrame:(CGRect)frame dataSource:(NSMutableArray *)dataSource direction:(ShowDirection)direction
{
    
    SystemSetAlterView *systemSetAlterView = [[SystemSetAlterView alloc] init];
    systemSetAlterView.direction = direction;
    systemSetAlterView.frame = [systemSetAlterView getViewFrame];
    systemSetAlterView.windowLevel = UIWindowLevelStatusBar;
    
    systemSetAlterView.headerViewTitle = title;
    
    systemSetAlterView.childViewDataSource = dataSource;
    systemSetAlterView.childTableView.frame = frame;
    systemSetAlterView.childTableView.center = CGPointMake(MAIN_SCREEN_SIZE.width / 2, MAIN_SCREEN_SIZE.height / 2);
    
    [systemSetAlterView addSubview:systemSetAlterView.bgView];
    [systemSetAlterView addSubview:systemSetAlterView.childTableView];
    
    return systemSetAlterView;
}

+ (SystemSetAlterView *)getAlterViewWithTitle:(NSString *)title andCenterViewSize:(CGSize)centerViewSize dataSource:(NSMutableArray *)dataSource direction:(ShowDirection)direction
{
    SystemSetAlterView *systemSetAlterView = [[SystemSetAlterView alloc] init];
    systemSetAlterView.direction = direction;
    systemSetAlterView.frame = [systemSetAlterView getViewFrame];
    systemSetAlterView.windowLevel = UIWindowLevelStatusBar;
    
    systemSetAlterView.headerViewTitle = title;
    
    systemSetAlterView.childViewDataSource = dataSource;
    systemSetAlterView.childTableView.frame = CGRectMake(0, 0, centerViewSize.width, centerViewSize.height);
    systemSetAlterView.childTableView.center = CGPointMake(MAIN_SCREEN_SIZE.width / 2, MAIN_SCREEN_SIZE.height / 2);
    
    [systemSetAlterView addSubview:systemSetAlterView.bgView];
    [systemSetAlterView addSubview:systemSetAlterView.childTableView];
    
    systemSetAlterView.selectedIndex = 0;
    return systemSetAlterView;
}


#pragma mark -显示视图 1、选中第几条   2、弹出视图的 ...标记
- (void)ShowAlterViewWithSelectedIndex:(NSInteger)selectedIndex setNum:(NSInteger)setNumber
{
    
    [self setViewFrame:MAIN_SCREEN_BOUNDS];
    if (self.selectedIndex != selectedIndex) {
        
        self.selectedIndex = selectedIndex;
    }
    self.setNumber = setNumber;
    [self.childTableView reloadData];
    [self makeKeyAndVisible];
}

- (void)ShowAlterViewWithFlag:(NSInteger)flag
{
    [self ShowAlterViewWithSelectedIndex:self.selectedIndex setNum:flag];
}

#pragma mark -设置视图frame
- (void)setViewFrame:(CGRect)frame
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:Animation_Time];
    
    self.frame = frame;
    
    [UIView commitAnimations];
}

#pragma mark -通过 view显示方向  获得view的frame
- (CGRect)getViewFrame
{
    CGRect rect;
    if (self.direction == up) {
        
        rect = Up_Rect;
    }
    else if (self.direction == down){
        
        rect = Down_Rect;
    }
    else if (self.direction == left){
        
        rect = Left_Rect;
    }
    else{
        
        rect = Right_Rect;//默认
    }
    return rect;
}

#pragma mark -隐藏视图
- (void)HiddenAlterView
{
    [self setViewFrame:[self getViewFrame]];
    //self.hidden = YES;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MAIN_SCREEN_SIZE.width, SECTION_HEADERVIEW_HEIGHT)];
    [headerView setBackgroundColor:[UIColor blackColor]];
    UILabel *textLabel = [[UILabel alloc] initWithFrame:headerView.bounds];
    [textLabel setBackgroundColor:[UIColor clearColor]];
    textLabel.text = self.headerViewTitle;
    [textLabel setTextColor:[UIColor whiteColor]];
    [headerView addSubview:textLabel];
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return SECTION_HEADERVIEW_HEIGHT;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.childViewDataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"childCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        
        cell = [[UITableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:identifier];
    }
    cell.backgroundColor = [UIColor groupTableViewBackgroundColor];
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    NSString *text = [self.childViewDataSource objectAtIndex:indexPath.row];
    cell.textLabel.text = text;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{

    if (indexPath.row == self.selectedIndex) {
        
        cell.textLabel.textColor = [UIColor darkTextColor];
    }
    else{
        
        cell.textLabel.textColor = [UIColor blackColor];
    }

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.selectedIndex = indexPath.row;
    if ([self.alterDelegate respondsToSelector:@selector(didSelectedRow::)]) {
        
        [self.alterDelegate didSelectedRow:indexPath.row :self.setNumber];
    }
}
- (void)rellocView
{
    [self.childTableView removeFromSuperview];
    
}

@end
