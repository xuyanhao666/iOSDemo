//
//  AppDelegate.m
//  testAliPay
//
//  Created by JSen on 14/9/29.
//  Copyright (c) 2014年 wifitong. All rights reserved.
//

#import "AppDelegate.h"
#import "alipay/AlixPayResult.h"
#import "DataSigner.h"
#import "DataVerifier.h"
#import "PartnerConfig.h"
#import "Define.h"
#import "WXApi.h"
#import "JSenPayEngine.h"
@interface AppDelegate ()<WXApiDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
  BOOL isok = [WXApi registerApp:kWXAppID];
    if (isok) {
        NSLog(@"注册微信成功");
    }else{
        NSLog(@"注册微信失败");
    }
    
    [JSenPayEngine connectAliPayWithSchema:kAppSchema partner:PartnerID seller:SellerID RSAPrivateKey:PartnerPrivKey RSAPublicKey:AlipayPubKey];
    
    return YES;
}

/*
 sourceApplication:
 
 1.com.tencent.xin
 
 2.com.alipay.safepayclient
 */

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation{
    NSLog(@"source app-%@, des app-%@",sourceApplication,application);
    
    if ([sourceApplication isEqualToString:@"com.tencent.xin"]) {
        return [WXApi handleOpenURL:url delegate:self];
    }else if ([sourceApplication isEqualToString:@"com.alipay.safepayclient"]) {
         [self parse:url application:application];
        return YES;
    }
    return YES;
    
}


- (void)onResp:(BaseResp *)resp
{
    NSLog(@"%@",resp);
    if ([resp isKindOfClass:[PayResp class]]) {
        
        NSString *strTitle = [NSString stringWithFormat:@"支付结果"];
        NSString *strMsg = [NSString stringWithFormat:@"errcode:%d", resp.errCode];
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:strTitle
                                                        message:strMsg
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil, nil];
        [alert show];
        
      
    }
}


- (void)parse:(NSURL *)url application:(UIApplication *)application {
    
    //结果处理
    AlixPayResult* result = [self handleOpenURL:url];
    
    if (result)
    {
        
        if (result.statusCode == 9000)
        {
            /*
             *用公钥验证签名 严格验证请使用result.resultString与result.signString验签
             */
            
            //交易成功
           // NSString* key = @"签约帐户后获取到的支付宝公钥";
            id<DataVerifier> verifier;
            verifier = CreateRSADataVerifier(AlipayPubKey);
            
            if ([verifier verifyString:result.resultString withSign:result.signString])
            {
                //验证签名成功，交易结果无篡改
                
            }
            
        }
        else
        {
            //交易失败
        }
    }
    else
    {
        //失败
    }
    
}

- (AlixPayResult *)resultFromURL:(NSURL *)url {
    NSString * query = [[url query] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];

    return [[AlixPayResult alloc] initWithString:query];

}

- (AlixPayResult *)handleOpenURL:(NSURL *)url {
    AlixPayResult * result = nil;
    
    if (url != nil && [[url host] compare:@"safepay"] == 0) {
        result = [self resultFromURL:url];
    }
    
    return result;
}

@end
