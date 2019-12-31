//
//  LISliderHeaderView.h
//  LIGHTinvesting
//
//  Created by hundsun on 15/11/30.
//  Copyright © 2015年 Hundsun. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol LISliderHeaderViewDelegate <NSObject>
- (void)switchPageByIndex:(NSInteger)index;
@end

@interface LISliderHeaderView : UIView

@property (nonatomic, weak) id<LISliderHeaderViewDelegate> delegate;

@end
