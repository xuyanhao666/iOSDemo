//
//  NetRequestObject.m
//  JSZJ_PA_iPhone
//
//  Created by prbk on 17/9/22.
//  Copyright © 2017年 primb. All rights reserved.
//

#import "NetRequestObject.h"
#import "AFNetworking.h"
@implementation NetRequestObject
#pragma mark 普通数据请求
+(void)netRequestWithURL:(NSString *) urlStr
           andParameters:(NSDictionary *) paraDic
        andFinishedBlock:(NetFinishBlock) block{
    
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        dispatch_async(dispatch_get_main_queue(), ^{
//            flat为默认圆圈，native为菊花
//            [SVProgressHUD setDefaultAnimationType:SVProgressHUDAnimationTypeFlat];
//            none为默认无遮罩层，clear为透明遮罩层
//            [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
//            light默认为白色
//            [SVProgressHUD setDefaultStyle:SVProgressHUDStyleLight];
//            [SVProgressHUD showWithStatus:@"加载..."];
        });
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
//            __block BOOL reachable = [AFNetworkReachabilityManager sharedManager].isReachable;
//            __block BOOL reachable = true;
//            if(reachable){
            
                AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
                manager.responseSerializer = [AFHTTPResponseSerializer serializer];
                // post请求
                [manager POST:urlStr parameters:paraDic constructingBodyWithBlock:^(id  _Nonnull formData) {
                } progress:^(NSProgress * _Nonnull uploadProgress) {
                } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                    // 请求成功，解析数据
                    NSDictionary * mainDataDic = [NSJSONSerialization JSONObjectWithData:responseObject
                                                                                 options:NSJSONReadingMutableContainers | NSJSONReadingMutableLeaves error:nil];
                    if(!mainDataDic || ![mainDataDic isKindOfClass:[NSDictionary class]]){
                        block(NO,@{@"failMessage":@"服务器返回数据异常！",@"data":@{}});
//                        [SVProgressHUD dismiss];
                        return ;
                    }
                    if(![[mainDataDic objectForKey:@"error"] boolValue]){
                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                            block(YES,@{@"failMessage":@"",@"data":mainDataDic[@"data"]});
//                            [SVProgressHUD dismiss];
                        });
                    }else{
                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                            if([mainDataDic[@"msgCode"] isEqualToString:@"0000"]){
                                //请求超时
                                block(NO,@{@"failMessage":mainDataDic[@"msgCode"],@"data":@{}});
                            }else{
                                block(NO,@{@"failMessage":mainDataDic[@"msg"],@"data":@{}});
                            }
//                            [SVProgressHUD dismiss];
                        });
                    }
                } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        block(NO,@{@"failMessage":@"请求失败！",@"data":@{}});
//                        [SVProgressHUD dismiss];
                    });
                }];
//            }else{
//                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                    block(NO,@{@"failMessage":@"没有网络！",@"data":@""});
//                    [SVProgressHUD dismiss];
//                });
//            }
        });
        
    });
    
}




@end
