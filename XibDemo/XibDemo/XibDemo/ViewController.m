//
//  ViewController.m
//  XibDemo
//
//  Created by wanghp on 16/5/18.
//  Copyright © 2016年 wanghp. All rights reserved.
//

#import "ViewController.h"
#import "TableViewFooterView.h"
#import "TableViewCell.h"

@interface ViewController ()
{
    TableViewFooterView *_m_footerView;
    //2.第二种方法 loadxib
    TableViewCell *_m_cell;
}
@property (strong, readwrite, nonatomic) UITableView *tableView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView = ({
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStylePlain];
        
        tableView.delegate = self;
        tableView.dataSource = self;
        //tableView.opaque = NO;//不透明视图
        tableView.backgroundColor = [UIColor grayColor];
        //        tableView.backgroundView = nil;
        tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        //        tableView.bounces = NO;//禁止拖动
        //        tableView.scrollsToTop = YES;//返回顶部
        tableView;
    });
    
    [self.view addSubview:self.tableView];
    
    //1.xib 第一种方法 注册
   // [self.tableView registerNib:[UINib nibWithNibName:@"TableViewCell" bundle:nil] forCellReuseIdentifier:@"TableViewCell"];
    
    
    _m_footerView = [TableViewFooterView loadFromXib];
    _m_footerView.m_insetCellBtn.tag = 1;
    _m_footerView.m_deleCellBtn.tag = 2;
    [_m_footerView.m_insetCellBtn addTarget:self action:@selector(insertOrDelItem:) forControlEvents:(UIControlEventTouchUpInside)];
    [_m_footerView.m_deleCellBtn addTarget:self action:@selector(insertOrDelItem:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.tableView setTableFooterView:_m_footerView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark UITableView Datasource

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)sectionIndex
{
    return 10;
}
//section的高度

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.1;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    return nil;
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString * CellIdentifier = @"TableViewCell";
    TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    //1.xib 第一种方法 注册后直接不用判断cell == nil
    //return cell;
    
    //2.第二种方法 loadxib
    if (cell == nil) {
        cell = [TableViewCell loadFromXib];
        
    }
    return cell;
}
@end
