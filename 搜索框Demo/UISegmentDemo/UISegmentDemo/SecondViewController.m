//
//  SecondViewController.m
//  UISegmentDemo
//
//  Created by 许艳豪 on 15/11/19.
//  Copyright © 2015年 ideal_Mac. All rights reserved.
//

#import "SecondViewController.h"

@interface SecondViewController ()<UITableViewDataSource,UITableViewDelegate,UISearchControllerDelegate,UISearchBarDelegate,UISearchResultsUpdating,UIAlertViewDelegate>
@property (nonatomic, strong) UITableView *myTableView;
@property (nonatomic, strong) NSMutableArray *visableArray;
@property (nonatomic, strong) NSMutableArray *filterArray;//好像没用到。。
@property (nonatomic, strong) NSMutableArray *dataSourceArray;
@property (nonatomic, strong) UISearchController *mySearchController;
@end

@implementation SecondViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    UIBarButtonItem *left = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"bt_back_up"] style:UIBarButtonItemStylePlain target:self action:@selector(onleft)];
    left.imageInsets =  UIEdgeInsetsMake(0,-10,0,0);
    self.navigationItem.rightBarButtonItem = left;
//
//    UIApplication* app = [UIApplication sharedApplication];
//    app.networkActivityIndicatorVisible = YES;
//    [[UIApplication sharedApplication] delegate];
   
}
-(void)onleft{
//    [self.navigationController popViewControllerAnimated:YES];
//    UIApplication* app = [UIApplication sharedApplication];
//    app.networkActivityIndicatorVisible = NO;
    UIAlertView *myAlert = [[UIAlertView alloc] initWithTitle:@"测试" message:@"人最重要的是开心" delegate: self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    myAlert.cancelButtonIndex = 0;
    myAlert.alertViewStyle = UIAlertViewStyleLoginAndPasswordInput;
    [myAlert show];
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
//    if (buttonIndex != alertView.cancelButtonIndex) {
//        NSLog(@"====%@ ----%@",[alertView textFieldAtIndex:0].text,[alertView textFieldAtIndex:1].text);
//    }
    if (buttonIndex ==1) {
        NSLog(@"====%@ ----%@",[alertView textFieldAtIndex:0].text,[alertView textFieldAtIndex:1].text);
    }

}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"搜索一下试试看";
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIProgressView *progress = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleBar];
    progress.frame = CGRectMake(150, 20, self.view.frame.size.width, 30);
//    [self.navigationController.navigationBar addSubview:progress];
    progress.progressTintColor = [UIColor greenColor];
    progress.trackTintColor = [UIColor blueColor];
//    [self.view addSubview:progress];
    [self.navigationController.toolbar addSubview:progress];
    
//    当你的应用程序使用网络时，应当在iPhone的状态条上放置一个网络指示器，警告用户正在使用网络。这时你可以用UIApplication的一个名为networkActivityIndicatorVisible的属性。通过设置这个可以启用或禁用网络指示器：
//    UIApplication* app = [UIApplication sharedApplication];
//    app.networkActivityIndicatorVisible = YES;
    
    [self initial];
}
- (void)initial{
    self.dataSourceArray = [NSMutableArray array];
    self.visableArray = [NSMutableArray array];
    NSArray *tempArr = @[@"我是小明",@"我是小白",@"我是小黑",@"我是小军"];
    for (int i = 0; i < 26; i++) {
        for (int j = 0; j < 4; j++) {
            NSString *str = [NSString stringWithFormat:@"%c%d", 'A'+i, j];
            NSMutableDictionary *dic = [NSMutableDictionary dictionary];
            [dic setObject:str forKey:@"num"];
            [dic setObject:tempArr[j] forKey:@"name"];
            [self.dataSourceArray addObject:dic];
        }
    }
    
    _visableArray = self.dataSourceArray;
    
    self.myTableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    _myTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    _myTableView.delegate = self;
    _myTableView.dataSource = self;
    [self.view addSubview:_myTableView];
    
    UIViewController *myCon = [[UIViewController alloc] init];
    UIView *myView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 375, 667)];
    myView.backgroundColor = [UIColor redColor];
    [myCon.view addSubview:myView];
//    [myCon.view addSubview:myView];
    
    self.mySearchController = [[UISearchController alloc] initWithSearchResultsController:nil];
//    _mySearchController.navigationItem.rightBarButtonItem = @"取消";
    _mySearchController.searchResultsUpdater = self;    
    _mySearchController.dimsBackgroundDuringPresentation = NO;
    _mySearchController.searchBar.placeholder = @"搜索查询";
    [_mySearchController.searchBar sizeToFit];
    
    self.myTableView.tableHeaderView = self.mySearchController.searchBar;

}
//-(void)searchBarTextDidBeginEditing:(UISearchBar*)searchBar{
//    [searchBar setShowsCancelButton:YES animated:YES];
//    
//    UIButton *btn=[searchBar valueForKey:@"_cancelButton"];
//    [btn setTitle:@"取消" forState:UIControlStateNormal];
//}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (!_visableArray || _visableArray.count == 0) {
        _visableArray = _dataSourceArray;
        return _visableArray.count;
    }
    return _visableArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (!_visableArray || _visableArray.count == 0) {
            _visableArray = _dataSourceArray;
        return self.view.bounds.size.height;
    }
    return 88;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"identifier"];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"identifier"];
    }
    if (_visableArray.count != 0) {
        cell.textLabel.text = [[_visableArray objectAtIndex:indexPath.row] objectForKey:@"num"];
        cell.detailTextLabel.text = [[_visableArray objectAtIndex:indexPath.row] objectForKey:@"name"];
    }

    return cell;
}

- (void)updateSearchResultsForSearchController:(UISearchController *)searchController{
    NSString *filterString = searchController.searchBar.text;
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.name contains [cd] %@ or SELF.num contains [cd] %@", filterString,filterString];
//    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.name LIKE[cd] *%@*", filterString,filterString];
    
    self.visableArray = [NSMutableArray arrayWithArray:[self.dataSourceArray filteredArrayUsingPredicate:predicate]];
    
    [self.myTableView reloadData];
}
- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    NSMutableArray *muArr = [NSMutableArray array];
    for (int i = 0; i < 26; i++) {
        NSString *str = [NSString stringWithFormat:@"%c", 'A'+i];
        [muArr addObject:str];
    }
    [muArr  insertObject:UITableViewIndexSearch atIndex:0];
    
    return muArr;
}

- (NSInteger) tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
    
    if ([title isEqualToString: UITableViewIndexSearch]) {
        [tableView scrollRectToVisible:tableView.tableHeaderView.frame animated:YES];
        return -1;
    }else
        return index -1;
}
//-(NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
//{
//    return [NSArray arrayWithObjects:UITableViewIndexSearch,@"+",@"A",@"B",@"C",@"D",@"E",@"F",@"G",@"H",@"I",@"J",@"K",@"L",@"M",@"N",@"O",@"P",@"Q",@"R",@"S",@"T",@"U",@"V",@"W",@"X",@"Y",@"Z",@"#", nil];
//}
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
