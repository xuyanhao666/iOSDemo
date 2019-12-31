//
//  DanLi.m
//  单例传值
//
//  Created by zyx on 16/3/19.
//  Copyright © 2016年 zyx. All rights reserved.
//

#import "DanLi.h"

static DanLi *danli = nil;

@implementation DanLi

//实现方法,判断是否为空,是就创建一个全局实例给它
+ (DanLi *)sharedDanLi {
    
    if (danli == nil) {
        danli = [[DanLi alloc] init];
    }
    return danli;
}

//避免alloc/new创建新的实例变量--->增加一个互斥锁
+ (id)allocWithZone:(struct _NSZone *)zone {
    
    @synchronized(self) {
        if (danli == nil) {
            danli = [super allocWithZone:zone];
        }
    }
    return danli;
}

//避免copy,需要实现NSCopying协议
- (id)copyWithZone:(NSZone *)zone {
    return self;
}


@end
