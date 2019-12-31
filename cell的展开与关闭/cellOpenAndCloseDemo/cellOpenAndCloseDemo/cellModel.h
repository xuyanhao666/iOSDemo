//
//  cellModel.h
//  cellOpenAndCloseDemo
//
//  Created by primb_xuyanhao on 2018/12/25.
//  Copyright © 2018 Primb. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface cellModel : NSObject
/**
 *  是否显示
 */
@property (nonatomic,assign) BOOL isShow;
/**
 *  显示的数组
 */
@property (nonatomic,strong) NSArray *poisArr;
/**
 *  快速创建数据
 */
-(instancetype)initWithDict:(NSDictionary *)info;

@end

NS_ASSUME_NONNULL_END
