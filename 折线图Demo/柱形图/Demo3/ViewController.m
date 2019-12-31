//
//  ViewController.m
//  Demo3
//
//  Created by 少年 on 14/11/4.
//  Copyright (c) 2014年 少年. All rights reserved.
//

#import "ViewController.h"
#import "CZPillarView.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view .backgroundColor = [UIColor lightGrayColor];
    // Do any additional setup after loading the view, typically from a nib.
    NSArray* arr = @[@"本公司1",@"本公司2",@"本公司3",@"本公司4",@"本公司5",@"本公司6",@"本公司7",@"本公司8"];
    NSArray* arr1 = @[@"11",@"33",@"55",@"77",@"99"];
    NSArray* arr2 = @[@"11",@"22",@"33",@"44",@"55",@"66",@"77",@"88"];
    CZPillarView* view = [[CZPillarView alloc]initWithFrame:CGRectMake(20, 50, 280, 280)];
    view.titleForXArray = arr;
//    view.titleForYArray = arr1;
    view.valueArray = arr2;
    view.numberOfY = 5;
    view.minY = 0;
    view.maxY = 99;
    view.pillarColor = [UIColor yellowColor];
    [view reloadData];
    [self.view addSubview:view];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
