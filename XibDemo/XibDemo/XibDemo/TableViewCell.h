//
//  TableViewCell.h
//  XibDemo
//
//  Created by wanghp on 16/5/18.
//  Copyright © 2016年 wanghp. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *m_labelText;
@property (strong, nonatomic) IBOutlet UIButton *m_btn;

+(instancetype)loadFromXib;
@end
