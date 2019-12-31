//
//  BaseTabBarViewController.m
//  AccountManagerOC
//
//  Created by primb on 16/8/10.
//  Copyright © 2016年 primb. All rights reserved.
//

#import "BaseTabBarViewController.h"
#import "BaseNavigationViewController.h"
#import "SettingViewController.h"
#import "MyTableViewController.h"
@interface BaseTabBarViewController ()

@end

@implementation BaseTabBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    [UITabBar appearance].tintColor =UIColorFromRGB(0x1bb8fa);
    [UITabBar appearance].barTintColor = [UIColor whiteColor];
//    [UINavigationBar appearance].tintColor = [UIColor whiteColor];
    self.hidesBottomBarWhenPushed = YES;
//    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    [self addChildViewControllers];
}
-(void)addChildViewControllers{
//    HomeViewController *homeVC = [[HomeViewController alloc] init];
//    [self addChildViewController:homeVC WithTitle:@"首页" image:@"tab_home" selectedImage:@"tab_home_selected"];
//    IndexViewController *indexVC = [[IndexViewController alloc] init];
//    [self addChildViewController:indexVC WithTitle:@"指标" image:@"tab_index" selectedImage:@"tab_approval_selected"];
//    BenchmarkingViewController *benchmarkingVC = [[BenchmarkingViewController alloc] init];
//    [self addChildViewController:benchmarkingVC WithTitle:@"对标" image:@"tab_duibiao" selectedImage:@"tab_duibiao_selected"];
//    PriceViewController *priceVC = [[PriceViewController alloc] init];
//    [self addChildViewController:priceVC WithTitle:@"价格" image:@"tab_price" selectedImage:@"tab_price_selected"];
//    DepositViewController *depositVC = [[DepositViewController alloc] init];
//    [self addChildViewController:depositVC WithTitle:@"存款" image:@"tab_price" selectedImage:@"tab_search_selected"];
    MyTableViewController *tan = [[MyTableViewController alloc]init];
    [self addChildViewController:tan WithTitle:@"首页" image:@"tab_home" selectedImage:@"home-selected"];
//    AssessViewController *assVC = [[AssessViewController alloc] init];
//    [self addChildViewController:assVC WithTitle:@"考核" image:@"tab_duibiao" selectedImage:@"tab_tools_selected"];
    SettingViewController *settingVC = [[SettingViewController alloc] init];
    [self addChildViewController:settingVC WithTitle:@"设置" image:@"tab_setting" selectedImage:@"tab_mine_selected"];

}
-(void)addChildViewController:(UIViewController *)childController WithTitle:(NSString *)title image:(NSString *)imageName selectedImage:(NSString *)selectedImageName{
    childController.tabBarItem.image = [[UIImage imageNamed:imageName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    childController.tabBarItem.selectedImage = [[UIImage imageNamed:selectedImageName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    childController.title = title;
//    [childController.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName:UIColorFromRGB(0x7e0e7b)} forState:UIControlStateSelected];

    BaseNavigationViewController *navigation  =[[BaseNavigationViewController alloc] initWithRootViewController:childController];
    [self addChildViewController:navigation];
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
