//
//  LICombinationListViewController.m
//  LIGHTinvesting
//
//  Created by hundsun on 15/11/30.
//  Copyright © 2015年 Hundsun. All rights reserved.
//

#import "LICombinationListViewController.h"
#import "UINavigationController+FDFullscreenPopGesture.h"
#import "LISliderHeaderView.h"
#import "LICombinationListCell.h"
#import "LISkinCss.h"

#import "Masonry.h"

@interface LICombinationListViewController ()<LISliderHeaderViewDelegate,UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate>{
    CGSize _sliderSize;
    NSInteger _index;
    NSMutableArray *firstDataSource;
    NSMutableArray *secondDataSource;
    NSMutableArray *thirdDataSource;
    NSMutableArray *fourthDataSource;
    NSMutableArray *fifthDataSource;
    NSMutableArray *sixthDataSource;
    NSMutableArray *seventhDataSource;
    BOOL _direction;     //scrollView的滑动方向

    float beginPositionX;   //记录开始滑动时的scrollView的位置
}
@property (nonatomic, strong) UIView *topView;
@property (nonatomic, strong) UIButton *backButton;             //返回按钮
@property (nonatomic, strong) UILabel *titleLabel;              //标题
@property (nonatomic, strong) UIScrollView *scrollView;         //标题滚动ScrollView
@property (nonatomic, strong) LISliderHeaderView *sliderHeaderView;//榜单名称
@property (nonatomic, strong) UIView *sliderView;               //红线
@property (nonatomic, strong) UIScrollView *scrollView1;         //列表横向滚动
@property (nonatomic, strong) UITableView *pretableView;        //
@property (nonatomic, strong) UITableView *curTableView;
@property (nonatomic, strong) UITableView *nextTableView;
@end

@implementation LICombinationListViewController

#pragma mark - life Circle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initWithData];
    self.fd_prefersNavigationBarHidden = YES;
    self.view.backgroundColor = [LISkinCss colorRGBeeeef3];
    [self.view addSubview:self.topView];
    [self.view addSubview:self.backButton];
    [self.view addSubview:self.titleLabel];
    [self.view addSubview:self.scrollView];
    [self.scrollView addSubview:self.sliderHeaderView];
    [self.scrollView addSubview:self.sliderView];
    [self.view addSubview:self.scrollView1];
    [self.scrollView1 addSubview:self.pretableView];
    [self.scrollView1 addSubview:self.curTableView];
    [self.scrollView1 addSubview:self.nextTableView];
    [self updateTableViewFrame:0];
    [self layoutSubPages];
}

#pragma mark - response Action
- (void)initWithData{
    _sliderSize = [UIScreen mainScreen].bounds.size;
}

- (void)doBackAction{
    [self.navigationController popViewControllerAnimated:YES];
}
//请求并刷新数据源
- (void)updateDataSouceByIndex:(NSInteger)index{
    switch (index) {
        case 0:
            NSLog(@"请求最近发布榜单数据");
            break;
        case 1:
            NSLog(@"请求收益最高榜单数据");
            break;
        case 2:
            NSLog(@"请求门槛最低榜单数据");
            break;
        case 3:
            NSLog(@"请求领投成功率榜单数据");
            break;
        case 4:
            NSLog(@"请求历史最牛榜单数据");
            break;
        case 5:
            NSLog(@"请求你真厉害榜单数据");
            break;
        case 6:
            NSLog(@"请求我最厉害榜单数据");
            break;
        default:
            break;
    }
}
- (void) updateTableViewFrame:(NSInteger)index{
    _curTableView.frame = CGRectMake(_sliderSize.width *index,0 , _sliderSize.width, _sliderSize.height);
    if (index ==0) {
        _nextTableView.frame = CGRectMake(_sliderSize.width *(index+1),0 , _sliderSize.width, _sliderSize.height);
    }
    if (index >= 1 && index <= 5) {
         _pretableView.frame = CGRectMake(_sliderSize.width *(index-1),0 , _sliderSize.width, _sliderSize.height);
        _nextTableView.frame = CGRectMake(_sliderSize.width *(index+1),0 , _sliderSize.width, _sliderSize.height);
    }
    if (index == 6) {
        _pretableView.frame = CGRectMake(_sliderSize.width *(index-1),0 , _sliderSize.width, _sliderSize.height);
    }
    
}
#pragma mark - LISliderHeaderViewDelegate

- (void)switchPageByIndex:(NSInteger)index{
    _index = index;
    [_scrollView1 setContentOffset:CGPointMake(_index * _sliderSize.width, 0) animated:YES];
    [self updateDataSouceByIndex:_index];
}

#pragma mark - UIScrollView delegate
//当
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if ([_scrollView1 isEqual:scrollView]) {
        if (_sliderView.frame.origin.x > _sliderHeaderView.bounds.size.width-_sliderSize.width) {
            [_scrollView setContentOffset:CGPointMake( _sliderHeaderView.bounds.size.width-_sliderSize.width, 0) animated:YES];
        }
        if (_sliderHeaderView.bounds.size.width-_sliderSize.width > _sliderView.frame.origin.x) {
            [_scrollView setContentOffset:CGPointMake( 0, 0) animated:YES];
        }
        CGRect frame = _sliderView.frame;
        frame.origin.x = scrollView.contentOffset.x/_sliderSize.width * 80;
        _sliderView.frame = frame;
    }
}
//滑动结束请求数据
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    if ([_scrollView1 isEqual:scrollView]) {
        if (scrollView.contentOffset.x-beginPositionX ==_sliderSize.width || beginPositionX-scrollView.contentOffset.x) {
            NSInteger currentPage = scrollView.contentOffset.x/_sliderSize.width;
            [self updateTableViewFrame:currentPage];
            [self updateDataSouceByIndex:currentPage];
        }
    }
}
//将要开始拖拽记录起始位置
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    if ([_scrollView1 isEqual:scrollView]) {
        beginPositionX = scrollView.contentOffset.x;
    }
}

