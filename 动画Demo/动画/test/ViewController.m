//
//  ViewController.m
//  test
//
//  Created by 许艳豪 on 15/10/10.
//  Copyright © 2015年 ideal_Mac. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property (nonatomic, strong) UIView *viewb;

@end

@implementation ViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blueColor];
    UIView *viewRound = [[UIView alloc]initWithFrame:CGRectMake(60, 110, 200, 200)];
    viewRound.backgroundColor = [UIColor blackColor];
    viewRound.layer.cornerRadius = 100;
    viewRound.layer.borderColor = [UIColor yellowColor].CGColor;
    viewRound.layer.borderWidth = 2.0;
    [self.view addSubview:viewRound];
    
    //
    self.viewb = [[UIView alloc]initWithFrame:CGRectMake(190, 90, 20, 20)];
    self.viewb.backgroundColor = [UIColor purpleColor];
    self.viewb.layer.cornerRadius = 10;
    [viewRound addSubview:self.viewb];
    
    UIView *viewA = [[UIView alloc]initWithFrame:CGRectMake(-10, 90, 20, 20)];
    viewA.backgroundColor = [UIColor greenColor];
    viewA.layer.cornerRadius = 10;
    [viewRound addSubview:viewA];
    UIView *viewC = [[UIView alloc]initWithFrame:CGRectMake(90, -10, 20, 20)];
    viewC.backgroundColor = [UIColor yellowColor];
    viewC.layer.cornerRadius = 10;
    [viewRound addSubview:viewC];
    UIView *viewD = [[UIView alloc]initWithFrame:CGRectMake(90, 190, 20, 20)];
    viewD.backgroundColor = [UIColor orangeColor];
    viewD.layer.cornerRadius = 10;
    [viewRound addSubview:viewD];
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:3.0];
    self.viewb.transform = CGAffineTransformMakeRotation(-2*M_PI/24.0);
//        self.viewb.center = CGPointMake(160+cos(2*M_PI/24.0)*100, 210-sin(2*M_PI/24.0)*100);
    
    [UIView commitAnimations];
    CABasicAnimation* rotationAnimation;
    rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
//    rotationAnimation = [CABasicAnimation animationWithKeyPath:@"rotation.z"];
    rotationAnimation.toValue = [NSNumber numberWithFloat: M_PI * 2.0 ];
    
    //default RotationDuration value
    
    rotationAnimation.duration = 10;
    rotationAnimation.repeatCount = FLT_MAX;
    rotationAnimation.cumulative = NO;
    [viewRound.layer addAnimation:rotationAnimation forKey:nil];
    
//    NSString *string = @"192.168.1.1";
//    string = [string stringByReplacingOccurrencesOfString:@"." withString:@""];
//    NSLog(@"%@",string);
    //    self.bannerView = [[ADBannerView alloc]initWithFrame:
    //                  CGRectMake(0, 0, 320, 50)];
    //    self.bannerView.delegate = self;
    //    // Optional to set background color to clear color
    //    [self.bannerView setBackgroundColor:[UIColor clearColor]];
    //    [self.view addSubview: self.bannerView];
    
    //   UMUFPBannerView * banner = [[UMUFPBannerView alloc] initWithFrame:CGRectMake(0, 44, 320, 50) appKey:@"53faa493fd98c5fea803481a" slotId:nil currentViewController:self];
    //    [self.view addSubview:banner];
    //    [banner requestPromoterDataInBackground];
    //
    //    Class cls = NSClassFromString(@"UMANUtil");
    //    SEL deviceIDSelector = @selector(openUDIDString);
    //    NSString *deviceID = nil;
    //    if(cls && [cls respondsToSelector:deviceIDSelector]){
    //        deviceID = [cls performSelector:deviceIDSelector];
    //    }
    //    NSLog(@"{\"oid\": \"%@\"}", deviceID);
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
