//
//  SZAddImage.h
//  bbting
//
//  Created by PureMedia on 16/2/26.
//  Copyright © 2016年 yangJunjie. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 * 使用说明:直接创建此view添加到你需要放置的位置即可.
 * 属性images可以获取到当前选中的所有图片对象.
 
 俊杰特别提示：实例化的SZAddImage的size尽量写的大一点（九宫格的大小，不能是一张图片的大小）
 如下：
 SZAddImage *view = [[SZAddImage alloc]init];
 view.frame = CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height);
 [self.view addSubview:view];
 */

@interface SZAddImage : UIView

/**
 *  存储所有的照片(UIImage)
 */
@property (nonatomic, strong) NSMutableArray *images;

@end
