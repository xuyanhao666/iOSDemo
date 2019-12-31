//
//  A_ViewController.m
//  属性传值
//
//  Created by zyx on 16/3/18.
//  Copyright © 2016年 zyx. All rights reserved.
//

#import "A_ViewController.h"
#import "B_ViewController.h"


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

    
 
    B_ViewController *bViewController = [[B_ViewController alloc] init];

    /**
        KVC 传值：这里只能传A传到B （因为 B在A页面提前初始化）
        B 有个属性 string
        用B对象 给B属性赋值（回顾下OC中KVC赋值 就理解了）
     
     这里forkey 一定要和B 属性名字一致 （也可以用@"_string"）因为是属性
     
     */
    
    // 给B属性string  赋值
    [bViewController setValue:aTextField.text forKey:@"string"];
    
    [self.navigationController pushViewController:bViewController animated:YES];
    
    
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
