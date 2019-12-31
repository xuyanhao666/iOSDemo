//
//  VBPiePiece.h
//  Charts
//
//  Created by Volodymyr Boichentsov on 15/02/2014.
//  Copyright (c) 2014 SAKrisT. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

@interface VBPiePiece : CAShapeLayer

@property (nonatomic) float innerRadius;
@property (nonatomic) float outerRadius;

@property (nonatomic) double value;

@property (nonatomic, readonly) float angle;
@property (nonatomic, readonly) float startAngle;

// Default is NO
@property (nonatomic, readonly) BOOL accent;

// Default is 0.1 (i.e. 10%) of innerRadius
@property (nonatomic) float accentPrecent;


- (BOOL) animateToAccent:(float)accentPrecent;

- (void) pieceAngle:(float)angle start:(float)startAngle;


@end

// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com 
