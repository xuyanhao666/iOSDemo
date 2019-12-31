//
//  SkinThemeManager.m
//  SkinDemo
//
//  Created by zero on 15/6/15.
//  Copyright (c) 2015年 zero. All rights reserved.
//

#import "SkinThemeManager.h"

@implementation SkinThemeManager

+ (SkinThemeManager*)shareInstance{
    static SkinThemeManager* manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[SkinThemeManager alloc]init];
        manager.skinType = SkinWithFirstHospital;
    });
    return manager;
}


- (void)setSkinType:(SkinType)skinType{
    if(_skinType != skinType){
        _skinType = skinType;
        if(_skinType == SkinWithFirstHospital){
            self.themeColor = Color(147 , 44, 24, 1);
            self.navigationBarColor = [UIColor groupTableViewBackgroundColor];
            self.navigationTitleColor = [UIColor darkGrayColor];
            self.buttonNormalBgColor = self.themeColor;
            self.buttonNormalTitleColor = [UIColor whiteColor];
            self.buttonSelectBgColor = self.themeColor;
            self.buttonSelectTitleColor = [UIColor whiteColor];
            self.viewDefaultBgColor = [UIColor groupTableViewBackgroundColor];
        }
    }
}
//- (void)setSkinThemeName:(NSString *)skinThemeName{
//    if(_skinThemeName != skinThemeName){
//        _skinThemeName = skinThemeName;
//        if([_skinThemeName isEqualToString:lmSkinThemeGreen]){
//            _themeColor = [UIColor greenColor];
//        }else if([_skinThemeName isEqualToString:lmSkinThemeRed]){
//            _themeColor = [UIColor redColor];
//        }
//        [[NSNotificationCenter defaultCenter]postNotificationName:SkinThemeChangeNotification object:nil];
//    }
//}



@end
