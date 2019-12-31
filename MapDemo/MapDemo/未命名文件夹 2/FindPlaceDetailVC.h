//
//  FindPlaceDetailVC.h
//  TianYiHealthy
//
//  Created by Ray Zhao on 15/9/24.
//  Copyright © 2015年 xingzhi. All rights reserved.
//

#import "BaseViewController.h"
@protocol FindPlaceDelegate <NSObject>

- (void) selectedOnePlace:(NSDictionary *) placeDic;

@end

@interface FindPlaceDetailVC : BaseViewController

@property (nonatomic, weak) id<FindPlaceDelegate> delegate;

@property(nonatomic,copy)NSString *parentid;
@end
