//
//  TYMenuViewController.m
//  TianYi_Spark
//
//  Created by 曹 胜全 on 3/31/14.
//  Copyright (c) 2014 曹 胜全. All rights reserved.
//

#import "TYMenuViewController.h"
#import <objc/runtime.h>


@interface TYMenuViewController ()
{
    UIImageView *bgImageIv;
    CGAffineTransform transform;
    CGAffineTransform bottomTransform;
}

@property (nonatomic, strong, readwrite) UIViewController *rootViewController;
@property (nonatomic, strong, readwrite) UIViewController *bottomViewController;
@property (nonatomic, strong, readwrite) UIViewController *topViewController;

@end


@interface UIViewController (TYMenuViewControllerPrivate)

- (void) setMenuViewController:(TYMenuViewController *)menuViewController_;

@end

@implementation TYMenuViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    bgImageIv = [[UIImageView alloc] initWithFrame:self.view.bounds];
    if (_backgroundImageName != nil) {
        [bgImageIv setImage:[UIImage imageNamed:_backgroundImageName]];
    }
    [self.view addSubview:bgImageIv];
    
    transform = CGAffineTransformMakeTranslation(220, 0);
}

- (void) setBackgroundImageName:(NSString *)backgroundImageName
{
    if (_backgroundImageName != backgroundImageName) {
        _backgroundImageName = backgroundImageName;
        if (bgImageIv) {
            [bgImageIv setImage:[UIImage imageNamed:_backgroundImageName]];
        }
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (id) initWithBottomViewController:(UIViewController *) bottomVc andRootViewController:(UIViewController *) rootVc
{
    self = [super init];
    if (self) {
        self.bottomViewController = bottomVc;
        self.rootViewController = rootVc;
        viewControllers = [NSMutableArray new];
    }
    return self;
}

- (void) setBottomViewController:(UIViewController *)bottomViewController
{
    if (_bottomViewController != bottomViewController) {
        
        [_bottomViewController removeFromParentViewController];
        [_bottomViewController.view removeFromSuperview];

        _bottomViewController = bottomViewController;
        [self addChildViewController:_bottomViewController];
        _bottomViewController.view.frame = self.view.bounds;
        [self.view addSubview:_bottomViewController.view];
        _bottomViewController.menuViewController = self;
        self.bottomViewController.view.transform = bottomTransform;
    }
}

- (void) setRootViewController:(UIViewController *)rootViewController
{
    if (_rootViewController != rootViewController) {
        
        _rootViewController = rootViewController;
        [self addChildViewController:_rootViewController];
        [self.view addSubview:self.rootViewController.view];
        
        self.topViewController = _rootViewController;
        
    }
}

- (void) setTopViewController:(UIViewController *)topViewController
{
    if (_topViewController != topViewController) {
        [_topViewController removeObserver:self forKeyPath:@"view.transform" context:NULL];

        
        if (_topViewController != nil) {
            CGAffineTransform currentTransform = _topViewController.view.transform;
            topViewController.view.transform = currentTransform;
        }
        
        _topViewController = topViewController;
        [_topViewController addObserver:self forKeyPath:@"view.transform" options:NSKeyValueObservingOptionNew context:NULL];
        [self addChildViewController:_topViewController];
        [self.view addSubview:self.topViewController.view];
        
        _topViewController.menuViewController = self;
    }
}

- (void) pushNewViewController:(UIViewController *) newViewController animated:(BOOL) animated completion:(void(^)()) completionBlock;
{
    [viewControllers addObject:newViewController];
    self.topViewController = newViewController;
    
    if (CGAffineTransformIsIdentity(self.topViewController.view.transform)) {
        [self transformTopViewController:transform druation:0.2];
    }else
        [self transformTopViewController:CGAffineTransformIdentity druation:0.2];
}


- (void) replaceRootViewControllerWithNewController:(UIViewController *) newRootViewController animate:(BOOL) animated completion:(void(^)()) completionBlock;
{
    if (_rootViewController != newRootViewController) {
        if (_rootViewController != nil) {
            [viewControllers removeObject:_rootViewController];
            [_rootViewController.view removeFromSuperview];
        }
        newRootViewController.view.frame = _rootViewController.view.frame;
        self.rootViewController = newRootViewController;
        [viewControllers insertObject:_rootViewController atIndex:0];
        
        [self transformTopViewController:transform druation:0.2];
    }
}

- (void) popCurrentTopViewControllerAnimate:(BOOL)animated
{
    if (CGAffineTransformIsIdentity(self.topViewController.view.transform)) {
        [self transformTopViewController:transform druation:0.2];
    }else
        [self transformTopViewController:CGAffineTransformIdentity druation:0.2];
}

- (void) popToViewController:(UIViewController *) viewController animated:(BOOL)animated
{
    NSInteger index = [viewControllers indexOfObject:viewController];
    while ([viewControllers count] > index) {
        [viewControllers removeLastObject];
    }
    
    if (index == NSNotFound) {
        [viewControllers addObject:viewController];
    }
    self.topViewController = viewController;
    [self popCurrentTopViewControllerAnimate:animated];
}


- (void) observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"view.transform"]) {
        
        CGAffineTransform newTransform = [[change objectForKey:NSKeyValueChangeNewKey] CGAffineTransformValue];
        [self transformBottomViewControllerWithAffineTransform:newTransform];
        
    }else
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
}


- (void) transformBottomViewControllerWithAffineTransform:(CGAffineTransform) aTransform
{
    if (CGAffineTransformIsIdentity(aTransform)) {
        [UIView animateWithDuration:0.2 delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
            self.bottomViewController.view.transform = bottomTransform;
        } completion:^(BOOL finished) {
            
        }];
    }else{
        
        [UIView animateWithDuration:0.2 delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
            self.bottomViewController.view.transform = CGAffineTransformIdentity;
        } completion:^(BOOL finished) {
            
        }];
    }
}

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}


- (void) transformTopViewController:(CGAffineTransform) aTransform druation:(NSTimeInterval) duration
{
    [UIView animateWithDuration:duration delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
        self.topViewController.view.transform = aTransform;  //transform;
        
    } completion:^(BOOL finished) {
        
    }];

}


- (void) restoreframeRootViewControllerDuration:(CGFloat) duration
{
    [UIView animateWithDuration:duration delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
        self.rootViewController.view.frame = self.view.bounds;
    } completion:^(BOOL finished) {
        
    }];
}


@end



@implementation UIViewController (TYMenuViewController)

static char menuViewControllerKey;

- (void) setMenuViewController:(TYMenuViewController *)menuViewController_
{
    [self willChangeValueForKey:@"menuViewController"];
    objc_setAssociatedObject( self,
                             &menuViewControllerKey,
                             menuViewController_,
                             OBJC_ASSOCIATION_ASSIGN );
    [self didChangeValueForKey:@"menuViewController"];
}

- (TYMenuViewController*) menuViewController {
    id controller = objc_getAssociatedObject( self,
                                             &menuViewControllerKey );
    
    if (!controller && self.navigationController)
        controller = self.navigationController.menuViewController;
    
    if (!controller && self.tabBarController)
        controller = self.tabBarController.menuViewController;
    return controller;
}

@end


