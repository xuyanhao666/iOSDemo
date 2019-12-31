//
//  ViewController.m
//  HttpRequestDemo
//
//  Created by szyl on 16/6/2.
//  Copyright © 2016年 xyh. All rights reserved.
//

#import "ViewController.h"
#import "ActivityModel.h"
#import "ActivityCell.h"
#import "MJRefresh.h"
#import "PopoverView.h"
#import "CZTabBarView.h"
@interface ViewController ()<UITableViewDelegate,UITableViewDataSource,CZTabBarViewDelegate>
@property (nonatomic, strong) UITableView * mainTableView;
@property (nonatomic, strong) NSMutableArray * actModelArr;
@property (nonatomic, strong) PopoverView * popoverView;
@property (strong, nonatomic) UIView * topView;
@property (strong, nonatomic) CZTabBarView * tabBarView;

@end
static NSString *cellIdentifier = @"ActivityCell";
@implementation ViewController
//- (UITableView *)mainTableView{
//    if (!_mainTableView) {
//        _mainTableView = [[UITableView alloc] initWithFrame:[UIScreen mainScreen].bounds style:UITableViewStylePlain];
//    }
//    return _mainTableView;
//}
- (NSMutableArray *)actModelArr{
    if (!_actModelArr) {
        _actModelArr = [NSMutableArray array];
    }
    return _actModelArr;
}
-(CZTabBarView*)tabBarView
{
    if (!_tabBarView) {
        UIImage* img1 = [UIImage imageNamed:@"long"];
        UIImageView *imv1 = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, img1.size.width, img1.size.height)];
        imv1.image = img1;
        _tabBarView = [[CZTabBarView alloc]initWithFrame:CGRectMake(30, 0, ScreenWidth-60, 40) Title:@[@"新闻",@"要闻",@"BBS",] SelectImageView:imv1];
        _tabBarView.delegate = self;
    }
    return _tabBarView;
}
- (BOOL)czTabBarViewShouldSelectInRow:(NSInteger)row{
    return YES;
}
- (void)czTabBarViewDidSelectInRow:(NSInteger)row{
    if (self.mainTableView.header.isRefreshing) {
        [self.mainTableView.header endRefreshing];
    }
    if (self.mainTableView.footer.isRefreshing) {
        [self.mainTableView.footer endRefreshing];
    }
//    NSInteger selectIndex = row;
//    if (row == 0) {
//        self.navigationItem.rightBarButtonItem = nil;
//        [self.mainTableView reloadData];
//    }else if (row == 1){
//        self.navigationItem.rightBarButtonItem = nil;
//        [self.mainTableView reloadData];
//    }else if (row == 2){
////        self.navigationItem.rightBarButtonItem = rightItem;
//        [self.mainTableView reloadData];
//    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the vis
    self.navigationController.navigationBar.translucent = NO;
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSearch target:self action:@selector(BeAPopView:)];
    self.navigationItem.rightBarButtonItem = rightItem;
    _mainTableView = [[UITableView alloc] initWithFrame:[UIScreen mainScreen].bounds style:UITableViewStylePlain];
//    _mainTableView.backgroundColor = [UIColor grayColor];
    _mainTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.mainTableView.delegate = self;
    self.mainTableView.dataSource = self;
    self.mainTableView.tableFooterView = [UIView new];
    self.mainTableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 15);
    //1.xib 第一种方法 注册
    [self.mainTableView registerNib:[UINib nibWithNibName:cellIdentifier bundle:nil] forCellReuseIdentifier:cellIdentifier];
    [self.view addSubview:self.mainTableView];
    
    self.mainTableView.header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(myTempRequest)];
    self.mainTableView.footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(myTempRequest)];
    
    [self myTempRequest];
    
    self.topView = [UIView new];
    self.topView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self.view addSubview:self.topView];
    [self.topView addSubview:self.tabBarView];
    WS(ws);
    [self.topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(ws.view.mas_top).offset(0.0);
        make.left.right.mas_equalTo(ws.view);
        make.height.mas_equalTo(@40);
    }];
    [self.mainTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(ws.topView.mas_bottom);
        make.left.bottom.right.mas_equalTo(ws.view);
    }];
}
- (void)BeAPopView:(UIBarButtonItem *)sender{
    WS(ws);
    CGPoint point = CGPointMake(ScreenWidth - 25, 60);
    _popoverView = [[PopoverView alloc] initWithPoint:point titles:@[@"1",@"2",@"2",@"2",@"2"] images:@[@"1",@"2",@"2",@"2",@"2"]];
    _popoverView.layer.cornerRadius = 5.0;
    _popoverView.selectRowAtIndex = ^(NSInteger index){
        NSLog(@"%ld",(long)index);
    };
    [_popoverView show];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    ActivityCell *cell = [self.mainTableView dequeueReusableCellWithIdentifier:cellIdentifier];
//    if (cell == nil) {
//        cell = [ActivityCell loadFromXib];
//    }
    [cell initWithMoel:_actModelArr[indexPath.row]];
    CGRect screenBounds = [UIScreen mainScreen].bounds;
    cell.actWidthConstraint.constant = screenBounds.size.width - 130;
    CGSize size = [cell.contentView systemLayoutSizeFittingSize:UILayoutFittingExpandedSize];
    return size.height+10 > 180 ? (size.height+10) : 180;

}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSLog(@"actModelArr=========%ld",_actModelArr.count);
    return _actModelArr.count;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    ActivityCell *tempCell = [self.mainTableView dequeueReusableCellWithIdentifier:cellIdentifier];
//    if (tempCell == nil) {
//        tempCell = [ActivityCell loadFromXib];
//    }
    [tempCell initWithMoel:_actModelArr[indexPath.row]];
    CGRect screenBounds = [UIScreen mainScreen].bounds;
    tempCell.actWidthConstraint.constant = screenBounds.size.width - 130;
    return tempCell;
}
- (void)myTempRequest{
    NSDictionary *params = @{@"employeeId":@"3192c404-6019-11e4-907f-00163e0046c2",
                             @"custId":@"27f78b23-d582-11e3-b336-d4ae528c1f4c",
                             @"firstIndex":@"0",
                             @"type":@"0"};
    [SVProgressHUD showWithStatus:@"加载中......"];
    [[MyHttpRequest shareInstance] PostType:@"2013" Parameters:params Success:^(id result) {
        [self stopRefreshData];
        [SVProgressHUD dismiss];
        NSArray *temArr = [result objectForKey:@"activitys"];
        self.actModelArr = [ActivityModel initWithArray:temArr];
        [_mainTableView reloadData];
        if (self.actModelArr.count == 0) {
            [SVProgressHUD showInfoWithStatus:@"暂无信息"];
            //            SCLAlertView* alert = [[SCLAlertView alloc]initWithNewWindow];
            //            [alert showNotice:nil subTitle:@"请检查您的网络" closeButtonTitle:nil duration:2];
        }

    } Failed:^(NSError *error) {
        [self stopRefreshData];
        [SVProgressHUD dismiss];
    }];

}
- (void)stopRefreshData{
    if (self.mainTableView.header.isRefreshing) {
        [self.mainTableView.header endRefreshing];
    }
    if (self.mainTableView.footer.isRefreshing) {
        [self.mainTableView.footer endRefreshing];
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
