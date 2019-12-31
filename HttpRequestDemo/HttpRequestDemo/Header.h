//
//  Header.h
//  HttpRequestDemo
//
//  Created by szyl on 16/6/6.
//  Copyright © 2016年 xyh. All rights reserved.
//

#ifndef Header_h
#define Header_h

#define WS(weakSelf)  __weak __typeof(&*self)weakSelf = self

#define ScreenWidth [UIScreen mainScreen].bounds.size.width
#define ScreenHeight [UIScreen mainScreen].bounds.size.height

#define SAFE_STRING(string) (string != nil) ? (string) : (string = @"")

#endif /* Header_h */
