//
//  ViewController.m
//  temDemo
//
//  Created by 许艳豪 on 15/12/11.
//  Copyright © 2015年 ideal_Mac. All rights reserved.
//

#import "ViewController.h"
//#import "StepCircleView.h"
#import "MBProgressHUD+MJ.h"
//#import "WebViewJavascriptBridge.h"
@interface ViewController ()<UIWebViewDelegate>
@property (nonatomic, strong) UIWebView *webView;
//@property (nonatomic,strong)WebViewJavascriptBridge *javaBridge;
@end

@implementation ViewController

//- (void)viewDidLoad {
//    [super viewDidLoad];
// 
//    StepCircleView *cirView1 = [[StepCircleView alloc] init];
//    cirView1.score = 100*1.0/100;
//    cirView1.frame = CGRectMake(self.view.frame.size.width/2-200, 0, 100, 200);
//    cirView1.isDefualt = @"hah";
//    
//    
//    StepCircleView *cirView2 = [[StepCircleView alloc] init];
//    cirView2.score = 100*1.0/100;
//    cirView2.isDefualt = @"isDefualt";
//    cirView2.frame = CGRectMake(self.view.frame.size.width/2-200, 0, 100, 200);
//    [self.view addSubview:cirView2];
//    [self.view addSubview:cirView1];
//}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    _webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
    _webView.delegate = self;
    [self.view addSubview:_webView];

    
    NSURL *url = [NSURL URLWithString:@"https://www.baidu.com"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [_webView loadRequest:request];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(10, 30, 70, 20);
    btn.backgroundColor = [UIColor greenColor];
    [btn setTitle:@"变小" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(bianxiao) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:btn];
    
}
- (void)bianxiao{
    [_webView stringByEvaluatingJavaScriptFromString:
     @"var script = document.createElement('script');"
     "script.type = 'text/javascript';"
     "script.text = \"function ResizeImages() { "
     "var myimg,oldwidth;"
     "var maxwidth=30;" //缩放系数
     "for(i=0;i <document.images.length;i++){"
     "myimg = document.images[i];"
     "if(myimg.width > maxwidth){"
     "oldwidth = myimg.width;"
     "myimg.width = maxwidth;"
     "myimg.height = myimg.height * (maxwidth/oldwidth);"
     "}"
     "}"
     "}\";"
     "document.getElementsByTagName('head')[0].appendChild(script);"];
    [_webView stringByEvaluatingJavaScriptFromString:@"ResizeImages();"];
}
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    NSString *urlStr = request.URL.absoluteString;
    if (nil == urlStr || [@"" isEqualToString:urlStr]) {
        return YES;
    }
    NSURL *url = [request URL];
    if([[url scheme] isEqualToString:@"http"]) {
        //处理JavaScript和Objective-C交互
        if([[url host] isEqualToString:@"m.hao123.com"])
        {
            NSString *paramStr = [urlStr substringFromIndex:([urlStr rangeOfString:@"?"].location+1)];
            NSDictionary *paramDic = [self getParams:paramStr];
            if ([paramDic[@"itj"] isEqualToString:@"49"]) {
//                [webView stringByEvaluatingJavaScriptFromString:@"alert('进入贴吧啦!')"];
                [MBProgressHUD showSuccess:@"hahae"];
                return NO;
            }
        }
        return YES;
    }
    return YES;
}
- (NSDictionary *)getParams:(NSString *)paramsStr{
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    NSArray *params = [paramsStr componentsSeparatedByString:@"&"];
    for (int i=0; i<params.count; i++) {
        NSArray *arr = [params[i] componentsSeparatedByString:@"="];
        [dic setValue:arr[1] forKey:arr[0]];
    }
    return dic;
    
}
//- (void)webViewDidStartLoad:(UIWebView *)webView{
//    [MBProgressHUD showMessage:@"正在加载数据..." toView:self.view];
//    NSLog(@"正在加载数据");
//}
//- (void)webViewDidFinishLoad:(UIWebView *)webView{
//    [MBProgressHUD hideHUDForView:self.view animated:YES];
//    NSLog(@"加载完成");
//}
//- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
//    [MBProgressHUD hideHUDForView:self.view animated:YES];
//    [MBProgressHUD showError:@"加载失败！" toView:self.view];
//    NSLog(@"加载失败");
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




@end
