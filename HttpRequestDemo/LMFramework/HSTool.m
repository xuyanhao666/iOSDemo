//
//  HSTool.m
//  FirstHospital_IOS
//
//  Created by szyl on 15/10/22.
//  Copyright © 2015年 上海理想信息有限公司. All rights reserved.
//

#import "HSTool.h"

@implementation HSTool

+(NSString*)checkTheString:(NSString*)dString withType:(NSString*)type andIndex:(NSInteger)index
{
    NSArray *array = [dString componentsSeparatedByString:type];
    NSString *resultString = [array objectAtIndex:index];
    return resultString;
}


@end
