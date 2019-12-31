//
//  CZPillarView.h
//  Demo3
//
//  Created by 少年 on 14/11/4.
//  Copyright (c) 2014年 少年. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CZPillarView : UIView
@property (nonatomic,strong) NSArray* titleForXArray;
@property (nonatomic,strong) NSArray* titleForYArray;
@property (nonatomic,strong) NSArray* valueArray;
@property (nonatomic,strong) UIColor* pillarColor;
@property (nonatomic,assign) float minY;
@property (nonatomic,assign) float maxY;
@property (nonatomic,assign) int numberOfY;
- (void)reloadData;
@end