#pragma mark - UItableViewDelegate

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    cell.backgroundColor = [UIColor whiteColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 115;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 8;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    LICombinationListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"firstIndentifier" forIndexPath:indexPath];
    NSDictionary *dict = [NSDictionary dictionary];
    [cell loadData:dict];
    
    return cell;
}

#pragma mark - private method

- (void) layoutSubPages{
    [self.topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view.mas_top);
        make.left.and.right.mas_equalTo(self.view);
        make.height.mas_equalTo(64);
    }];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.topView.mas_centerY).offset(10);
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.size.mas_equalTo(CGSizeMake(120, 44));
    }];
    [self.backButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.topView.mas_centerY).offset(10);
        make.left.mas_equalTo(self.view.mas_left);
        make.size.mas_equalTo(CGSizeMake(40, 39));
    }];
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.topView.mas_bottom);
        make.left.and.right.mas_equalTo(self.view);
        make.height.mas_equalTo(42);
    }];
    [self.scrollView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.scrollView.mas_bottom);
        make.left.right.and.bottom.mas_equalTo(self.view);
    }];
}

#pragma mark - setter and getter

- (UIButton *)backButton{
    if (_backButton == nil) {
        _backButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_backButton setImage:[UIImage imageNamed:@"back_icon" ] forState:UIControlStateNormal];
        [_backButton addTarget:self action:@selector(doBackAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _backButton;
}
- (UILabel *)titleLabel{
    if (_titleLabel == nil) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [LISkinCss fontSize18];
        _titleLabel.textColor = [LISkinCss colorRGBffffff];
        _titleLabel.text = @"组合榜单";
        _titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLabel;
}
- (UIView *)topView{
    if (_topView == nil) {
        _topView = [[UIView alloc] init];
        _topView.backgroundColor = [LISkinCss colorRGB3b3f4a];
    }
    return _topView;
}
- (UIScrollView *)scrollView{
    if (_scrollView == nil) {
        _scrollView = [[UIScrollView alloc]init];
        _scrollView.backgroundColor = [UIColor clearColor];
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.alwaysBounceHorizontal = YES;
        _scrollView.contentSize = CGSizeMake(560, 0);
        _scrollView.pagingEnabled = NO;
        _scrollView.bounces = NO;
        _scrollView.delegate = self;
        _scrollView.scrollEnabled = YES;
    }
    return _scrollView;
}
- (LISliderHeaderView *)sliderHeaderView{
    if (_sliderHeaderView == nil) {
        _sliderHeaderView = [[LISliderHeaderView alloc] init];
        _sliderHeaderView.backgroundColor = [UIColor whiteColor];
        _sliderHeaderView.delegate = self;
        _sliderHeaderView.frame = CGRectMake(0, 0,560, 40);
    }
    return _sliderHeaderView;
}
- (UIView *)sliderView{
    if (_sliderView == nil) {
        _sliderView = [[UIView alloc] init];
        _sliderView.backgroundColor = [LISkinCss colorRGBf75300];
        _sliderView.frame = CGRectMake(0, 40, 80, 2);
    }
    return _sliderView;
}
- (UIScrollView *)scrollView1{
    if (_scrollView1 == nil) {
        _scrollView1 = [[UIScrollView alloc] init];
        _scrollView1.backgroundColor = [LISkinCss colorRGBeeeef3];
        _scrollView1.showsHorizontalScrollIndicator = NO;
        _scrollView1.showsVerticalScrollIndicator = NO;
        _scrollView1.pagingEnabled = YES;
        _scrollView1.scrollEnabled = YES;
        _scrollView1.delegate = self;
        _scrollView1.bounces = NO;
        _scrollView1.contentSize = CGSizeMake(_sliderSize.width*7, 0);
    }
    return _scrollView1;
}
- (UITableView *)pretableView{
    if (_pretableView == nil) {
        _pretableView = [[UITableView alloc] init];
        _pretableView.backgroundColor = [LISkinCss colorRGBeeeef3];
        _pretableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _pretableView.delegate = self;
        _pretableView.dataSource = self;
        _pretableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
        [_pretableView registerClass:[LICombinationListCell class] forCellReuseIdentifier:@"firstIndentifier"];
    }
    return _pretableView;
}
- (UITableView *)curTableView{
    if (_curTableView == nil) {
        _curTableView = [[UITableView alloc] init];
        _curTableView.backgroundColor = [LISkinCss colorRGBeeeef3];
        _curTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _curTableView.delegate = self;
        _curTableView.dataSource = self;
        _curTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
        [_curTableView registerClass:[LICombinationListCell class] forCellReuseIdentifier:@"firstIndentifier"];
    }
    return _curTableView;
}
- (UITableView *)nextTableView{
    if (_nextTableView == nil) {
        _nextTableView = [[UITableView alloc] init];
        _nextTableView.backgroundColor = [LISkinCss colorRGBeeeef3];
        _nextTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _nextTableView.delegate = self;
        _nextTableView.dataSource = self;
        _nextTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
        [_nextTableView registerClass:[LICombinationListCell class] forCellReuseIdentifier:@"firstIndentifier"];
    }
    return _nextTableView;
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
