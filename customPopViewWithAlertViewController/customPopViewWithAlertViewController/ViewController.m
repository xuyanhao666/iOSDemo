//
//  ViewController.m
//  customPopViewWithAlertViewController
//
//  Created by primb_xuyanhao on 2018/8/14.
//  Copyright © 2018年 Primb. All rights reserved.
//

#import "ViewController.h"
#import "CustomPopVIewController.h"
@interface ViewController ()
@property (nonatomic, strong) UIButton *button;
@property (nonatomic, strong) UIButton *cancleButton;
@property (nonatomic ,strong) UIAlertController *datePickerView;
@property (nonatomic, strong) UITextField *currentField;
@end

@implementation ViewController
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    //在viewDidLoad里面有加载的self.view的bounds是屏幕的大小，
    //所以要在他即将显示的时候去加载控件，如果想在viewDidLoad中加载，就必须拿到一个准确的size，这里建议使用mesonry，或者autolayout去布局。
    [self commonInit];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
- (void)commonInit {

    self.button = [UIButton buttonWithType:UIButtonTypeCustom];
    self.button.frame = CGRectMake(0, 0, 120, 30);
    self.button.center = self.view.center;
    self.button.layer.cornerRadius = 5.f;
    [self.button setBackgroundColor:[UIColor greenColor]];
    [self.button setTitle:@"come on !!!" forState:UIControlStateNormal];
    [self.button addTarget:self action:@selector(buttonAction1:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.button];
    
}
- (void)buttonAction:(UIButton *)button {
    
    _datePickerView = [UIAlertController alertControllerWithTitle:@"  " message:@"\n\n\n\n\n" preferredStyle:UIAlertControllerStyleAlert];
    _datePickerView.view.backgroundColor = [UIColor clearColor];
//    _datePickerView.view.clipsToBounds = NO;
    [_datePickerView addAction:[UIAlertAction actionWithTitle:@"  " style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
    }]];
    [_datePickerView addAction:[UIAlertAction actionWithTitle:@"  " style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }]];
    [self presentViewController:_datePickerView animated:YES completion:nil];
    
    UIView *cview = [[UIView alloc] initWithFrame:CGRectMake(0, -100, 270, 400)];
    cview.backgroundColor = [UIColor whiteColor];
    [_datePickerView.view addSubview:cview];
    
    self.cancleButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.cancleButton.frame = CGRectMake(0, 0, 120, 30);
    self.cancleButton.center = cview.center;
    self.cancleButton.layer.cornerRadius = 5.f;
    [self.cancleButton setBackgroundColor:[UIColor blueColor]];
    [self.cancleButton setTitle:@"cancle!!!" forState:UIControlStateNormal];
    [self.cancleButton addTarget:self action:@selector(cancleButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [cview addSubview:self.cancleButton];
}
- (void)cancleButtonAction:(UIButton *)button{
    [_datePickerView dismissViewControllerAnimated:YES completion:nil];
}
- (void)buttonAction1:(UIButton *)button{
    self.currentField = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"测试" message:@"测试输入框边框颜色" preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        self.currentField = textField;
    }];
    [self presentViewController:alert animated:NO completion:^{
        [[self.currentField superview] superview].backgroundColor = [UIColor redColor];
        [self shakeField:self.currentField];
    }];
}
- (void)shakeField:(UITextField *)textField {
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"position"];
    animation.duration = 0.07;
    animation.repeatCount = 4;
    animation.autoreverses = YES;
    animation.fromValue = [NSValue valueWithCGPoint:CGPointMake(textField.center.x - 10, textField.center.y)];
    animation.toValue = [NSValue valueWithCGPoint:CGPointMake(textField.center.x + 10, textField.center.y)];
    [textField.layer addAnimation:animation forKey:@"position"];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
