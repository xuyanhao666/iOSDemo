//
//  ViewController.m
//  blockDemo
//
//  Created by 许艳豪 on 16/1/11.
//  Copyright © 2016年 ideal_Mac. All rights reserved.
//

#import "ViewController.h"
#import "BlockViewController.h"
@interface ViewController ()
@property (nonatomic, strong) BlockViewController *blcokVC;
@property (weak, nonatomic) IBOutlet UILabel *showLabel;
@end

@implementation ViewController

- (BlockViewController *)blcokVC{
    if (!_blcokVC) {
        _blcokVC = [[BlockViewController alloc] init];
    }
    return _blcokVC;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    UIButton *butto1 = [UIButton buttonWithType:UIButtonTypeCustom];
    butto1.backgroundColor = [UIColor grayColor];
    butto1.frame = CGRectMake(100, 100, 120, 33);
    [butto1 addTarget:self action:@selector(hahhaha) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:butto1];
}
- (void)hahhaha{
//    NSMutableArray *muArr = [NSMutableArray array];
//    [muArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//        <#code#>
//    }]


}
- (IBAction)showTime:(id)sender {
//   BlockViewController *blcokVC = [[BlockViewController alloc] init];
    
//    __weak ViewController *ws = self;
    __weak typeof(self) weakSelf = self;
//    self.blcokVC.returnTextBlcok = ^(NSString *showText) {
//        weakSelf.showLabel.text = showText;
//    };
    
    self.blcokVC.returnTextBlcok = ^(NSString *str) {
        weakSelf.showLabel.text = str;
    };

    
    [self.navigationController pushViewController:self.blcokVC animated:YES];
}

//-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
