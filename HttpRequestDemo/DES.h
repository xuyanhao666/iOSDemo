//
//  DES.h
//  SHWDProgram
//
//  Created by xiantian on 16/3/25.
//  Copyright © 2016年 xiantian. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DES : NSObject


+ (NSString *)encryptWithText:(NSString *)sText;//加密
+ (NSString *)decryptWithText:(NSString *)sText;//解密

+ (NSString *) encryUseDES: (NSString *)planiText ;
+ (NSString *) decryptUseDES:(NSString*)cipherText ;


//3des
+ (NSString *)tripleDES:(NSString*)plainTex key:(NSString*)key;


// 字典转json字符串
+ (NSString*)dictionaryToJson:(NSDictionary *)dic;

//获取毫秒级时间戳
+(NSString *)timesecond;

// 网络请求
+(void)ASfornetworkjsonstringurl:(NSString *)myurlopen success:(void (^)(NSString *str))success
                       failure:(void (^)(NSString *st))failure;

@end
