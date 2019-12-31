//
//  SearchResultViewController.m
//  searchControllerDemo
//
//  Created by primb_xuyanhao on 2018/12/28.
//  Copyright © 2018 Primb. All rights reserved.
//

#import "SearchResultViewController.h"
#import "SearchDetailVC.h"
#import "CustomTableViewCell.h"
#import "personModel.h"

@interface SearchResultViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *mainTableView;

@property (strong, nonatomic) NSMutableArray *searchList;//满足搜索条件的数组

@end

@implementation SearchResultViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.dataListArry = [NSMutableArray array];
    self.searchList = [NSMutableArray array];
    
    self.mainTableView.tableFooterView = [UIView new];
    self.automaticallyAdjustsScrollViewInsets = NO;//不加的话，table会下移
    self.edgesForExtendedLayout = UIRectEdgeNone;//不加的话，UISearchBar返回后会上移

}
- (void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
    UIViewController *rootViewController = [[[UIApplication sharedApplication] keyWindow] rootViewController];
    if ([rootViewController isKindOfClass:[UITabBarController class]]) {
        UITabBarController *tabBarController = (UITabBarController *)rootViewController;
        tabBarController.tabBar.hidden = YES;
        tabBarController.edgesForExtendedLayout = UIRectEdgeBottom;
    }
}
- (UITableView *)mainTableView{
    if (!_mainTableView) {
        _mainTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - 64) style:UITableViewStylePlain];
        _mainTableView.delegate = self;
        _mainTableView.dataSource = self;
        _mainTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        _mainTableView.tableFooterView = [UIView new];
        [self.view addSubview:_mainTableView];
    }
    return _mainTableView;
}
#pragma mark - tableView
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self.searchBar resignFirstResponder];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.searchList.count > 0 ? self.searchList.count : 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return self.searchList.count > 0 ? 60 : 200;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.searchList.count > 0) {
        static NSString *identifier = @"cell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
        }
        personModel *model = self.searchList[indexPath.row];
        cell.textLabel.text = model.name;
        cell.detailTextLabel.text = model.age;
        cell.textLabel.textColor = [UIColor redColor];
        cell.detailTextLabel.textColor = [UIColor redColor];
        tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        return cell;
    }else{
        CustomTableViewCell *cell = [[NSBundle mainBundle]loadNibNamed:@"CustomTableViewCell" owner:self options:nil][0];
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        return cell;
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    SearchDetailVC *vc = [[SearchDetailVC alloc] init];
    [self.nav pushViewController:vc animated:YES];
}
#pragma mark - UISearchResultsUpdating
//每输入一个字符都会执行一次
- (void)updateSearchResultsForSearchController:(UISearchController *)searchController{
    NSLog(@"搜索关键字：%@",searchController.searchBar.text);
    searchController.searchResultsController.view.hidden = NO;
    
    //谓词搜索
    NSPredicate *preicate = [NSPredicate predicateWithFormat:@"SELF.name CONTAINS[s] %@ or SELF.age CONTAINS[s] %@", searchController.searchBar.text,searchController.searchBar.text];
    if (self.searchList!= nil) {
        [self.searchList removeAllObjects];
    }
    
    //过滤数据
    self.searchList = [NSMutableArray arrayWithArray:[_dataListArry filteredArrayUsingPredicate:preicate]];
   
     //刷新表格
    [self.mainTableView reloadData];
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
