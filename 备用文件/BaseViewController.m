//
//  BaseViewController.m
//  TianYiHealthy
//
//  Created by kevin on 14-6-25.
//  Copyright (c) 2014年 kevin.zhang. All rights reserved.
//

#import "BaseViewController.h"
#import "TYMenuViewController.h"

@interface BaseViewController ()

@property (nonatomic, strong) NSArray *serArr;

@end

@implementation BaseViewController
{
    CGPoint _beginPoint;
    CGPoint _movePoint;
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        if([[UIDevice currentDevice].systemVersion floatValue] >= 7.0)
        {
            self.edgesForExtendedLayout = UIRectEdgeNone;
        }
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    if ([self respondsToSelector:@selector(edgesForExtendedLayout)]) {
//        self.edgesForExtendedLayout = UIRectEdgeNone;
//    }
    
    UIBarButtonItem *left = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"bt_back_up"] style:UIBarButtonItemStyleBordered target:self action:@selector(toBack:)];
    left.imageInsets = UIEdgeInsetsMake(0, -10, 0, 0);
    self.navigationItem.leftBarButtonItem = left;
    
    
    
    if(!_supportScrollPop)
    {
        UIPanGestureRecognizer *recognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(scrollPop:)];
        [self.view addGestureRecognizer:recognizer];
    }
}

- (void)toBack:(id)sender
{
    if (_trans) {
        [self.menuViewController popCurrentTopViewControllerAnimate:NO];
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)serviceArr
{
    UserInfo *userInfo = [AppDelegate sharedAppDelegate].loginUser;
    NSDictionary *param = @{@"userId": userInfo.order_id};
    [[SFHttpRequest sharedHttpRequest] query:param queryType:@"345" completionBlock:^(ASIHTTPRequest *request, NSData *reponseData, NSError *error) {
        id obj = [HHTool decodeReponseData:reponseData toView:self.view];
        if (obj != nil) {
            _serArr = obj[@"service"];
        }
    } failedBlock:^(ASIHTTPRequest *request, NSError *error) {
        
    }];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)scrollPop:(id)sender
{
    if([sender isKindOfClass:[UIPanGestureRecognizer class]])
    {
        UIPanGestureRecognizer *gesture = (UIPanGestureRecognizer *)sender;
        if(gesture.state == UIGestureRecognizerStateBegan)
        {
            _beginPoint = [gesture locationInView:gesture.view];
        }
        else if (gesture.state == UIGestureRecognizerStateChanged)
        {
            _movePoint = [gesture locationInView:gesture.view];
            if(_movePoint.x > (_beginPoint.x + 20))
            {
                [self.navigationController popViewControllerAnimated:YES];
            }
        }
    }
}

//判断是否可以横屏？现在的设置是固定的 不支持旋转
- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
