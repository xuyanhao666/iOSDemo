//
//  BlockViewController.m
//  blockDemo
//
//  Created by 许艳豪 on 16/1/11.
//  Copyright © 2016年 ideal_Mac. All rights reserved.
//

#import "BlockViewController.h"

@interface BlockViewController ()
@property (nonatomic, strong) UITextField *textFiled;
@end

@implementation BlockViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    _textFiled = [[UITextField alloc] init];
    _textFiled.backgroundColor = [UIColor greenColor];
    _textFiled.placeholder = @"sshuru";
    _textFiled.frame = CGRectMake(100, 100, 300, 44);
    [self.view addSubview:_textFiled];
}

//- (void)ReturnText:(ReturnTextBlcok)blcok{
//    self.returnTextBlcok = blcok;
//}
- (void)viewWillDisappear:(BOOL)animated {
    
    if (self.returnTextBlcok != nil) {
        self.returnTextBlcok(self.textFiled.text);
    }
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
