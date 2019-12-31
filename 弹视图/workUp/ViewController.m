//
//  ViewController.m
//  workUp
//
//  Created by szyl on 16/6/8.
//  Copyright © 2016年 xyh. All rights reserved.
//

#import "ViewController.h"
#import "UIView+Toast.h"
@interface ViewController ()

@end
static UIWindow *__sheetWindow = nil;
@implementation ViewController
{
    UIButton *btn;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(100, 100, 100, 100);
    [btn setTitle:@"哈哈" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:@"AppIcon29x29@2x"] forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:@"AppIcon40x40@2x"] forState:UIControlStateSelected];
    [btn addTarget:self action:@selector(addWindowAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
}
-(void)addWindowAction{
    
    UIWindow *window = [[UIWindow alloc] initWithFrame:(CGRect) {{0.f, 0.f}, [[UIScreen mainScreen] bounds].size}];
    window.backgroundColor = [UIColor clearColor];
    window.windowLevel = UIWindowLevelNormal;
    window.alpha = 1.f;
    window.hidden = NO;
    
    UIView* view = [[UIView alloc] initWithFrame:CGRectMake(30, 30, 100, 100)];
    UIButton* btn = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    btn.frame = CGRectMake(10, 10, 20, 20);
    [view addSubview:btn];
    [btn addTarget:self action:@selector(removeWindowAction) forControlEvents:UIControlEventTouchUpInside];
    view.backgroundColor = [UIColor redColor];
    [window addSubview:view];
    
    __sheetWindow = window;
}
-(void)removeWindowAction{
    __sheetWindow.hidden = YES;
    __sheetWindow = nil;
}
- (void)haha:(UIButton *)sender{
    sender.selected = !sender.selected;
//    CGPoint point = CGPointMake(100, 100);
//    [self.view makeToast:@"哈哈" duration:2 position:CSToastPositionTop title:@"1234" image:[UIImage imageNamed:@"AppIcon29x29@2x"]];
//    [self.view makeToastActivity:btn];
//    [self addPromptToView:self.view andPrompText:@"出来吧！大逗逼！" autoSize:YES durationTime:3.0];
    [self.view makeToast:@"1234567"];
}
- (UIView *) addPromptToView:(UIView *)view andPrompText:(NSString *)text autoSize:(BOOL) bAutoSize
{
    
    UIView *promptView = [[UIView alloc] initWithFrame:view.bounds];
    [promptView setBackgroundColor:[UIColor clearColor]];
    
    CGFloat width = 200;
    CGFloat height = 80;
    
    if (bAutoSize) {
        UIFont *font = [UIFont fontWithName:@"HelveticaNeue" size:12];
        CGSize autosize = [text sizeWithAttributes:@{@"NSFontAttributeName" : font                                                                     }];
        width = autosize.width + 20;
        height = autosize.height + 16;
    }
    
    CGRect frame = CGRectMake(roundf((promptView.bounds.size.width - width)/2), roundf((promptView.bounds.size.height - height)/2), width, height);
    
    UIView *messageView = [[UIView alloc] initWithFrame:frame];
    [messageView.layer setBorderWidth:1.0];
    [messageView.layer setBorderColor:[UIColor blackColor].CGColor];
    [messageView.layer setCornerRadius:5.0];
    messageView.alpha = 0.8;
    [messageView setBackgroundColor:[UIColor blackColor]];
    
    [promptView addSubview:messageView];
    
    CGRect rect = CGRectInset(messageView.frame, 10, 8);
    
    UILabel *label = [[UILabel alloc] initWithFrame:rect];
    label.text = text;
    [label setBackgroundColor:[UIColor clearColor]];
    label.font = [UIFont systemFontOfSize:12];
    label.textColor = [UIColor whiteColor];
    label.numberOfLines = 2;
    label.textAlignment = NSTextAlignmentCenter;
    label.lineBreakMode = NSLineBreakByTruncatingTail;
    [label sizeThatFits:rect.size];
    
    [promptView addSubview:label];
    
    [view addSubview:promptView];
    
    return promptView;
}

- (void) addPromptToView:(UIView *)view andPrompText:(NSString *)text autoSize:(BOOL) bAutoSize durationTime:(NSTimeInterval) time
{
    UIView * prompt = [self addPromptToView:view andPrompText:text autoSize:bAutoSize];
    [prompt performSelector:@selector(removeFromSuperview) withObject:nil afterDelay:time];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
