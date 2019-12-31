//
//  LMServiceClient.m
//  Framework
//
//  Created by zero on 15/7/27.
//  Copyright (c) 2015年 zero. All rights reserved.
//

#import "LMServiceClient.h"


@implementation LMServiceClient

+ (LMServiceClient*)getClientWithHost:(NSString*)host{
    LMServiceClient* client;
    client = [[LMServiceClient alloc]initWithBaseURL:[NSURL URLWithString:host]];
    client.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html",@"text/json",@"text/javascript", nil];
    client.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    client.requestSerializer.timeoutInterval = 60;
    NSLog(@"%@",client.baseURL);
    return client;
}

+ (id)shareInstanceWithHost:(NSString*)host{
    static LMServiceClient* client = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        client = [self getClientWithHost:TempURL];
    });
    if(host != nil){
        client = [self getClientWithHost:host];
    }
    return client;
}

+ (id)shareInstance{
    return [self shareInstanceWithHost:nil];
}

- (void)PostWithoutHudType:(NSString*)type Parameters:(id)parameters Success:(void (^)(id result))success Failed:(void(^)(NSError *error))failed{
    
    [self PostType:type Parameters:parameters ShowHud:YES RespondInteractions:NO Success:^(id result) {
        success(result);
    } Failed:^(NSError *error) {
        failed(error);
    }];
}
- (void)PostType:(NSString*)type Parameters:(id)parameters ShowHud:(BOOL)show RespondInteractions:(BOOL)respond Success:(void (^)(id result))success Failed:(void(^)(NSError *error))failed{
    respond = NO;
    if(self.reachabilityManager.networkReachabilityStatus == AFNetworkReachabilityStatusNotReachable){
        SCLAlertView* alert = [[SCLAlertView alloc]initWithNewWindow];
        [alert showNotice:nil subTitle:@"请检查您的网络" closeButtonTitle:nil duration:2];
        return;
    }
    if(show){
        if(respond){
            [SVProgressHUD showWithStatus:@"加载中......" maskType:SVProgressHUDMaskTypeNone];
        }else{
            [SVProgressHUD showWithStatus:@"加载中......" maskType:SVProgressHUDMaskTypeBlack];
        }
    }
    NSDictionary* post = @{@"gson":[parameters JSONString],@"type":type};
    NSLog(@"httpRequest_%@:%@",type,[post JSONString]);
    [self POST:TEMP_BASE_URL parameters:post success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"%@_%@",type,[responseObject JSONString]);
        if(show){
            [SVProgressHUD dismiss];
        }
        NSNumber* code = [responseObject objectForKey:@"isErrmsg"];
        if(![code boolValue]){
            success(responseObject);
        }else{
            SCLAlertView* alert = [[SCLAlertView alloc]initWithNewWindow];
            [alert showError:nil subTitle:[responseObject objectForKey:@"errMsg"] closeButtonTitle:nil duration:1.5];
            failed(nil);
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"%@",error);
        if(show){
            [SVProgressHUD dismiss];
        }
        SCLAlertView* alert = [[SCLAlertView alloc]initWithNewWindow];
        [alert showError:nil subTitle:error.description closeButtonTitle:nil duration:1.5];
        
        failed(error);
    }];
}



@end
