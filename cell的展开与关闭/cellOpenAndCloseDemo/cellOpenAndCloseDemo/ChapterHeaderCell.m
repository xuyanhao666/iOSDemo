//
//  ChapterHeaderCell.m
//  cellOpenAndCloseDemo
//
//  Created by primb_xuyanhao on 2018/12/26.
//  Copyright © 2018 Primb. All rights reserved.
//

#import "ChapterHeaderCell.h"
#import "cellModel.h"
#import "ContentTableViewCell.h"

@implementation ChapterHeaderCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.dataArr = [NSMutableArray array];
        self.chapterIdArr = [NSMutableArray array];
        [self initBasicUI];
    }
    return self;
}
- (void)initBasicUI{
    self.imageView2 = [[UIImageView alloc] initWithFrame:CGRectMake(10, -4, 19, 64)];
    [self.contentView addSubview:self.imageView2];
    self.chapterName2 = [[UILabel alloc] initWithFrame:CGRectMake(45, 8, 183, 21)];
    self.chapterName2.font = [UIFont systemFontOfSize:15];
    [self.contentView addSubview:self.chapterName2];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 59, [UIScreen mainScreen].bounds.size.width, 1) style:UITableViewStylePlain];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.scrollEnabled = NO;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
//    [self.tableView registerClass:[ContentTableViewCell class] forCellReuseIdentifier:@"testCell"];
}

- (void)showTableView {
    [self.contentView addSubview:self.tableView];
}

- (void)hiddenTableView {
    [self.tableView removeFromSuperview];
}

- (void)configureCellWithModel:(cellModel *)model{
    [self.dataArr removeAllObjects];
    NSArray *array = model.poisArr;
    for (NSDictionary *dic in array) {
        [self.dataArr addObject:dic[@"chapterName"]];
        [self.chapterIdArr addObject:dic[@"chapterID"]];
    }
    CGRect frame = self.tableView.frame;
    frame.size.height = 60 * array.count;
    self.tableView.frame = frame;
//    [self.tableView reloadData];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ContentTableViewCell *contentCell = [[ContentTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cellID"];
    contentCell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSString *str = self.dataArr[indexPath.row];
    
    contentCell.image = [[UIImageView alloc] initWithFrame:CGRectMake(10, 0, 19, 60)];
    [contentCell.contentView addSubview:contentCell.image];
    contentCell.label = [[UILabel alloc] initWithFrame:CGRectMake(45, 8, 183, 21)];
    contentCell.label.font = [UIFont systemFontOfSize:15];
    [contentCell.contentView addSubview:contentCell.label];
    
    contentCell.label.text = str;
    
    //判断cell的位置选择折叠图片
    if (indexPath.row == self.dataArr.count - 1) {
        contentCell.image.image = [UIImage imageNamed:@"三级圆环"];
        [contentCell.image setContentMode:UIViewContentModeScaleAspectFit];
    }else{
        contentCell.image.image = [UIImage imageNamed:@"三级圆环"];
        [contentCell.image setContentMode:UIViewContentModeScaleAspectFit];
    }
    return contentCell;
}
@end
