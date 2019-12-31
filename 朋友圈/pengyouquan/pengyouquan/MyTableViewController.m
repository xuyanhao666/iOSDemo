//
//  TableViewController.m
//  pengyouquan
//
//  Created by 青创汇 on 16/1/8.
//  Copyright © 2016年 青创汇. All rights reserved.
//

#import "MyTableViewController.h"
#import "SDRefeshView/SDRefresh.h"
#import "UITableView+SDAutoTableViewCellHeight.h"
#import "HeaderView.h"
#import "TableViewCell.h"
#import "Model.h"
#define kDemoVC9CellId @"demovc9cell"
@interface MyTableViewController (){
    SDRefreshFooterView *_refreshFooter;
    SDRefreshHeaderView *_refreshHeader;
}
@property (nonatomic, strong) NSMutableArray *modelsArray;


@end

@implementation MyTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.tableView.estimatedRowHeight = 100;
    [self creatModelsWithCount:10];

    self.automaticallyAdjustsScrollViewInsets = NO;
    __weak typeof(self)weakSelf = self;
    //上拉加载
    _refreshFooter = [SDRefreshFooterView refreshView];
    [_refreshFooter addToScrollView:self.tableView];
    __weak typeof(_refreshFooter)weakRefreshFooter = _refreshFooter;
    _refreshFooter.beginRefreshingOperation = ^(){
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC )), dispatch_get_main_queue(), ^{
            [weakSelf creatModelsWithCount:10];
            [weakSelf.tableView reloadData];
            [weakRefreshFooter endRefreshing];
        });
    };
    //下拉刷新
    _refreshHeader = [SDRefreshHeaderView refreshView];
    [_refreshHeader addToScrollView:self.tableView];
    __weak typeof(_refreshHeader)weakRefreshHeader = _refreshHeader;
    _refreshHeader.beginRefreshingOperation = ^(){
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if(!weakSelf.modelsArray){
                weakSelf.modelsArray = [NSMutableArray array];
            }
            if (weakSelf.modelsArray.count != 0) {
                [weakSelf.modelsArray removeAllObjects];
            }
            [weakSelf creatModelsWithCount:1];
            [weakSelf.tableView reloadData];
            [weakRefreshHeader endRefreshing];
        });
    };
    HeaderView *headerview = [HeaderView new];
    headerview.frame = CGRectMake(0, 0, 0, 260);
    self.tableView.tableHeaderView = headerview;
    
   [self.tableView registerClass:[TableViewCell class] forCellReuseIdentifier:kDemoVC9CellId];

}
- (void)fire{
    [self.tableView reloadData];
}
- (void)creatModelsWithCount:(NSInteger)count
{
    if (!_modelsArray) {
        _modelsArray = [NSMutableArray new];
    }
    
    NSArray *iconImageNamesArray = @[@"icon0.jpg",
                                     @"icon1.jpg",
                                     @"icon2.jpg",
                                     @"icon3.jpg",
                                     @"icon4.jpg",
                                     ];
    
    NSArray *namesArray = @[@"GSD_iOS",
                            @"风口上的猪",
                            @"当今世界网名都不好起了",
                            @"我叫郭德纲",
                            @"Hello Kitty"];
    
    NSArray *textArray = @[@"当你的 app 没有提供 3x 的 LaunchImage 时，系统默认进入兼容模式，大屏幕一切按照 320 宽度渲染，屏幕宽度返回 320；然后等比例拉伸到大屏。这种情况下对界面不会产生任何影响，等于把小屏完全拉伸。",
                           @"然后等比例拉伸到大屏。这种情况下对界面不会产生任何影响，等于把小屏完全拉伸。",
                           @"当你的 app 没有提供 3x 的 LaunchImage 时",
                           @"但是建议不要长期处于这种模式下，否则在大屏上会显得字大，内容少，容易遭到用户投诉。",
                           @"屏幕宽度返回 320；然后等比例拉伸到大屏。这种情况下对界面不会产生任何影响，等于把小屏完全拉伸。但是建议不要长期处于这种模式下。"
                           ];
    
    NSArray *picImageNamesArray = @[ @"pic0.jpg",
                                     @"pic1.jpg",
                                     @"pic2.jpg",
                                     @"pic3.jpg",
                                     @"pic4.jpg",
                                     @"pic5.jpg",
                                     @"pic6.jpg",
                                     @"pic7.jpg",
                                     @"pic8.jpg"
                                     ];
    
    for (int i = 0; i < count; i++) {
        int iconRandomIndex = arc4random_uniform(5);
        int nameRandomIndex = arc4random_uniform(5);
        int contentRandomIndex = arc4random_uniform(5);
        
        Model *model = [Model new];
        model.iconName = iconImageNamesArray[iconRandomIndex];
        model.name = namesArray[nameRandomIndex];
        model.content = textArray[contentRandomIndex];
        
        
//         模拟“随机图片”
        int random = arc4random_uniform(9);
        
        NSMutableArray *temp = [NSMutableArray new];
        for (int i = 0; i < random; i++) {
            int randomIndex = arc4random_uniform(9);
            [temp addObject:picImageNamesArray[randomIndex]];
        }
        if (temp.count) {
            model.picNamesArray = [temp copy];
        }
//        model.picNamesArray = [picImageNamesArray copy];
        [self.modelsArray addObject:model];
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.modelsArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat h = [self cellHeightForIndexPath:indexPath cellContentViewWidth:[UIScreen mainScreen].bounds.size.width];
    return h;
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
        TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kDemoVC9CellId];
    cell.selectionStyle = UITableViewCellAccessoryNone;
    cell.model = self.modelsArray[indexPath.row];
    
    return cell;
}
@end
