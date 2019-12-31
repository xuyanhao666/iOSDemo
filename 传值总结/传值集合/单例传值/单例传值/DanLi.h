//
//  DanLi.h
//  单例传值
//
//  Created by zyx on 16/3/19.
//  Copyright © 2016年 zyx. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DanLi : NSObject

//创建一个单例//如果在单线程里可以用nonatomic,如果在多线程里一定要用atomic,保证是只有一个在调用,不然在多线程里面如果多个方法调用修改单例类里的属性时会冲突
@property (atomic, copy) NSString *value;

+ (DanLi *)sharedDanLi;

@end
