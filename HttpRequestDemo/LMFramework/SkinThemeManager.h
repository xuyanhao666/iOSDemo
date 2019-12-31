//
//  SkinThemeManager.h
//  SkinDemo
//
//  Created by zero on 15/6/15.
//  Copyright (c) 2015年 zero. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


#define DeviceID [[[UIDevice currentDevice] identifierForVendor] UUIDString]
#define Color(r,g,b,a) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:a]
#define FontWithSize(r) [UIFont systemFontOfSize:r]
#define FontBoldSize(r) [UIFont boldSystemFontOfSize:r]

#define lmSkinThemeRed @"red"
#define lmSkinThemeGreen @"green"
#define SkinThemeChangeNotification @"SkinThemeChangeNotification"

#define SkinTitleFont FontWithSize(15)
#define SkinThemeColor [SkinThemeManager shareInstance].themeColor
#define SkinButtonNormalBgColor Color(105, 144, 210, 1)
#define SkinButtonSelectBgColor [SkinThemeManager shareInstance].buttonSelectBgColor
#define SkinViewBgColor [SkinThemeManager shareInstance].viewDefaultBgColor
#define SkinButtonNormalTitleColor [SkinThemeManager shareInstance].buttonNormalTitleColor
#define SkinButtonSelectTitleColor [SkinThemeManager shareInstance].buttonSelectTitleColor


typedef enum {
    SkinDefault = 0,
    SkinWithFirstHospital = 1,//上海第一人民医院
    SkinWithFudanTumourHospital = 2,//复旦附属肿瘤医院
}SkinType;

@interface SkinThemeManager : NSObject

@property (nonatomic,assign) SkinType skinType;
///App主题色
@property (nonatomic,strong) UIColor* themeColor;
///导航栏背景色
@property (nonatomic,strong) UIColor* navigationBarColor;
///导航栏上文字颜色
@property (nonatomic,strong) UIColor* navigationTitleColor;
///App中按钮默认背景色
@property (nonatomic,strong) UIColor* buttonNormalBgColor;
///App中按钮默认选中背景色
@property (nonatomic,strong) UIColor* buttonSelectBgColor;
///App中按钮文字默认颜色
@property (nonatomic,strong) UIColor* buttonNormalTitleColor;
///App中按钮文字默认选中色
@property (nonatomic,strong) UIColor* buttonSelectTitleColor;
///ViewController默认背景色
@property (nonatomic,strong) UIColor* viewDefaultBgColor;
+ (SkinThemeManager*)shareInstance;
@end
