//
//  cellModel.m
//  cellOpenAndCloseDemo
//
//  Created by primb_xuyanhao on 2018/12/25.
//  Copyright © 2018 Primb. All rights reserved.
//

#import "cellModel.h"

@implementation cellModel

- (instancetype)initWithDict:(NSDictionary *)info{
    self = [super init];
    if (self) {
        self.poisArr = info[@"sub"];
    }
    return self;
}

@end
