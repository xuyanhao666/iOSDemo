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
    
    
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake([UIScreen mainScreen].bounds.size.width/2-50, 280, 100, 30);
    [button setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [button setTitle:@"传值A" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    

    NSLog(@"Bb");

    

}


//如果是从A传到B的话,B.m里要创建一个init方法,在里面写监听并在里面创建接收容器才能成功(因为程序先执行init方法再到viewDidLoad方法,当传值过去时在init就开始监听,如果这里没有创建textField接收,那就传不过去了,所以要在init里同时创建接收器(生命周期的问题));


-(instancetype)init
{
    if (self = [super init]) {
        
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tzAction:) name:@"tz" object:nil];
        
        bTextField = [[UITextField alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width/2-50, 200, 100, 30)];
        
        bTextField.layer.borderColor = [UIColor grayColor].CGColor;
        bTextField.layer.borderWidth = 1;
        [self.view addSubview:bTextField];

    }

    
    return self;
}


- (void)tzAction:(NSNotification *)sender {
    NSLog(@"aaa");
    bTextField.text = sender.userInfo[@"key"];
    
}

// 移除通知
- (void)dealloc  {
    
    // 移除所有
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    // 移除某个
    // [[NSNotificationCenter defaultCenter] removeObserver:self name:@"tz" object:nil];
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
