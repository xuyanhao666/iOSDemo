//
//  footerView.h
//  xibDemo
//
//  Created by szyl on 16/5/20.
//  Copyright © 2016年 szyl. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface footerView : UIView
@property (weak, nonatomic) IBOutlet UILabel *myLabel;
+(instancetype)loadFromXib;
@end
