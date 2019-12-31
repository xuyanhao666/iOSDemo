//
//  firstViewController.m
//  xibDemo
//
//  Created by szyl on 16/5/18.
//  Copyright © 2016年 szyl. All rights reserved.
//

#import "firstViewController.h"
#import "secViewController.h"

#define ScreenWidth [UIScreen mainScreen].bounds.size.width
@interface firstViewController ()

@end

@implementation firstViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
//    UIButton *myBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.view.bounds.size.width-200, 64, 100, 44)];
    UIButton *myBtn = [[UIButton alloc] initWithFrame:CGRectMake(ScreenWidth-100, 64, 100, 44)];
    myBtn.backgroundColor = [UIColor greenColor];
    [myBtn setTitle:@"跳转" forState:UIControlStateNormal];
    [myBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    myBtn.tintColor = [UIColor yellowColor];
    [myBtn addTarget:self action:@selector(haha) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:myBtn];
}

- (void)haha{
    secViewController *secVC = [[secViewController alloc] init];
    [self.navigationController pushViewController:secVC animated:YES];
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
