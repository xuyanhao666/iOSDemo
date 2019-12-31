//
//  LMServiceClient.h
//  Framework
//
//  Created by zero on 15/7/27.
//  Copyright (c) 2015年 zero. All rights reserved.
//

#import "AFHTTPSessionManager.h"
#import "UIAlertView+AFNetworking.h"
#import "JSONKit.h"
#import "SVProgressHUD.h"
#import "WebApi.h"
#import "SCLAlertView.h"
//#import "HeaderHelper.h"

@interface LMServiceClient : AFHTTPSessionManager
+ (id)shareInstance;
- (void)PostType:(NSString*)type Parameters:(id)parameters ShowHud:(BOOL)show RespondInteractions:(BOOL)respond Success:(void (^)(id result))success Failed:(void(^)(NSError *error))failed;
- (void)PostWithoutHudType:(NSString*)type Parameters:(id)parameters Success:(void (^)(id result))success Failed:(void(^)(NSError *error))failed;
@end
