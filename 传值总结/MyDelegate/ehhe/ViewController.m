//
//  ViewController.m
//  ehhe
//
//  Created by 许艳豪 on 15/10/28.
//  Copyright © 2015年 ideal_Mac. All rights reserved.
//

#import "ViewController.h"
#import "DelegateView.h"

@interface ViewController ()<UIWebViewDelegate,tempDelegate>
@property (nonatomic, strong) UIWebView *webview;
@property (nonatomic, strong) UILabel *ld;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.self.view.bounds.size.height
    self.view.backgroundColor = [UIColor whiteColor];
    _ld = [[UILabel alloc] initWithFrame:CGRectMake(200, 300, 100, 100)];
    _ld.backgroundColor = [UIColor greenColor];
    _ld.textColor = [UIColor redColor];
//    _ld.text = @"111e";
    [self.view addSubview:_ld];
    
//    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
//    btn.backgroundColor = [UIColor yellowColor];
//    btn.frame = CGRectMake(50, 50, 70, 20);
//    [btn addTarget:self action:@selector(transValue:) forControlEvents:UIControlEventTouchDown];
//    [self.view addSubview:btn];
    
    DelegateView *via = [[DelegateView alloc] init];
    via.delegate = self;
    via.frame = CGRectMake(100, 200, 100, 70);
    [self.view addSubview:via];
    
}
- (void)transValue:(NSString *)strValue{
    _ld.text = strValue;
}

- (void)haha{
    UIView *vi = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 50)];
    vi.backgroundColor = [UIColor redColor];
    [self.view addSubview:vi];
    [self closeDialogView:vi];
}

// 动画
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
