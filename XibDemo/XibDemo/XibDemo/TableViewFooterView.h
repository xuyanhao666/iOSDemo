//
//  TableViewFooterView.h
//  WHP_UITableView
//
//  Created by wanghp on 16/3/28.
//  Copyright © 2016年 wanghp. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TableViewFooterView : UIView
@property (strong, nonatomic) IBOutlet UIButton *m_insetCellBtn;
@property (strong, nonatomic) IBOutlet UIButton *m_deleCellBtn;
+(instancetype)loadFromXib;

@end
