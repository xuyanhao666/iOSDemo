//
//  ViewController.m
//  scrollPage
//
//  Created by szyl on 16/8/1.
//  Copyright © 2016年 xyh. All rights reserved.
//

#import "ViewController.h"
#import "HalfPageScrollVIew.h"

#define WIDTH self.view.frame.size.width

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    UIImageView *imgView = [[UIImageView alloc] init];
    imgView.backgroundColor = [UIColor blueColor];

    
    HalfPageScrollVIew *half = [[HalfPageScrollVIew alloc] initWithFrame:CGRectMake(0, 100, WIDTH, 200)];
    half.backgroundColor = [UIColor greenColor];
    
    [self.view addSubview:half];
    

    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
