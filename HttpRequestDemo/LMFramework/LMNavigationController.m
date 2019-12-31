//
//  LMNavigationController.m
//  PlanApp
//
//  Created by zero on 15/7/22.
//  Copyright (c) 2015年 zero. All rights reserved.
//

#import "LMNavigationController.h"
#import "HeaderHelper.h"
@interface LMNavigationController ()

@end

@implementation LMNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[UINavigationBar appearance] setTintColor:[SkinThemeManager shareInstance].navigationTitleColor];
    [[UINavigationBar appearance]setTranslucent:NO];
    [[UINavigationBar appearance]setBarTintColor:[SkinThemeManager shareInstance].navigationBarColor];
    [[UINavigationBar appearance]setTitleTextAttributes:@{NSForegroundColorAttributeName:[SkinThemeManager shareInstance].navigationTitleColor}];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)popBack{
    [self popViewControllerAnimated:YES];
}
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated{
    [viewController.navigationItem setLeftBarButtonItem:[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back"] style:UIBarButtonItemStylePlain target:self action:@selector(popBack)]];
    viewController.view.backgroundColor = [SkinThemeManager shareInstance].viewDefaultBgColor;
    [super pushViewController:viewController animated:animated];
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
