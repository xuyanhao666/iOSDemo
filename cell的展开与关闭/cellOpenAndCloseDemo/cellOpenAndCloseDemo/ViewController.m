//
//  ViewController.m
//  cellOpenAndCloseDemo
//
//  Created by primb_xuyanhao on 2018/12/25.
//  Copyright © 2018 Primb. All rights reserved.
//

#import "ViewController.h"
#import "cellModel.h"
#import "ChapterHeaderCell.h"

#define kScreen_Width     self.view.frame.size.width
#define kScreen_Height    self.view.frame.size.height
@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>

//当前tableView
@property (nonatomic, strong) UITableView *tableView;

//显示的数据
@property (nonatomic,strong) NSArray *dataSourceArr;

// 标记section是否展开的数据
@property (nonatomic, strong) NSMutableArray *sectionOpenOrCloseArr;

//存储打开cell的字典
@property (nonatomic, strong) NSMutableDictionary *cellOpenDic;

//当前section
@property (nonatomic, assign) NSInteger currentSection;

//当前行row
@property (nonatomic, assign) NSInteger currentRow;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.currentRow = -1;
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 88, kScreen_Width, kScreen_Height) style:UITableViewStylePlain];
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];

    self.dataSourceArr = [NSArray array];
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"json" ofType:@"txt"];
    NSString *fileString = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
    self.dataSourceArr = [NSJSONSerialization JSONObjectWithData:[fileString dataUsingEncoding:NSUTF8StringEncoding] options:0 error:nil];
    
    self.sectionOpenOrCloseArr = [NSMutableArray array];
    for (NSInteger i = 0; i < self.dataSourceArr.count; i++) {
        [self.sectionOpenOrCloseArr addObject:@0];
    }
    
    self.cellOpenDic = [NSMutableDictionary dictionary];
    for (NSDictionary *dic in self.dataSourceArr) {
        NSArray *arr2 = dic[@"sub"];
        for (NSDictionary *dic1 in arr2) {
            cellModel *model = [[cellModel alloc] initWithDict:dic1];
            model.isShow = NO;
            [self.cellOpenDic setObject:model forKey:dic1[@"chapterID"]];
        }
    }
    [self.tableView reloadData];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataSourceArr.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    BOOL isOpen = [self.sectionOpenOrCloseArr[section] boolValue];
    if (isOpen) {
        //数据决定显示多少行cell
        NSDictionary *secDic = self.dataSourceArr[section];
        //section决定cell的数据
        NSArray *secArr = secDic[@"sub"];
        return secArr.count;
    }else{
        //section是收起的时候
        return 0;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 60.f;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    NSDictionary *tempSectionDic = self.dataSourceArr[section];
    
    UIButton *cellHeaderBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    cellHeaderBtn.tag = section;
    cellHeaderBtn.frame = CGRectMake(0, 0, kScreen_Width, 60);
    cellHeaderBtn.backgroundColor = [UIColor whiteColor];
    [cellHeaderBtn addTarget:self action:@selector(sectionAction:) forControlEvents:UIControlEventTouchDown];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 0, 20, 60)];
    [cellHeaderBtn addSubview:imageView];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(40, 10, kScreen_Width - 80, 30)];
    titleLabel.text = tempSectionDic[@"chapterName"];
    [cellHeaderBtn addSubview:titleLabel];
    
    //分割线
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreen_Width, 0.25)];
    lineView.backgroundColor = [UIColor colorWithRed:204.0/255.0 green:204.0/255.0 blue:204.0/255.0 alpha:1];
    [cellHeaderBtn addSubview:lineView];
    
    BOOL sectionState = [self.sectionOpenOrCloseArr[section] boolValue];
    if (sectionState) {
        if ([tempSectionDic.allKeys containsObject:@"sub"]) {
            imageView.image = [UIImage imageNamed:@"一级减号"];
            [imageView setContentMode:UIViewContentModeScaleAspectFit];
        }else{
            imageView.image = [UIImage imageNamed:@"一级圆"];
            [imageView setContentMode:UIViewContentModeTop];
        }
    }else{
        if ([tempSectionDic.allKeys containsObject:@"sub"]) {
            imageView.image = [UIImage imageNamed:@"一级圆环加号"];
            [imageView setContentMode:UIViewContentModeTop];
        }else{
            imageView.image = [UIImage imageNamed:@"一级圆"];
            [imageView setContentMode:UIViewContentModeTop];
        }
    }
    return cellHeaderBtn;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *sectionDic = self.dataSourceArr[indexPath.section];
    NSArray *tempArr = sectionDic[@"sub"];
    //cell当前数据
    NSDictionary *cellDic = tempArr[indexPath.row];
    cellModel *model = [self.cellOpenDic objectForKey:cellDic[@"chapterID"]];
    if (model.isShow) {
        return (model.poisArr.count + 1)* 60;
    }else{
        return 60;
    }
    return 0;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ChapterHeaderCell *cell  = [[ChapterHeaderCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    cell.contentView.backgroundColor = [UIColor whiteColor];
    NSDictionary *cellDataDic = self.dataSourceArr[indexPath.section];
    NSArray *cellDataArr = cellDataDic[@"sub"];
    
    //cell当前数据
    NSDictionary *cellDic = cellDataArr[indexPath.row];
    cellModel *model = [self.cellOpenDic objectForKey:cellDic[@"chapterID"]];
    [cell configureCellWithModel:model];

    if (indexPath.row == cellDataArr.count - 1) {
        if (model.poisArr.count == 0) {
            cell.imageView2.image = [UIImage imageNamed:@"二级圆尾"];
        }else{
            if (model.isShow) {
                cell.imageView2.image = [UIImage imageNamed:@"三级圆环减"];
            }else{
                cell.imageView2.image = [UIImage imageNamed:@"二级圆环-尾加"];
            }
        }
        
        [cell.imageView2 setContentMode:UIViewContentModeScaleAspectFit];
    }else{
        if (model.poisArr.count == 0) {
            cell.imageView2.image = [UIImage imageNamed:@"zhongjian"];
        } else {
            if (!model.isShow) {
                cell.imageView2.image = [UIImage imageNamed:@"二级加号"];
            } else {
                cell.imageView2.image = [UIImage imageNamed:@"三级圆环减"];
            }
            
        }
        [cell.imageView2 setContentMode:UIViewContentModeScaleAspectFit];
    }
    cell.chapterName2.text = cellDic[@"chapterName"];
    
    if (model.isShow == YES) {
        [cell showTableView];
    } else {
        
        [cell hiddenTableView];
    }
    
    cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.frame];
    cell.selectedBackgroundView.backgroundColor = [UIColor clearColor];
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    
    self.currentRow = indexPath.row;
    
    NSDictionary *sectionDic = self.dataSourceArr[indexPath.section];
    NSArray *cellArray = sectionDic[@"sub"];
    
    //cell当前的数据
    NSDictionary *cellData = cellArray[indexPath.row];
    
    NSString *key = [NSString stringWithFormat:@"%@", cellData[@"chapterID"]];
    cellModel *chapterModel = [self.cellOpenDic valueForKey:key];
    
    chapterModel.isShow = !chapterModel.isShow;
    
    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
}
- (void)sectionAction:(UIButton *)btn{
    self.currentSection = btn.tag;
    //tableview收起，局部刷新
    BOOL currentOpen = ![self.sectionOpenOrCloseArr[self.currentSection] boolValue];
    [self.sectionOpenOrCloseArr replaceObjectAtIndex:self.currentSection withObject:[NSNumber numberWithBool:currentOpen]];
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:btn.tag] withRowAnimation:UITableViewRowAnimationAutomatic];
}
@end
