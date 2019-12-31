//
//  ViewController.m
//  二级联动菜单
//
//  Created by huandi on 15/12/7.
//  Copyright © 2015年 Chndyx_Team. All rights reserved.
//

#import "ViewController.h"
#import "FSDropDownMenu.h"

@interface ViewController ()<FSDropDownMenuDataSource,FSDropDownMenuDelegate>
/**
 *   cityArray  城市数组        areaArray  城市区域数组
 *   currentAreaArray  当前区域的数组
 */
@property (nonatomic, copy) NSArray * cityArr;
@property (nonatomic, copy) NSArray * areaArr;
@property (nonatomic, copy) NSArray *currentAreaArr;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.

    self.title = @"二级联动菜单";
    self.view.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1.f];
    
    [self createUI];
}
/**
 *   布局整体联动界面
 */
-(void)createUI{
    UIButton *activityBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    activityBtn.frame = CGRectMake(0, 0, 62, 30);
    activityBtn.titleLabel.font = [UIFont systemFontOfSize:14.0f];
    [activityBtn setTitle:@"附近" forState:UIControlStateNormal];
    [activityBtn setImage:[UIImage imageNamed:@"expandableImage@2x"] forState:UIControlStateNormal];
    activityBtn.imageEdgeInsets = UIEdgeInsetsMake(11, 52, 11, 0);
    [activityBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [activityBtn addTarget:self action:@selector(btnPressed:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:activityBtn];
    /**
     *   数据源
     */
    _cityArr = @[@"附近",@"上海",@"北京",@"同城"];
    _areaArr = @[@[@"附近",@"500米",@"1000米",@"2000米",@"5000米"],
                @[@"徐家汇",@"人民广场",@"陆家嘴"],
                @[@"三里屯",@"宋家庄",@"朝阳公园"],
                @[@"同城"],];
    _currentAreaArr = _areaArr[0];
    FSDropDownMenu *menu = [[FSDropDownMenu alloc] initWithOrigin:CGPointMake(0, 64) andHeight:300];
//    menu.rightTableView.backgroundColor = [UIColor redColor];
    menu.transformView = activityBtn.imageView;
    menu.tag = 1001;
    menu.dataSource = self;
    menu.delegate = self;
    [self.view addSubview:menu];
}
# pragma  mark ------------- 点击事件 ---------------
-(void)btnPressed:(id)sender{
    FSDropDownMenu *menu = (FSDropDownMenu *)[self.view viewWithTag:1001];
    [UIView animateWithDuration:0.2 animations:^{
        
    } completion:^(BOOL finished) {
        [menu menuTapped];
    }];
}
#pragma mark ------  reset button size -----------
-(void)resetItemSizeBy:(NSString *)str{
    UIButton * btn = (UIButton *)self.navigationItem.rightBarButtonItem.customView;
    [btn setTitle:str forState:UIControlStateNormal];
    NSDictionary *dict = @{NSFontAttributeName :btn.titleLabel.font};
    CGSize size = [str boundingRectWithSize:CGSizeMake(150, 30) options:NSStringDrawingUsesLineFragmentOrigin attributes:dict context:nil].size;
    btn.frame = CGRectMake(btn.frame.origin.x, btn.frame.origin.y, size.width+33, 30);
    btn.imageEdgeInsets = UIEdgeInsetsMake(11, size.width+23, 11, 0);
}
#pragma mark -------- FSDropDown datasource & delegate -----
-(NSInteger)menu:(FSDropDownMenu *)menu tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView == menu.rightTableView) {
        return _cityArr.count;
    }else{
        return _currentAreaArr.count;
    }
}
-(NSString *)menu:(FSDropDownMenu *)menu tableView:(UITableView *)tableView titleForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == menu.rightTableView) {
        return _cityArr[indexPath.row];
    }else{
        return _currentAreaArr[indexPath.row];
    }
}
-(void)menu:(FSDropDownMenu *)menu tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == menu.rightTableView) {
        _currentAreaArr = _areaArr[indexPath.row];
        [menu.leftTableView reloadData];
    }else{
        [self resetItemSizeBy:_currentAreaArr[indexPath.row]];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
