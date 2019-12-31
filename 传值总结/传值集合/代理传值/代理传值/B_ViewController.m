//
//  B_ViewController.m
//  属性传值
//
//  Created by zyx on 16/3/18.
//  Copyright © 2016年 zyx. All rights reserved.
//

#import "B_ViewController.h"


@interface B_ViewController ()
{
    UITextField *bTextField;
}
@end

@implementation B_ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"B";
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.view.backgroundColor = [UIColor whiteColor];
    bTextField = [[UITextField alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width/2-50, 200, 100, 30)];
    
    bTextField.layer.borderColor = [UIColor grayColor].CGColor;
    bTextField.layer.borderWidth = 1;
    [self.view addSubview:bTextField];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake([UIScreen mainScreen].bounds.size.width/2-50, 280, 100, 30);
    [button setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [button setTitle:@"传值A" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
    

    
}

- (void)buttonAction:(UIButton *)sender {
    
    // 判断有没用遵循代理 有就执行
    if (self.delegate && [self.delegate conformsToProtocol:@protocol(Nextprotocol)]) {
        [self.delegate transferString:bTextField.text];
    }
    
    
    [self.navigationController popToRootViewControllerAnimated:YES];
      
}



@end
