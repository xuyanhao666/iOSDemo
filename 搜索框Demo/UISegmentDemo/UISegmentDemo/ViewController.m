//
//  ViewController.m
//  UISegmentDemo
//
//  Created by 许艳豪 on 15/11/18.
//  Copyright © 2015年 ideal_Mac. All rights reserved.
//

#import "ViewController.h"
#import "SecondViewController.h"
@interface ViewController ()
@property (nonatomic, strong) SecondViewController *secondVC;
@property (nonatomic, strong) UIView *firstView;
@property (nonatomic, strong) UIView *secondView;
@property (nonatomic, strong) UIButton *btn;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
//    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:20/255.0 green:155/255.0 blue:213/255.0 alpha:1.0]];
//    self.view.backgroundColor = [UIColor whiteColor];
//        [[UINavigationBar appearance]setBarTintColor:[UIColor colorWithRed:20/255.0 green:155/255.0 blue:213/255.0 alpha:1.0]];
//    self.navigationController.navigationBar.backgroundColor =[UIColor colorWithRed:20/255.0 green:155/255.0 blue:213/255.0 alpha:1.0];
    NSArray *arr = [[NSArray alloc] initWithObjects:@"one",@"two", nil];
    UISegmentedControl *yosegment = [[UISegmentedControl alloc] initWithItems:arr];
    yosegment.frame = CGRectMake(120, 300, 100, 30);
    yosegment.tintColor = [UIColor whiteColor];
    yosegment.selectedSegmentIndex = 0;
//    点击后是否还原
//    yosegment.momentary = YES;
    yosegment.layer.cornerRadius = 15;
    yosegment.layer.masksToBounds = YES;
    yosegment.layer.borderWidth = 1;
    yosegment.layer.borderColor = [UIColor whiteColor].CGColor;
    [yosegment addTarget:self action:@selector(clickSegment:) forControlEvents:UIControlEventValueChanged];
    
    self.navigationItem.titleView = yosegment;
//    [self.view addSubview:yosegment];
    _firstView =[[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    _firstView.backgroundColor = [UIColor yellowColor];
    
//    这个自动布局暂时未搞清楚
//    _firstView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    [self.view addSubview:_firstView];
    
    
    _secondView =[[UIView alloc] initWithFrame:CGRectMake(0 + 420, 0, self.view.frame.size.width, self.view.frame.size.height)];
    _secondView.backgroundColor = [UIColor blueColor];

    [self.view addSubview:_secondView];
    
    UISwitch *mySwit = [[UISwitch alloc] initWithFrame:CGRectMake(155, 160, 70, 30)];
    mySwit.tintColor = [UIColor greenColor];
    [self.view addSubview:mySwit];
    
    [mySwit addTarget:self action:@selector(clickSwitch:) forControlEvents:UIControlEventValueChanged];
    
    _btn = [[UIButton alloc] initWithFrame:CGRectMake(100, 200, 170, 44)];
    [_btn setTitle:@"pushView" forState:UIControlStateNormal];
    [_btn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    _btn.layer.cornerRadius = 22;
    _btn.layer.borderColor = [UIColor greenColor].CGColor;
    _btn.layer.borderWidth = 1;
    _btn.layer.masksToBounds = YES;
    [self.view addSubview:_btn];
    [_btn addTarget:self action:@selector(pushView) forControlEvents:UIControlEventTouchUpInside];
    
    _secondVC = [[SecondViewController alloc] init];

    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"左视图"
                                                                             style:UIBarButtonItemStylePlain
                                                                            target:self
                                                                            action:@selector(presentLeftMenuViewController:)];
    
}
- (void)pushView{
    [self.navigationController pushViewController:_secondVC animated:YES];
}
- (void)clickSwitch:(UISwitch *)swit{
    if (swit.isOn) {
        [_btn setTitleColor:[UIColor greenColor] forState:UIControlStateNormal];
    }else{
        [_btn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    }
}
- (void)clickSegment:(UISegmentedControl *)seg  {
    NSInteger index = seg.selectedSegmentIndex;
    switch (index) {
        case 0:
            [self firstSegment];
            break;
        case 1:
            [self secondSegment];
            break;
        default:
            break;
    }
}
- (void)firstSegment
{
    _firstView.frame  = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    _secondView.frame = CGRectMake(0 + 420, 0, self.view.frame.size.width, self.view.frame.size.height);
    
    
    _firstView.hidden  = NO;
    _secondView.hidden = YES;
    
}

- (void)secondSegment
{
    _firstView.frame  = CGRectMake(0 - 420, 0, self.view.frame.size.width, self.view.frame.size.height);
    _secondView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
   
    
    _firstView.hidden  = YES;
    _secondView.hidden = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
