//
//  CustomPopVIewController.m
//  customPopViewWithAlertViewController
//
//  Created by primb_xuyanhao on 2018/8/14.
//  Copyright © 2018年 Primb. All rights reserved.
//

#import "CustomPopVIewController.h"

@interface CustomPopVIewController ()
//用于覆盖原有的样式
@property (nonatomic, strong) UIView *customView;
//一个用于取消的按钮
@property (nonatomic, strong) UIButton *button;

@end

@implementation CustomPopVIewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    //在viewDidLoad里面有加载的self.view的bounds是屏幕的大小，
    //所以要在他即将显示的时候去加载控件，如果想在viewDidLoad中加载，就必须拿到一个准确的size，这里建议使用mesonry，或者autolayout去布局。
    [self commonInit];
}
- (void)commonInit {
    //如果自定义需要更大的现实面积，可以使用属性，是否裁剪超出super view的部分
    self.view.clipsToBounds = NO;
    
    //用于覆盖原有的样式
    self.customView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 300, 300)];
    self.customView.backgroundColor = [UIColor redColor];
    self.customView.center = self.view.center;
    [self.view addSubview:self.customView];
    
    //用于出发隐藏的按钮
    self.button = [UIButton buttonWithType:UIButtonTypeCustom];
    self.button.frame = CGRectMake(0, 0, 120, 30);
    self.button.center = self.customView.center;
    self.button.layer.cornerRadius = 5.f;
    [self.button setBackgroundColor:[UIColor blueColor]];
    [self.button setTitle:@"点击我就消失了" forState:UIControlStateNormal];
    [self.button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.customView addSubview:self.button];
    
}
#pragma mark - Action

- (void)buttonAction:(UIButton *)button {
    
    if (self.dismissBlock) {
        _dismissBlock(button);
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

#pragma mark - Public

+ (UIAlertController *)initCustomerAlertViewController{
    
    //创建一个你自定义的alert，设置弹出的类型 \n 可以控制alertController的大小，最多是5行
    CustomPopVIewController *alertController = [CustomPopVIewController alertControllerWithTitle:nil message:@"\n\n\n\n\n\n\n" preferredStyle:UIAlertControllerStyleAlert];
    
    //必须加入一个alertAction，否则系统提示你，alertControllrt要有一个一个action
    UIAlertAction *action = [UIAlertAction actionWithTitle:@" " style:UIAlertActionStyleDefault handler:nil];
    
    [alertController addAction:action];
    
    //弹出alertView
//    [superController presentViewController:alertController animated:YES completion:nil];
    
    return alertController;
}
- (void)showCustomerAlertWithSuperController:(UIViewController *)superController ActionBlock:(CustomAlertDismissBlock)customBlock{
    self.dismissBlock = customBlock;
    [self presentViewController:superController animated:YES completion:nil];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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
