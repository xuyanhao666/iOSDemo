//
//  ActivityModel.h
//  HttpRequestDemo
//
//  Created by szyl on 16/6/3.
//  Copyright © 2016年 xyh. All rights reserved.
//

#import "BaseModel.h"

@interface ActivityModel : BaseModel

@property (nonatomic, strong) NSString * activityAddress;
@property (nonatomic, strong) NSString * activityStartTime;
@property (nonatomic, strong) NSString * activityName;
@property (nonatomic, strong) NSString * smallPicId;

@end
