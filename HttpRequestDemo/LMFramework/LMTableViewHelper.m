//
//  LMTableViewHelper.m
//  UnifiedPortal
//
//  Created by zero on 15/8/7.
//  Copyright (c) 2015年 zero. All rights reserved.
//

#import "LMTableViewHelper.h"

@implementation LMTableViewHelper

+ (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath HorizontalInset:(CGFloat)horizontalInset Color:(UIColor*)color
{
    if ([cell respondsToSelector:@selector(tintColor)]) {
        cell.backgroundColor = UIColor.clearColor;
        if(color == nil){
            color = [UIColor colorWithWhite:0.90f alpha:.95f];
        }
        CAShapeLayer *layer = [self tableView:tableView layerForCell:cell forRowAtIndexPath:indexPath withColor:color HorizontalInset:horizontalInset];
        
        CGRect bounds = CGRectInset(cell.bounds, horizontalInset, 0);
        
        UIView *testView = [[UIView alloc] initWithFrame:bounds];
        [testView.layer insertSublayer:layer atIndex:0];
        testView.backgroundColor = UIColor.clearColor;
        cell.backgroundView = testView;
    }
}

// cell 选择背景
+ (UIView *)backgroundCellView:(UITableViewCell *)cell indexPath:(NSIndexPath *)indexPath tableView:(UITableView *)tableView
{
    UIColor *cellColor = [UIColor lightGrayColor];
    CAShapeLayer *layer = [self tableView:tableView layerForCell:cell forRowAtIndexPath:indexPath withColor:cellColor HorizontalInset:10];
    
    CGRect bounds = CGRectInset(cell.bounds, 10, 0);
    UIView *testView = [[UIView alloc] initWithFrame:bounds];
    [testView.layer insertSublayer:layer atIndex:0];
    return testView;
}

+ (CAShapeLayer *)tableView:(UITableView *)tableView layerForCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath withColor:(UIColor *)color HorizontalInset:(CGFloat)horizontalInset
{
    CGFloat cornerRadius = 3.f;
    CAShapeLayer *layer = [[CAShapeLayer alloc] init];
    CGMutablePathRef pathRef = CGPathCreateMutable();
    CGRect bounds = CGRectInset(cell.bounds, horizontalInset, 0);
    BOOL addLine = NO;
    if (indexPath.row == 0 && indexPath.row == [tableView numberOfRowsInSection:indexPath.section]-1) {
        CGPathAddRoundedRect(pathRef, nil, bounds, cornerRadius, cornerRadius);
    } else if (indexPath.row == 0) {
        CGPathMoveToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMaxY(bounds));
        CGPathAddArcToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMinY(bounds), CGRectGetMidX(bounds), CGRectGetMinY(bounds), cornerRadius);
        CGPathAddArcToPoint(pathRef, nil, CGRectGetMaxX(bounds), CGRectGetMinY(bounds), CGRectGetMaxX(bounds), CGRectGetMidY(bounds), cornerRadius);
        CGPathAddLineToPoint(pathRef, nil, CGRectGetMaxX(bounds), CGRectGetMaxY(bounds));
        addLine = YES;
    } else if (indexPath.row == [tableView numberOfRowsInSection:indexPath.section]-1) {
        CGPathMoveToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMinY(bounds));
        CGPathAddArcToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMaxY(bounds), CGRectGetMidX(bounds), CGRectGetMaxY(bounds), cornerRadius);
        CGPathAddArcToPoint(pathRef, nil, CGRectGetMaxX(bounds), CGRectGetMaxY(bounds), CGRectGetMaxX(bounds), CGRectGetMidY(bounds), cornerRadius);
        CGPathAddLineToPoint(pathRef, nil, CGRectGetMaxX(bounds), CGRectGetMinY(bounds));
    } else {
        CGPathAddRect(pathRef, nil, bounds);
        addLine = YES;
    }
    layer.path = pathRef;
    CFRelease(pathRef);
    //        layer.fillColor = [UIColor colorWithWhite:1.f alpha:1.0f].CGColor;
    layer.fillColor = color.CGColor;
    
    if (addLine == YES) {
        CALayer *lineLayer = [[CALayer alloc] init];
        CGFloat lineHeight = (1.f / [UIScreen mainScreen].scale);
        lineLayer.frame = CGRectMake(CGRectGetMinX(bounds)+10, bounds.size.height-lineHeight, bounds.size.width-10, lineHeight);
        lineLayer.backgroundColor = tableView.separatorColor.CGColor;
        [layer addSublayer:lineLayer];
    }
    
    return layer;
}

@end
