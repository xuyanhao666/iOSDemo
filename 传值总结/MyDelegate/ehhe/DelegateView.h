//
//  DelegateView.h
//  ehhe
//
//  Created by 许艳豪 on 15/12/9.
//  Copyright © 2015年 ideal_Mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol tempDelegate <NSObject>

- (void)transValue:(NSString *)strValue;

@end

@interface DelegateView : UIView
@property (nonatomic, weak) id<tempDelegate> delegate;
@end
