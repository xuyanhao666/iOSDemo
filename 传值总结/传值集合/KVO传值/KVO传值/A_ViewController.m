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
    B_ViewController *bViewController;
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
    
    /**
     KVO 创建 三步一定要写
        1. 注册观察者
        2. KVO的回调
        3. 移除观察者
     
     */
    
    // B 传到 A （这里只能用回传了  因为B已经在A页面中提前初始化）
    //注册观察者:如果用了KVO一定要把bViewController的初始化放在上面的viewDidLoad里
     bViewController = [[B_ViewController alloc] init];
    [bViewController addObserver:self forKeyPath:@"string" options:NSKeyValueObservingOptionNew context:nil];
}

- (void)buttonAction:(UIButton *)sender {
    
    [self.navigationController pushViewController:bViewController animated:YES];
    
    
}


// KVO的回调
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    
    if ([keyPath isEqualToString:@"string"]) {
        aTextField.text = bViewController.string;
    }
    
}
// KVO 的移除方式  （和通知一样要移除）
- (void)dealloc {
   // [[NSNotificationCenter defaultCenter] removeObserver:self name:@"amessage" object:nil];   //移除通知监听者
    [bViewController removeObserver:self forKeyPath:@"string"];
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
