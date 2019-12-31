//
//  HeaderHelper.h
//  PlanApp
//
//  Created by zero on 15/6/15.
//  Copyright (c) 2015年 zero. All rights reserved.
//

#import "SkinThemeManager.h"
#import "ValidateHelper.h"
//#import "ReactiveCocoa.h"
#import "Masonry.h"
#import "LMServiceClient.h"
//#import <SDWebImage/UIImageView+WebCache.h>
#import "UINavigationController+FDFullscreenPopGesture.h"
#import "CZTabBarView.h"
#import "UITableView+FDTemplateLayoutCell.h"
#import "LMTableViewHelper.h"
#import "NSDate+Help.h"
#import "UIViewController+BackButtonHandler.h"
//#import "DataModels.h"
#import "MJRefresh.h"
#import "PopoverView.h"
//#import "UserModel.h"
#import "HSTool.h"
#define ENTER_FIRST @"enter_first"

#define ScreenWidth [UIScreen mainScreen].bounds.size.width
#define ScreenHeight [UIScreen mainScreen].bounds.size.height

///是否有添加医生有科室发布权限
#define isAddOrDel [[UserModel shareInstanceWithUser:nil] PermissionPublishNotice]
///是否有科室发布权限
#define isShare    [[UserModel shareInstanceWithUser:nil] PermissionAddDelDeptUser]

///添加权限页面
#define AddTitile    @"给与权限"
#define DeleteTitle  @"取消权限"
#define DefaultColor Color(162, 96, 88, 0.6)
#define ManagerColor Color(129, 15, 3, 0.9)

#define SAFE_STRING(string) (string != nil) ? (string) : (string = @"")
#define MAINCOLOR  Color(127 , 29, 19, 0.8)

#define S_COLOR  ColorWithRGBA(126, 30, 21, 0.7)
#define N_COLOR  ColorWithRGBA(57, 156, 227, 0.7)
//define this constant if you want to use Masonry without the 'mas_' prefix
#define MAS_SHORTHAND
//define this constant if you want to enable auto-boxing for default syntax
#define MAS_SHORTHAND_GLOBALS

#define WS(weakSelf)  __weak __typeof(&*self)weakSelf = self

//是否是iPhone5 手机
#define iPhone5     ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)

//字体大小设置
#define FONT_SIZE(fontsize)             [UIFont systemFontOfSize:fontsize]

//字体类型及大小设置
#define FONT(fontname,fontsize)         [UIFont fontWithName:fontname size:fontsize]

#define ColorWithRGBA(r,g,b,a) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]
#define ColorWithRGB(r,g,b) ColorWithRGBA(r,g,b,1.0)

#if DEBUG
#define NSLog(FORMAT, ...) fprintf(stderr,"\nfunction:%s line:%d content:%s\n", __FUNCTION__, __LINE__, [[NSString stringWithFormat:FORMAT, ##__VA_ARGS__] UTF8String]);
#else
#define NSLog(FORMAT, ...) nil
#endif
#define NSNC    [NSNotificationCenter defaultCenter]
#define NSUD    [NSUserDefaults standardUserDefaults]