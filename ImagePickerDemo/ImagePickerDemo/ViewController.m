//
//  ViewController.m
//  ImagePickerDemo
//
//  Created by 许艳豪 on 16/3/8.
//  Copyright © 2016年 ideal_Mac. All rights reserved.
//

#import "ViewController.h"
#import "SZAddImage.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    SZAddImage *view = [[SZAddImage alloc]init];
    view.frame = CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height);
    [self.view addSubview:view];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
