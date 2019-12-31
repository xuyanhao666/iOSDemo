//
//  MyHttpRequest.h
//  HttpRequestDemo
//
//  Created by szyl on 16/6/6.
//  Copyright © 2016年 xyh. All rights reserved.
//

#import "AFHTTPSessionManager.h"
#import "WebApi.h"
#import "JSONKit.h"
#import "SCLAlertView.h"
@interface MyHttpRequest : AFHTTPSessionManager

+ (id)shareInstance;
- (void)PostType:(NSString*)type Parameters:(id)parameters Success:(void (^)(id result))success Failed:(void(^)(NSError *error))failed;

@end
