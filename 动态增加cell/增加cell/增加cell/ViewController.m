//
//  ViewController.m
//  增加cell
//
//  Created by 青创汇 on 16/3/17.
//  Copyright © 2016年 青创汇. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    NSInteger RowCount;
}
@property (nonatomic, strong)UITableView *hambitustableview;
@end
#define SCREEN_WIDTH        [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT       [UIScreen mainScreen].bounds.size.height


@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    RowCount=1;
    self.view.backgroundColor = [UIColor lightGrayColor];
    self.hambitustableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 100, SCREEN_WIDTH, SCREEN_HEIGHT-164) style:UITableViewStylePlain];
    self.hambitustableview.delegate = self;
    self.hambitustableview.dataSource = self;
    [self.hambitustableview setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    self.hambitustableview.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.hambitustableview];
    
//    UIView *headView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 30)];
//        headView.backgroundColor=[UIColor lightGrayColor];
//        UIButton *addbtn = [UIButton buttonWithType:UIButtonTypeCustom];
//        addbtn.frame = CGRectMake(10, 10, 100, 20);
//        addbtn.layer.borderWidth = 1;
//        [addbtn setTitle:@"增加cell" forState:UIControlStateNormal];
//        [addbtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//        [addbtn addTarget:self action:@selector(addcell:) forControlEvents:UIControlEventTouchUpInside];
//        [headView addSubview:addbtn];
//    self.hambitustableview.tableFooterView = headView;
    // Do any additional setup after loading the view, typically from a nib.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return RowCount;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
     NSString *const TableViewCellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:TableViewCellIdentifier];
    if (cell==nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:TableViewCellIdentifier];
    }
    cell.textLabel.text = [NSString stringWithFormat:@"我是cell%ld",indexPath.row];
    cell.backgroundColor = [UIColor redColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"%ld",(long)indexPath.row);
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *headView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 30)];
    headView.backgroundColor=[UIColor lightGrayColor];
    UIButton *addbtn = [UIButton buttonWithType:UIButtonTypeCustom];
    addbtn.frame = CGRectMake(10, 10, 100, 20);
    addbtn.layer.borderWidth = 1;
    [addbtn setTitle:@"增加cell" forState:UIControlStateNormal];
    [addbtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [addbtn addTarget:self action:@selector(addcell:) forControlEvents:UIControlEventTouchUpInside];
    [headView addSubview:addbtn];
    return headView;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 50;
}
- (void)addcell:(UIButton *)sender
{
    RowCount +=1;
    NSIndexSet * nd=[[NSIndexSet alloc]initWithIndex:0];
    [self.hambitustableview reloadSections:nd withRowAnimation:UITableViewRowAnimationAutomatic];
//    [self.hambitustableview reloadData];
}

@end
