//
//  LoginViewController.m
//  LoginWithPhoneDemo
//
//  Created by 许艳豪 on 15/10/27.
//  Copyright © 2015年 ideal_Mac. All rights reserved.
//

#import "LoginViewController.h"

#define KScreenHight [UIScreen mainScreen].bounds.size.height
#define KScreenWidth [UIScreen mainScreen].bounds.size.width


@interface LoginViewController ()<UITextFieldDelegate>
@property (nonatomic, strong) UIButton *verifyBtn;
@property (nonatomic, strong) UIButton *loginBtn;
@property (nonatomic, strong) UILabel *numLabel;
@property (nonatomic, strong) UITextField *phoneNumTf;
@property (nonatomic, strong) UITextField *verifyTf;
@end

@implementation LoginViewController
- (void)loadView
{
    // 将self.view设置成一个UIControl，添加点击事件，辅助隐藏文本框的第一响应者
    self.view = [[UIControl alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.view.backgroundColor = [UIColor whiteColor];
    [(UIControl *)self.view addTarget:self action:@selector(clickBack) forControlEvents:UIControlEventTouchDown];
}
// 点击背景使文本框失去第一响应者
- (void)clickBack
{
    [_phoneNumTf resignFirstResponder];
}

// 文本框进入编辑状态时，判断文本框的上边距，自身高度和距离键盘的距离，是否大于键盘的上边距，是则将self。view上衣该差值即可实现屏幕上移
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
//    CGRect oldFrame = _phoneNumTf.frame;
    CGRect oldFrame = textField.frame;
    
    float offset = oldFrame.origin.y+oldFrame.size.height+44 - (KScreenHight -216);
    float width = [[UIScreen mainScreen] bounds].size.width;
    float height = [[UIScreen mainScreen] bounds].size.height;
    
    if (offset > 0) {
        [UIView beginAnimations:@"resetViewHeight" context:nil];
        [UIView setAnimationDuration:0.35];
        CGRect rect =  CGRectMake(0, -offset, width, height);
        self.view.frame = rect;
        [UIView commitAnimations];
    }
}

// 失去第一响应者的时候将self.view的frame复原
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [UIView beginAnimations:@"resetViewHeight" context:nil];
    [UIView setAnimationDuration:0.1];
    self.view.frame = [[UIScreen mainScreen] bounds];
    [UIView commitAnimations];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationController.navigationBarHidden = YES;
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.backgroundColor = [UIColor groupTableViewBackgroundColor];
    btn.layer.masksToBounds = YES;
    btn.layer.borderColor = [UIColor grayColor].CGColor;
    btn.layer.borderWidth = 1;
    btn.frame = CGRectMake(20, KScreenHight-100, KScreenWidth/2, 44);
    [btn addTarget:self action:@selector(hahahha) forControlEvents:UIControlEventTouchDown];
//    [self.view addSubview:btn];
    [self creatUIFrame];
}
- (void)hahahha{
    NSLog(@"hahha");
}
- (void)creatUIFrame{
    _phoneNumTf = [[UITextField alloc] initWithFrame:CGRectMake(20, KScreenHight-100, KScreenWidth/2, 44)];
    //    _phoneNumTf.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"zw"]];
    _phoneNumTf.keyboardType = UIKeyboardTypeNumberPad;
    _phoneNumTf.backgroundColor = [UIColor yellowColor];
    _phoneNumTf.placeholder = @"请输入手机号：";
    _numLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 60, 44)];
    _numLabel.text = @"账  号:";
    _numLabel.backgroundColor = [UIColor clearColor];
    _phoneNumTf.leftView = _numLabel;
    _phoneNumTf.leftViewMode = UITextFieldViewModeAlways;
//    _phoneNumTf.enabled = NO;
    _phoneNumTf.delegate = self;
    [self.view addSubview:_phoneNumTf];
    
    _verifyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _verifyBtn.frame = CGRectMake(KScreenWidth/2+70, KScreenHight-300, 150, 44);
    _verifyBtn.backgroundColor = [UIColor greenColor];
    [_verifyBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
    [self.view addSubview:_verifyBtn];
    [_verifyBtn addTarget:self action:@selector(touchBtn) forControlEvents:UIControlEventTouchUpInside];
}
- (void)touchBtn{
    
    [self startTime:3 :_verifyBtn :nil];
}
-(void)startTime:(int)time :(UIButton *)timeButton :(UIImage *)image
{
    __block int timeout=time; //倒计时时间
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(_timer, ^{
        if(timeout<=0){ //倒计时结束，关闭
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                [timeButton setBackgroundImage:image forState:UIControlStateNormal];
                [timeButton setTitle:@"获取验证码" forState:UIControlStateNormal];
                
                timeButton.userInteractionEnabled = YES;
            });
        }else{
            //            int minutes = timeout / 60;
            int seconds = timeout % 60;
            NSString *strTime = [NSString stringWithFormat:@"%.2d", seconds];
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                [timeButton setTitle:[NSString stringWithFormat:@"%@秒",strTime] forState:UIControlStateNormal];
                timeButton.userInteractionEnabled = NO;
            });
            timeout--;
        }
    });
    dispatch_resume(_timer);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
