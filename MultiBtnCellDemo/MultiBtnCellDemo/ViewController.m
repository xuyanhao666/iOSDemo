//
//  ViewController.m
//  MultiBtnCellDemo
//
//  Created by szyl on 16/6/16.
//  Copyright © 2016年 xyh. All rights reserved.
//

#import "ViewController.h"
#import "pushViewController.h"
@interface ViewController ()

@end

@implementation ViewController
- (IBAction)yellowPush:(id)sender {
    pushViewController *pushVC = [[pushViewController alloc] init];
    pushVC.editAction = EditYellow;
    [self.navigationController pushViewController:pushVC animated:YES];
}
- (IBAction)greenPush:(id)sender {
    pushViewController *pushVC = [[pushViewController alloc] init];
    pushVC.editAction = EditGreen;
    [self.navigationController pushViewController:pushVC animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
