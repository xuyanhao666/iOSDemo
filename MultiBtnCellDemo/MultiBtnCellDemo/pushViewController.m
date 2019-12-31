//
//  pushViewController.m
//  MultiBtnCellDemo
//
//  Created by szyl on 16/6/16.
//  Copyright © 2016年 xyh. All rights reserved.
//

#import "pushViewController.h"
#import "MyTableViewCell.h"

#define ScreenWidth [UIScreen mainScreen].bounds.size.width
#define screenHight [UIScreen mainScreen].bounds.size.height

@interface pushViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView * myTableView;
@end

@implementation pushViewController
- (UITableView *)myTableView{
    if (!_myTableView) {
        _myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, screenHight) style:UITableViewStyleGrouped];
        _myTableView.delegate = self;
        _myTableView.dataSource = self;
        _myTableView.tableFooterView = [UIView new];
        [self.view addSubview:_myTableView];
    }
    return _myTableView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationController.navigationBar.translucent = NO;
    [self colorJudge];
    
//    [self.myTableView registerClass:[UITableView class] forCellReuseIdentifier:@"MyTableViewCell"];
    [self.myTableView registerNib:[UINib nibWithNibName:@"MyTableViewCell" bundle:nil] forCellReuseIdentifier:@"MyTableViewCell"];
    self.myTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 7;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 64;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}
-(void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath
{
    //    需要的移动行
    NSInteger fromRow = [sourceIndexPath row];
    //    获取移动某处的位置
    NSInteger toRow = [destinationIndexPath row];
    NSLog(@"第%ld行移动到第%ld行",fromRow,toRow);
    //    从数组中读取需要移动行的数据
//    id object = [self.listData objectAtIndex:fromRow];
//    //    在数组中移动需要移动的行的数据
//    [self.listData removeObjectAtIndex:fromRow];
//    //    把需要移动的单元格数据在数组中，移动到想要移动的数据前面
//    [self.listData insertObject:object atIndex:toRow];
}
//单元格返回的编辑风格，包括删除 添加 和 默认  和不可编辑三种风格
-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleInsert | UITableViewCellEditingStyleDelete | UITableViewCellEditingStyleNone;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MyTableViewCell"];
    //    if (cell== nil) {
    //        cell = [MyTableViewCell loadFromXib];
    //    }
    cell.firstPress.tag = indexPath.row+1000;
    cell.secPress.tag = indexPath.row +2000;
    [cell.firstPress addTarget:self action:@selector(firstPress:) forControlEvents:UIControlEventTouchUpInside];
    [cell.secPress addTarget:self action:@selector(secPress:) forControlEvents:UIControlEventTouchUpInside];
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    MyTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (cell.accessoryType == UITableViewCellAccessoryNone) {
        cell.accessoryType=UITableViewCellAccessoryCheckmark;
    }else {
        cell.accessoryType = UITableViewCellAccessoryNone;
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
}
- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath NS_AVAILABLE_IOS(3_0){
    MyTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (cell.accessoryType == UITableViewCellAccessoryCheckmark) {
        cell.accessoryType=UITableViewCellAccessoryNone;
    }else {
        cell.accessoryType = UITableViewCellAccessoryNone;
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
}
- (void)firstPress:(UIButton *)sender{
    NSLog(@"firstBtn===%ld",sender.tag-1000);
}
- (void)secPress:(UIButton *)sender{
    NSLog(@"secBtn====%ld",sender.tag-2000);
}
- (void)colorJudge{
    if (self.editAction == EditYellow) {
        self.myTableView.backgroundColor = [UIColor yellowColor];
    }else if (self.editAction == EditGreen){
        self.myTableView.backgroundColor = [UIColor greenColor];
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
