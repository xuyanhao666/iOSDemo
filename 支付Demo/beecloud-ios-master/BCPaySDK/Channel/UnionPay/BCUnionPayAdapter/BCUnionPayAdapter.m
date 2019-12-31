//
//  BCUnionPayAdapter.m
//  BeeCloud
//
//  Created by Ewenlong03 on 15/9/9.
//  Copyright (c) 2015年 BeeCloud. All rights reserved.
//

#import "BCUnionPayAdapter.h"
#import "BeeCloudAdapterProtocol.h"
#import "UPPayPlugin.h"

@interface BCUnionPayAdapter ()<BeeCloudAdapterDelegate, UPPayPluginDelegate>

@end


@implementation BCUnionPayAdapter

+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    static BCUnionPayAdapter *instance = nil;
    dispatch_once(&onceToken, ^{
        instance = [[BCUnionPayAdapter alloc] init];
    });
    return instance;
}

- (void)unionPay:(NSMutableDictionary *)dic {
    NSString *tn = [dic objectForKey:@"tn"];
    dispatch_async(dispatch_get_main_queue(), ^{
        [UPPayPlugin startPay:tn mode:@"00" viewController:dic[@"viewController"] delegate:[BCUnionPayAdapter sharedInstance]];
    });
}

#pragma mark - Implementation UnionPayDelegate

- (void)UPPayPluginResult:(NSString *)result {
    int errcode = BCErrCodeSentFail;
    NSString *strMsg = @"支付失败";
    if ([result isEqualToString:@"success"]) {
        errcode = BCSuccess;
        strMsg = @"支付成功";
    } else if ([result isEqualToString:@"cancel"]) {
        errcode = BCErrCodeUserCancel;
        strMsg = @"支付取消";
    }
    
    BCPayResp *resp = (BCPayResp *)[BCPayCache sharedInstance].bcResp;
    resp.resultCode = errcode;
    resp.resultMsg = strMsg;
    resp.errDetail = strMsg;
    [BCPayCache beeCloudDoResponse];
}

@end
