//
//  ViewController.m
//  pengyouquan
//
//  Created by 青创汇 on 16/1/8.
//  Copyright © 2016年 青创汇. All rights reserved.
//

#import "ViewController.h"
#import "MyTableViewController.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.title = @"期货交流圈";
    self.navigationController.navigationBar.translucent = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(100, 200, 100, 50);
    button.backgroundColor = [UIColor blueColor];
    [button setTitle:@"朋友圈" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(tiaozhuan) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
}
-(void)tiaozhuan
{
    NSLog(@"%@",@"taio");
    MyTableViewController *tan = [[MyTableViewController alloc]init];
    [self.navigationController pushViewController:tan animated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
