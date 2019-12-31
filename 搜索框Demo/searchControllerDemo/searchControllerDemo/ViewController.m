//
//  ViewController.m
//  searchControllerDemo
//
//  Created by primb_xuyanhao on 2018/12/28.
//  Copyright © 2018 Primb. All rights reserved.
//

#import "ViewController.h"
#import "SearchResultViewController.h"
#import "personModel.h"

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate,UISearchControllerDelegate>

@property (nonatomic, strong) UITableView *mainTableView;
@property (nonatomic, strong) UISearchController *searchController;
@property (nonatomic, strong) SearchResultViewController *searchResultVC;

@property (nonatomic, strong) NSMutableArray *dataArr;
@property (nonatomic, strong) NSMutableArray *searchListArr;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.navigationItem.title = @"主页";
    
    for (int i = 0; i < 50; i++) {
        personModel *person = [[personModel alloc] init];
        person.name = [NSString stringWithFormat:@"小学生%d",i+1];
        person.age = [NSString stringWithFormat:@"%d",i];
        [self.dataArr addObject:person];
    }
    [self initSearchController];
}
-(NSMutableArray *)dataArr{
    if (!_dataArr) {
        _dataArr=[NSMutableArray array];
    }
    return _dataArr;
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
- (void)initSearchController{
    self.searchResultVC = [[SearchResultViewController alloc] init];
        /*
         初始化的时候可以选择搜索结果展示在哪个控制器。
         1、可以传nil，展示在当前控制器，根据searchController.isActive判断，如果是激活状态就使用搜索结果数组作为数据源，否则用全部数的数组作为数据源
         2、也可以单独创建一个控制器作为搜索结果的展示界面，将搜索结果传递到展示的控制器进行展示和数据操作等
         */
    
    _searchController = [[UISearchController alloc] initWithSearchResultsController:self.searchResultVC];
    _searchController.searchResultsUpdater = self.searchResultVC;
    _searchController.delegate = self;
    _searchController.searchBar.delegate = self;
    [_searchController.searchBar sizeToFit];
    self.definesPresentationContext = YES;
    //是否隐藏导航栏
    _searchController.hidesNavigationBarDuringPresentation = YES;
    //是否暗背景
    _searchController.dimsBackgroundDuringPresentation = NO;
    //是否模糊
    _searchController.obscuresBackgroundDuringPresentation = YES;
//        _searchController.searchBar.frame = CGRectMake(self.searchController.searchBar.frame.origin.x, self.searchController.searchBar.frame.origin.y, self.searchController.searchBar.frame.size.width, 44);
    _searchController.searchBar.barTintColor = [UIColor orangeColor];
    
    if (@available(iOS 11.0, *)) {
        self.navigationItem.searchController = self.searchController;
    } else {
        self.mainTableView.tableHeaderView = self.searchController.searchBar;
    }
    //加在导航栏上跳转结果页的时候导航栏会上移，导致UI偏移。
//    self.navigationItem.titleView = self.searchController.searchBar;
    
#warning 如果进入预编辑状态,searchBar消失(UISearchController套到TabBarController可能会出现这个情况),请添加下边这句话
    self.definesPresentationContext = YES;
    self.searchResultVC.nav = self.navigationController;
    self.searchResultVC.searchBar = self.searchController.searchBar;
    
    self.mainTableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    [self.mainTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
    
        // 可以通过此种方式修改searchBar的背景颜色
        /*
         _searchController.searchBar.barTintColor = [UIColor redColor];
         UIImageView *barImageView = [[[_searchController.searchBar.subviews firstObject] subviews] firstObject];
         barImageView.layer.borderColor = [UIColor redColor].CGColor;
         barImageView.layer.borderWidth = 1;
         */
        
        // 可以通过此种方式可以拿到搜索框，修改搜索框的样式
        /*
         UITextField *searchField = [[[_searchController.searchBar.subviews firstObject] subviews]lastObject];
         searchField.backgroundColor = [UIColor yellowColor];
         searchField.placeholder = @"请输入搜索内容";
         */
        // kvc设置取消按钮样式
        /*
         _searchController.searchBar.showsCancelButton = YES;
         UIButton *canceLBtn = [_searchController.searchBar valueForKey:@"cancelButton"];
         [canceLBtn setTitle:@"取消" forState:UIControlStateNormal];
         [canceLBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
         */
        
        /*
         // 通过遍历子控件也可以拿到取消按钮，设置其样式
         // 设置取消按钮开始的时候就展示出来，而不是在搜索的时候才出来
         _searchController.searchBar.showsCancelButton = YES;
         UIView * view = _searchController.searchBar.subviews[0];
         for (UIView *subView in view.subviews) {
         if ([subView isKindOfClass:[UIButton class]]) {
         UIButton *cancelBtn = (UIButton *)subView;
         [cancelBtn setTitleColor:[UIColor yellowColor] forState:UIControlStateNormal];
         [cancelBtn setTitle:@"哈哈" forState:UIControlStateNormal];
         }
         }
         */
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
//    if (self.searchController.active) {
//        return self.searchListArr.count;
//    }else{
//        return self.dataArr.count;
//    }
    return self.dataArr.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *reuseStr = @"cellID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseStr];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseStr];
    }
//    if (self.searchController.active) {
//        personModel *person = self.searchListArr[indexPath.row];
//        cell.textLabel.text = person.name;
//        cell.detailTextLabel.text = person.age;
//    }else{
//        personModel *person = self.dataArr[indexPath.row];
//        cell.textLabel.text = person.name;
//        cell.detailTextLabel.text = person.age;
//    }
    personModel *person = self.dataArr[indexPath.row];
    cell.textLabel.text = person.name;
    cell.detailTextLabel.text = person.age;
    return cell;
}
//- (void)updateSearchResultsForSearchController:(UISearchController *)searchController{
//    NSString *searchText = [self.searchController.searchBar text];
//    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.name CONTAINS[s] %@ or SELF.age CONTAINS[s] %@",searchText,searchText];
//    
//    if (self.searchListArr) {
//        [self.searchListArr removeAllObjects];
//    }
//    //筛选数据
//    self.searchListArr = [NSMutableArray arrayWithArray:[self.dataArr filteredArrayUsingPredicate:predicate]];
//    self.searchResultVC.resultArr = self.searchListArr.copy;
//    //刷新数据源
//    [self.mainTableView reloadData];
//}
- (void)willPresentSearchController:(UISearchController *)searchController{
    NSLog(@"SearchController即将present");
    self.tabBarController.tabBar.hidden = YES;
    self.edgesForExtendedLayout = UIRectEdgeBottom;
}
- (void)didPresentSearchController:(UISearchController *)searchController{
    NSLog(@"SearchController已经present完成");
    self.searchResultVC.dataListArry = self.dataArr;
}
- (void)willDismissSearchController:(UISearchController *)searchController{
    NSLog(@"SearchController即将Dismiss");
    self.tabBarController.tabBar.hidden = NO;
    self.edgesForExtendedLayout = UIRectEdgeBottom;
}
- (void)didDismissSearchController:(UISearchController *)searchController{
    NSLog(@"SearchController已经Dismiss完成");
}
@end
