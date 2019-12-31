//
//  BaseModel.h
//  Express
//
//  Created by Zero on 14-10-30.
//  Copyright (c) 2014年 Zero. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BaseModel : NSObject

- (id)initWithDic:(NSDictionary*)dic;
+ (id)initWithArray:(NSArray*)array;
- (NSDictionary*)toDictionary;
+ (NSArray*)toDictionaryWithArray:(NSArray*)array;

@end
