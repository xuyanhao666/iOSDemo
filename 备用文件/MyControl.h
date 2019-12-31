//
//  MyControl.h
//  StudentManager
//
//  Created by leisure on 14-3-26.
//  Copyright (c) 2014年 leisure. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "sys/sysctl.h"

typedef void (^FinishBlock)(NSDictionary *dataDict);

@interface MyControl : NSObject

#pragma mark - 获取验证码
+(void)makeGetYanZhengMaAPI:(NSString *)telephoneString;

//网络请求
+(void)getUrl:(NSString *)url dataDict:(NSDictionary *)dataDict view:(UIView *)urlView isState:(BOOL) isState finshedBlock:(FinishBlock)block;
// post请求
+ (void)postUrl:(NSString *)url dataDict:(NSDictionary *)dataDict view:(UIView *)urlView isState:(BOOL)isState finshedBlock:(FinishBlock)block;
+(void)postUrl:(NSString *)url dataDict:(NSDictionary *)dataDict imageData:(NSData *)data imageNameString:(NSString *)name view:(UIView *)urlView isState:(BOOL) isState finshedBlock:(FinishBlock)block;

#pragma mark - 定义成方法方便多个label调用 增加代码的复用性
+(CGSize)sizeWithString:(NSString *)string font:(UIFont *)font;

#pragma mark - 设置圆角
+(void)setRad:(id)radView :(CGFloat) flaot;
#pragma mark 判断手机的型号
+(NSString*)doDevicePlatform;
//判断是否是第一次登录或是否是版本更新
+(BOOL)upDataVersion;
//没有交互效果的提示框，参数是提示的内容
+ (void)showAlert:(NSString *) _message;
+ (void)timerFireMethod:(NSTimer*)theTimer;

+(void)startTime:(int)time :(UIButton *)timeButton :(UIImage *)image;
//判断手机号是否合法
+(BOOL)isMobileNumber:(NSString *)mobileNum;
//色值转换
+(UIColor *)colorFromRGBHexString:(NSString *)colorString;
//用指定的标题和位置大小创建新标签
+(UILabel *)createLabel:(NSString*)title frame:(CGRect)frame ;
// 创建自定义特殊UILabel
+(UILabel *)createSpecialLabel:(NSString *)title number:(NSInteger)number;
//创建新的输入框
+(UITextField*)createTextField:(NSString*)placeHolder frame:(CGRect)frame tag:(NSInteger)tag delegate:(id)delegate;
//创建新按钮
+(UIButton*)createButton:(NSString*)title frame:(CGRect)frame tag:(NSInteger)tag;

+(UIImageView *)createImageView:(NSString*)imgName frame:(CGRect)frame;
//获取系统时间
+(NSString *)getCurrentTime;
// 图片灰色滤镜
+(UIImage *)grayImage:(UIImage *)sourceImage;
// 修改图片尺寸
+ (UIImage *)imageWithImageSimple:(UIImage*)image scaledToSize:(CGSize)newSize;
// 时间字符串转为自定义格式字符串
+ (NSString *)timeString:(NSString *)mytime formatterString:(NSString *)formatterStr;

@end









