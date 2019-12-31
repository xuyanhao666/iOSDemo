//
//  secViewController.m
//  xibDemo
//
//  Created by szyl on 16/5/19.
//  Copyright © 2016年 szyl. All rights reserved.
//

#import "secViewController.h"
#import "MyTableViewCell.h"
#import "footerView.h"
@interface secViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    footerView *_myFooterView;
    CGFloat _cellHeight;
}
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UITableView *myTableView;
@property (nonatomic, strong) NSArray * dataArray;
@end
static NSString *cellIdentifier = @"MyTableViewCell";
@implementation secViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    _imgView.image = [UIImage imageNamed:@"barcode"];
    
    //1.xib 第一种方法 注册
     [self.myTableView registerNib:[UINib nibWithNibName:cellIdentifier bundle:nil] forCellReuseIdentifier:cellIdentifier];
    
    _myFooterView = [footerView loadFromXib];
    _myFooterView.myLabel.text = @"哈哈";
    _myFooterView.myLabel.textColor = [UIColor redColor];
//    [self.myTableView setTableFooterView:_myFooterView];
    
}
- (NSArray *)dataArray
{
    if (!_dataArray) {
        _dataArray = @[@"测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试0",
                       @"测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试1",
                       @"测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试2",
                       @"测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试3",
                       @"测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试4",
                       @"测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试5"];
    }
    return _dataArray;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSLog(@"%ld",self.dataArray.count);
    return _dataArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 44;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return _myFooterView;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MyTableViewCell *cell = [self.myTableView dequeueReusableCellWithIdentifier:cellIdentifier];
    CGRect screenBounds = [UIScreen mainScreen].bounds;
    cell.messageLabelConstrains.constant = screenBounds.size.width - 130;
    cell.messageLabel.text = _dataArray[indexPath.row];
    CGSize size = [cell.contentView systemLayoutSizeFittingSize:UILayoutFittingExpandedSize];
    return size.height+10;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
//    if (cell== nil) {
//        cell = [MyTableViewCell loadFromXib];
//    }
    cell.iconImg.image = [UIImage imageNamed:@"barcode"];
    cell.titileLabel.text = @"测试标题";
    cell.messageLabel.text = _dataArray[indexPath.row];

    CGRect screenBounds = [UIScreen mainScreen].bounds;
    cell.messageLabelConstrains.constant = screenBounds.size.width - 130;
    
    return cell;
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
