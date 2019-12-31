//
//  ChapterHeaderCell.h
//  cellOpenAndCloseDemo
//
//  Created by primb_xuyanhao on 2018/12/26.
//  Copyright © 2018 Primb. All rights reserved.
//

#import <UIKit/UIKit.h>

@class cellModel;

NS_ASSUME_NONNULL_BEGIN

@interface ChapterHeaderCell : UITableViewCell<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UIImageView *imageView2;
@property (nonatomic, strong) UILabel *chapterName2;

@property (nonatomic, strong) NSMutableArray *dataArr;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *chapterIdArr;

- (void)configureCellWithModel:(cellModel *)model;

- (void)showTableView;
- (void)hiddenTableView;

@end

NS_ASSUME_NONNULL_END
