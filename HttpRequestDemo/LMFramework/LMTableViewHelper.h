//
//  LMTableViewHelper.h
//  UnifiedPortal
//
//  Created by zero on 15/8/7.
//  Copyright (c) 2015年 zero. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface LMTableViewHelper : NSObject
+ (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath HorizontalInset:(CGFloat)horizontalInset Color:(UIColor*)color;
@end
