//
//  HsBKMapViewController.h
//  FastRun
//
//  Created by Macbook on 16/3/10.
//  Copyright © 2016年 SIMPLE PLAN. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@interface HsBKMapViewController : UIView


@property (nonatomic) CLLocationCoordinate2D sendCoor;
@property (nonatomic) CLLocationCoordinate2D recodeCoor;

@property (nonatomic) CLLocationCoordinate2D xpeople;
@property (nonatomic) CLLocationCoordinate2D ypeople;

//点击地图
@property (copy, nonatomic) void(^onClickedMap)(BOOL selected);

-(void)setup;
-(void)creatMap;
@end
