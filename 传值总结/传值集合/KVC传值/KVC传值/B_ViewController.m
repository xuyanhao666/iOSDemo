//
//  B_ViewController.m
//  属性传值
//
//  Created by zyx on 16/3/18.
//  Copyright © 2016年 zyx. All rights reserved.
//

#import "B_ViewController.h"

@interface B_ViewController ()

@end

@implementation B_ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"B";
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.view.backgroundColor = [UIColor whiteColor];
    UITextField *bTextField = [[UITextField alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width/2-50, 200, 100, 30)];
    
    bTextField.layer.borderColor = [UIColor grayColor].CGColor;
    bTextField.layer.borderWidth = 1;
    [self.view addSubview:bTextField];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake([UIScreen mainScreen].bounds.size.width/2-50, 280, 100, 30);
    [button setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [button setTitle:@"传值A" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
    
    // KVC 接收值
    bTextField.text = self.string;

    
}

- (void)buttonAction:(UIButton *)sender {
    
    
    [self.navigationController popToRootViewControllerAnimated:YES];
      
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
