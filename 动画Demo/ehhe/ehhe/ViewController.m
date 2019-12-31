//
//  ViewController.m
//  ehhe
//
//  Created by 许艳豪 on 15/10/28.
//  Copyright © 2015年 ideal_Mac. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()<UIWebViewDelegate>
@property (nonatomic, strong) UIWebView *webview;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.self.view.bounds.size.height
    self.view.backgroundColor = [UIColor whiteColor];
    _webview = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width , self.view.bounds.size.height)];
    _webview.delegate = self;
    [self.view addSubview:_webview];
//    UIButton *butn = [UIButton buttonWithType:UIButtonTypeCustom];
//    butn.frame = CGRectMake(100, 100, 100, 100);
//    butn.backgroundColor = [UIColor redColor];
//    [self.view addSubview:butn];
//    NSURL *url=[NSURL URLWithString:@"http://player.youku.com/embed/XMTM0MTY2NDA5Ng=="];
    NSURL *url = [NSURL URLWithString:@"https://www.baidu.com"];
    NSURLRequest *request=[NSURLRequest requestWithURL:url];
//    [_webview loadRequest:request];
    
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(100, 100, 200, 50)];
    btn.backgroundColor = [UIColor yellowColor];
    [btn addTarget:self action:@selector(goAppStore) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
}
- (void)goAppStore{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"itms-apps://itunes.apple.com/us/app/jian-kang-wu/id906262703?l=zh&ls=1&mt=8"]];
}
- (void)haha{
    UIView *vi = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 50)];
    vi.backgroundColor = [UIColor redColor];
    [self.view addSubview:vi];
    [self closeDialogView:vi];
}
-(void) showDialogView:(UIView *) view
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    [UIView beginAnimations:@"Dialog" context:context];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:0.5];
    CGRect rect = [view frame];
    
    rect.origin.x = 0;
    rect.origin.y = 0;
    [view setFrame:rect];
    [UIView commitAnimations];
}
-(void) closeDialogView:(UIView *) view
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    [UIView beginAnimations:@"Dialog" context:context];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:0.5];
    CGRect rect = [view frame];
    
    rect.origin.x = 0;
    rect.origin.y = 460;
    [view setFrame:rect];
    [UIView commitAnimations];
}
- (void)webViewDidFinishLoad:(UIWebView *)webView{
    NSLog(@"hha");
    [_webview stringByEvaluatingJavaScriptFromString:@"alert('登录成功!')"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
