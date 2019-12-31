//
//  HttpBaseAction.m
//  qch
//
//  Created by 苏宾 on 16/1/7.
//  Copyright © 2016年 qch. All rights reserved.
//

#import "HttpBaseAction.h"

#define TIMEOUTSECONDS 30

@implementation HttpBaseAction

+ (AFHTTPRequestOperationManager *)defaultManager{
    static AFHTTPRequestOperationManager *manager;
    @synchronized(self){
        if (manager == nil) {
            manager=[[AFHTTPRequestOperationManager alloc]init];
            manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
            // 设置请求格式
            manager.responseSerializer = [AFHTTPResponseSerializer serializer];
            manager.requestSerializer.timeoutInterval=TIMEOUTSECONDS;
        }
    }
    return manager;
}


+ (void)postMDRequest:(NSMutableDictionary *)parameters url:(NSString *)url complete:(HttpCompleteBlock)block{

    NSError *parseError=nil;
    
    NSData *jsonData=[NSJSONSerialization dataWithJSONObject:parameters options:kNilOptions error:&parseError];
    
    NSString *str=[[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    [[HttpBaseAction defaultManager]POST:url parameters:str success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary *responseDictionary=responseObject;
        
        block(responseDictionary,nil);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error){
        block(nil,error);
    }];
}

+(void)postDRequest:(NSDictionary *)parameters url:(NSString *)url complete:(HttpCompleteBlock)block{

    //把传进来的URL字符串转变为URL地址
    NSURL *URL = [NSURL URLWithString:url];
    //请求初始化，可以在这针对缓存，超时做出一些设置
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:URL
                                                           cachePolicy:NSURLRequestReloadIgnoringCacheData
                                                       timeoutInterval:30];
    //解析请求参数，用NSDictionary来存参数，通过自定义的函数parseParams把它解析成一个post格式的字符串
    NSString *parseParamsResult = [self parseParams:parameters];
    NSData *postData = [parseParamsResult dataUsingEncoding:NSUTF8StringEncoding];
    
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:postData];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"content-type"];//请求头
    
    NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    
    NSArray *result = [NSJSONSerialization JSONObjectWithData:returnData options:NSJSONReadingMutableLeaves error:nil];
    
//    NSDictionary *result = [NSJSONSerialization JSONObjectWithData:returnData options:NSJSONReadingMutableLeaves error:nil];
    block(result,nil);

}

//把NSDictionary解析成post格式的NSString字符串
+ (NSString *)parseParams:(NSDictionary *)params{
    
    NSString *keyValueFormat;
    NSMutableString *result = [NSMutableString new];
    //实例化一个key枚举器用来存放dictionary的key
    NSEnumerator *keyEnum = [params keyEnumerator];
    id key;
    while (key = [keyEnum nextObject]) {
        keyValueFormat = [NSString stringWithFormat:@"%@=%@&",key,[params valueForKey:key]];
        [result appendString:keyValueFormat];
        //NSLog(@"post()方法参数解析结果：%@",result);
    }
    return result;
}



+(void)getRequest:(NSString*)str complete:(HttpCompleteBlock)block{

    NSURL *url = [NSURL URLWithString:[str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSString *html = operation.responseString;
        if([self isBlankString:html]){
            block(nil,nil);
        }else{
            NSData *data=[html dataUsingEncoding:NSUTF8StringEncoding];
            id dict=[NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            block(dict,nil);
        }
                // NSLog(@"获取到的数据为：%@",dict);
    }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        block(nil,error);
        NSLog(@"发生错误！%@",error);
    }];
    
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    [queue addOperation:operation];

}

+ (void)alipayData:(NSString*)orderStr complete:(HttpCompleteBlock)block{

    [[AlipaySDK defaultService] payOrder:orderStr fromScheme:@"qch" callback:^(NSDictionary *resultDic) {
        NSLog(@"result:%@",resultDic);
        block([resultDic objectForKey:@"resultStatus"],nil);
    }];
}

+ (void)postJSONWithUrl:(NSString *)urlStr parameters:(id)parameters success:(void (^)(id responseObject))success fail:(void (^)())fail{
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    
    // 设置请求格式
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager POST:urlStr parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if (success) {
            success(responseObject);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (fail) {
            fail();
        }
    }];
    
}

+ (BOOL)isBlankString:(NSString *)string{
    if (string == nil || string == NULL) {
        return YES;
    }
    if ([string isKindOfClass:[NSNull class]]) {
        return YES;
    }
    if ([[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]==0) {
        return YES;
    }
    return NO;
}

@end
