//
//  ViewController.m
//  addressBookDemo
//
//  Created by 许艳豪 on 16/3/16.
//  Copyright © 2016年 ideal_Mac. All rights reserved.
//

#import "ViewController.h"
#import "ZCAddressBook.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn addTarget:self action:@selector(hha) forControlEvents:UIControlEventTouchUpInside];
    btn.frame = CGRectMake(100, 100, 200, 200);
    btn.backgroundColor = [UIColor redColor];
    [self.view addSubview:btn];
}
- (void)hha{
    //调用系统控件，选中后获得指定人信息
    [[ZCAddressBook alloc]initWithTarget:self PhoneView:^(BOOL isSucceed, NSDictionary *dic) {
        NSLog(@"从系统中获得指定联系人的信息%@",dic);
    }];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
