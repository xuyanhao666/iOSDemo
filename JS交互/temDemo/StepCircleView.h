//
//  StepCircleView.h
//  TianYiHealthy
//
//  Created by 许艳豪 on 15/12/11.
//  Copyright © 2015年 xingzhi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StepCircleView : UIView
@property(nonatomic, strong) NSString *isDefualt;
@property(nonatomic)CALayer * layer_d;
@property(nonatomic,strong)CAShapeLayer *progressLayer;
@property(nonatomic,assign)CGFloat score;
-(void)startAnimation;

@end
