//
//  LeftView.m
//  UISegmentDemo
//
//  Created by 许艳豪 on 15/11/18.
//  Copyright © 2015年 ideal_Mac. All rights reserved.
//

#import "LeftView.h"

@interface LeftView ()

@end

@implementation LeftView

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor clearColor];
    UILabel *la = [[UILabel alloc] initWithFrame:CGRectMake(70, 200, 150, 70)];
    la.text = @"hello,world!";
    la.textColor = [UIColor redColor];
    [self.view addSubview:la];
    
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
