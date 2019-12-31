//
//  footerView.m
//  xibDemo
//
//  Created by szyl on 16/5/20.
//  Copyright © 2016年 szyl. All rights reserved.
//

#import "footerView.h"

@implementation footerView
-(void)awakeFromNib{
    self.myLabel.text = @"haha";
    self.myLabel.textColor = [UIColor redColor];
    self.backgroundColor = [UIColor yellowColor];
}
+(instancetype)loadFromXib{
    return [[[NSBundle mainBundle]loadNibNamed:@"footerView" owner:nil options:nil] lastObject];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
