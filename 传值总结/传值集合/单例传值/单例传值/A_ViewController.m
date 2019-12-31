//
//  A_ViewController.m
//  属性传值
//
//  Created by zyx on 16/3/18.
//  Copyright © 2016年 zyx. All rights reserved.
//

#import "A_ViewController.h"
#import "B_ViewController.h"
#import "DanLi.h"

@interface A_ViewController ()

{
    UITextField *aTextField;
}

@end

@implementation A_ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"A";
    self.view.backgroundColor = [UIColor whiteColor];
    aTextField = [[UITextField alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width/2-50, 200, 100, 30)];
    
    aTextField.layer.borderColor = [UIColor grayColor].CGColor;
    aTextField.layer.borderWidth = 1;
    [self.view addSubview:aTextField];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake([UIScreen mainScreen].bounds.size.width/2-50, 280, 100, 30);
    [button setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [button setTitle:@"传到B" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
    
    
}

- (void)buttonAction:(UIButton *)sender {

    
    // 单例 传值 A传到B （可以双向传值）
    DanLi *danli = [[DanLi alloc] init];
    danli.value = aTextField.text;
 
    B_ViewController *bViewController = [[B_ViewController alloc] init];

    [self.navigationController pushViewController:bViewController animated:YES];
    
    
}


@end
