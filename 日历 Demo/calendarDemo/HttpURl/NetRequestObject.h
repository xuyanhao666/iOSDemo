//
//  NetRequestObject.h
//  JSZJ_PA_iPhone
//
//  Created by prbk on 17/9/22.
//  Copyright © 2017年 primb. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef void (^NetFinishBlock) (BOOL success,NSDictionary * dataDic);

@interface NetRequestObject : NSObject
#pragma mark 数据请求
+(void)netRequestWithURL:(NSString *) urlStr
           andParameters:(NSDictionary *) paraDic
        andFinishedBlock:(NetFinishBlock) block;


@end
