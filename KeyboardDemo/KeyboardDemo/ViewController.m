//
//  ViewController.m
//  KeyboardDemo
//
//  Created by 许艳豪 on 15/10/20.
//  Copyright © 2015年 ideal_Mac. All rights reserved.
//

#import "ViewController.h"

#define KScreenHeight ([UIScreen mainScreen].bounds.size.height)
#define kSCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)

@interface ViewController ()<UITextViewDelegate>
@property (nonatomic, strong)UIView *criticleBarView;
@property (nonatomic, strong)UITextView *criticleTextView;
@property (nonatomic, strong)UIButton *sendBtn;
@property (nonatomic, strong)UIButton *startBtn;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    _startBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _startBtn.frame = CGRectMake(100, 100, 200, 120);
//    _startBtn.backgroundColor = [UIColor greenColor];
    _startBtn.layer.borderWidth = 2;
    _startBtn.layer.borderColor = [UIColor redColor].CGColor;
    _startBtn.layer.masksToBounds= YES;
    _startBtn.layer.cornerRadius = 40;
    [_startBtn setTitle:@"show time" forState:UIControlStateNormal];
    [_startBtn setTitleColor:[UIColor greenColor] forState:UIControlStateNormal];
    [_startBtn addTarget:self action:@selector(bottomBtnTap) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:_startBtn];
    
    //可让输入框显示在视图中也可不显示，只是frame.y不同的问题。
    _criticleBarView = [[UIView alloc]initWithFrame:CGRectMake(0, KScreenHeight-40, kSCREEN_WIDTH, 40)];
    _criticleBarView.backgroundColor = [UIColor grayColor];
    [self.view addSubview:_criticleBarView];

    _criticleTextView = [[UITextView alloc]initWithFrame:CGRectMake(20, 5, kSCREEN_WIDTH-80, 30)];
    _criticleTextView.delegate = self;
    _criticleTextView.font=[UIFont fontWithName:@"Arial" size:14.0]; //设置字体名字和字体大小;
    _criticleTextView.keyboardType = UIKeyboardTypeDefault;//键盘类型
    [_criticleBarView addSubview:_criticleTextView];
 
    _sendBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _sendBtn.frame = CGRectMake(kSCREEN_WIDTH-55, 5, 50, 30);
    [_sendBtn setTitle:@"发送" forState:UIControlStateNormal];
    [_sendBtn setBackgroundColor:[UIColor colorWithRed:0 green:168.0/255 blue:180.0/255 alpha:1]];

    [_sendBtn setTintColor:[UIColor whiteColor]];
    _sendBtn.layer.cornerRadius = 5;
    [_sendBtn addTarget:self action:@selector(sendCriticle:) forControlEvents:UIControlEventTouchUpInside];
    [_criticleBarView addSubview:_sendBtn];
    
    
    //添加手势，点击空白，使键盘下沉。
    UITapGestureRecognizer *tapGest = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(keyboardDown)];
    tapGest.numberOfTapsRequired = 1;
    [self.view addGestureRecognizer:tapGest];
}
-(void)bottomBtnTap{
    [_criticleTextView becomeFirstResponder];
}
-(void)keyboardDown{
    [_criticleTextView resignFirstResponder];
}
- (void)sendCriticle:(UIButton *)sender{
//    UIButton *btn = (UIButton *)sender;
    NSLog(@"%@",_criticleTextView.text);
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    //    self.tabBarController.tabBar.hidden = YES;
//    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
    
}
- (void)keyboardWillShow:(NSNotification *)notification {
    
    //    isKeyboardShowing = YES;
    
    NSDictionary *userInfo = [notification userInfo];
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    
    CGRect keyboardRect = [aValue CGRectValue];
    keyboardRect = [self.view convertRect:keyboardRect fromView:nil];
    
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    //    CGSize keyboardSize = [animationDurationValue CGRectValue].size;
    
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    
    [UIView animateWithDuration:animationDuration
                     animations:^{
                         CGRect frame = _criticleBarView.frame;
                         
                         frame.origin.y =keyboardRect.origin.y-40;
                         _criticleBarView.frame = frame;
                         
                     }];
    
}

- (void)keyboardWillHide:(NSNotification *)notification {
    
    NSDictionary *userInfo = [notification userInfo];
    
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    
    [UIView animateWithDuration:animationDuration
                     animations:^{
                         CGRect frame = _criticleBarView.frame;
                         frame.origin.y =KScreenHeight-40;
                         _criticleBarView.frame = frame;
                         
                     }];
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    //    self.tabBarController.tabBar.hidden=NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
