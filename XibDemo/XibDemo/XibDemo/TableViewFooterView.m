//
//  TableViewFooterView.m
//  WHP_UITableView
//
//  Created by wanghp on 16/3/28.
//  Copyright © 2016年 wanghp. All rights reserved.
//

#import "TableViewFooterView.h"

@implementation TableViewFooterView

-(void)awakeFromNib{
    self.m_deleCellBtn.backgroundColor = [UIColor redColor];
    [self.m_deleCellBtn setTitle:@"删除" forState:UIControlStateNormal];
    [self.m_deleCellBtn setTintColor:[UIColor whiteColor]];
    
    self.m_insetCellBtn.backgroundColor = [UIColor greenColor];
    [self.m_insetCellBtn setTitle:@"插入" forState:UIControlStateNormal];
    [self.m_insetCellBtn setTintColor:[UIColor whiteColor]];
}
+(instancetype)loadFromXib{
    return [[NSBundle mainBundle]loadNibNamed:@"TableViewFooterView" owner:nil options:nil][0];
}

@end
