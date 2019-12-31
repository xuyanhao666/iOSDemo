//
//  MyHttpRequest.m
//  HttpRequestDemo
//
//  Created by szyl on 16/6/6.
//  Copyright © 2016年 xyh. All rights reserved.
//

#import "MyHttpRequest.h"

@implementation MyHttpRequest
+ (MyHttpRequest *)getClientWithHost:(NSString*)host{
    MyHttpRequest * client;
    client = [[MyHttpRequest alloc]initWithBaseURL:[NSURL URLWithString:host]];
    client.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html",@"text/json",@"text/javascript", nil];
    client.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    client.requestSerializer.timeoutInterval = 60;
    NSLog(@"%@",client.baseURL);
    return client;
}

+ (id)shareInstanceWithHost:(NSString*)host{
    static MyHttpRequest *client = nil;
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
- (void)PostType:(NSString *)type Parameters:(id)parameters Success:(void (^)(id))success Failed:(void (^)(NSError *))failed{
    if(self.reachabilityManager.networkReachabilityStatus == AFNetworkReachabilityStatusNotReachable){
        SCLAlertView* alert = [[SCLAlertView alloc]initWithNewWindow];
        [alert showNotice:nil subTitle:@"请检查您的网络" closeButtonTitle:nil duration:2];
        return;
    }
    NSDictionary* post = @{@"gson":[parameters JSONString],@"type":type};
    NSLog(@"httpRequest_%@:%@",type,[post JSONString]);
    [self POST:TEMP_BASE_URL parameters:post success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"httpRequest_接口_%@==%@",type,task.currentRequest.URL);
        NSLog(@"%@_%@",type,[responseObject JSONString]);
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
        SCLAlertView* alert = [[SCLAlertView alloc]initWithNewWindow];
        [alert showError:nil subTitle:error.description closeButtonTitle:nil duration:1.5];
        
        failed(error);
    }];


}
@end
