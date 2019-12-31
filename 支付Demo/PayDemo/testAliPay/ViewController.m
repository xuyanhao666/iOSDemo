//
//  ViewController.m
//  testAliPay
//
//  Created by JSen on 14/9/29.
//  Copyright (c) 2014年 wifitong. All rights reserved.
//

#import "ViewController.h"
#import "alipay/AlixPayOrder.h"
#import "AlixPayResult.h"
#import "PartnerConfig.h"
#import "DataSigner.h"
#import "DataVerifier.h"
#import "JSenPayEngine.h"


@interface ViewController ()

- (IBAction)payAction:(UIButton *)sender;
- (IBAction)WXPayAction:(UIButton *)sender;

@end

@implementation ViewController

#pragma mark - 微信支付


- (IBAction)WXPayAction:(UIButton *)sender {
   
    [[JSenPayEngine sharePayEngine] wxPayAction];

    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    _result = @selector(paymentResult:);
    
 
    // Do any additional setup after loading the view, typically from a nib.
}

#pragma mark -
#pragma mark - 支付宝支付
- (void)paymentResult:(NSString *)resultd {
    AlixPayResult *result  = [[AlixPayResult alloc] initWithString:resultd];
    
    if (result) {
        
        if (result.statusCode == 9000) {
            NSString *key = AlipayPubKey;
            id<DataVerifier> verifier;
            verifier = CreateRSADataVerifier(key);
            
            if ([verifier verifyString:result.resultString withSign:result.signString]) {
                NSLog(@"交易成功");
            }
        }else {
            NSLog(@"交易失败");
        }
        
    }else {
         NSLog(@"交易失败");
    }
    
}

- (void)testAliPay {
   
    
    NSString *orderId = [self generateTradeNO];
    
    NSDictionary *dict = @{
                           kOrderID:orderId,
                           kTotalAmount:@"0.01",
                           kProductDescription:@"3D打印VS无人机，谁在未来更赚钱？",
                           kProductName:@"自制白开水",
                           kNotifyURL:@"http://jifenmall.sinaapp.com/api/payment/alipay_notify"
                           };
    
    [JSenPayEngine paymentWithInfo:dict result:^(int statusCode, NSString *statusMessage, NSString *resultString, NSError *error, NSData *data) {
        NSLog(@"statusCode=%d \n statusMessage=%@ \n resultString=%@ \n err=%@ \n data=%@",statusCode,statusMessage,resultString,error,data);
    }];
}

- (IBAction)payAction:(UIButton *)sender {
    
    [self testAliPay];
  
  }


- (NSString *)generateTradeNO
{
    const int N = 15;
    
    NSString *sourceString = @"0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ";
    NSMutableString *result = [[NSMutableString alloc] init] ;
    srand(time(0));
    for (int i = 0; i < N; i++)
    {
        unsigned index = rand() % [sourceString length];
        NSString *s = [sourceString substringWithRange:NSMakeRange(index, 1)];
        [result appendString:s];
    }
    return result;
}


@end
