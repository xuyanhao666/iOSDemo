//
//  ViewController.m
//  practiceDemo
//
//  Created by 许艳豪 on 15/8/7.
//  Copyright (c) 2015年 ideal_Mac. All rights reserved.
//

#import "ViewController.h"
#import "MBProgressHUD+MJ.h"
#import "MJRefresh.h"

#define screenHight [UIScreen mainScreen].bounds.size.height

@interface ViewController ()<UITextViewDelegate,UITextFieldDelegate,ViewPagerDataSource,ViewPagerDelegate>
@property (nonatomic, strong) NSArray *titleArr;
@property (nonatomic, strong) UILabel *label;
@property (nonatomic, strong) UILabel *label2;
@property (nonatomic, strong) UILabel *label3;
@property (nonatomic, strong) UILabel *label4;
@property (nonatomic, strong) UILabel *label5;

@property (nonatomic, strong) UITextView *textView;
@property (nonatomic, strong) UIButton *btn;


@end

@implementation ViewController
- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
//        self.navigationItem.titleView = [HHTool naviTitle:@"组织"];
        self.navigationItem.title = @"test";
    }
    
    return self;
}

- (void)viewDidLoad {
    // Do any additional setup after loading the view, typically from a nib.
    
//   [UIScreen mainScreen].bounds.size.height;
    
//    UILabel *mylabel = [[UILabel alloc] init];
//    mylabel.adjustsFontSizeToFitWidth = YES;
//    _textView = [UITextView new];
//    _textView.delegate = self;
//    
//    [self.view addSubview:_textView];
//    
//    _btn = [[UIButton alloc] initWithFrame:CGRectMake(100, 500, 100, 100)];
//    _btn.backgroundColor = [UIColor yellowColor];
//    [self.view addSubview:_btn];
//    
//    [_btn addTarget:self action:@selector(clickBtn) forControlEvents:UIControlEventTouchUpInside];
    
    self.delegate = self;
    self.dataSource = self;
    
    [MBProgressHUD showMessage:@"快出来" toView:self.view];
    _titleArr = @[@"one",@"two"];
    self.tabWidth = self.view.frame.size.width/2;
    [super viewDidLoad];

}
-(void)viewWillAppear:(BOOL)animated{
    [MBProgressHUD hideHUDForView:self.view];
    [super viewWillAppear:animated];
    
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [MBProgressHUD showSuccess:@"展示成功"];
}
-(NSUInteger)numberOfTabsForViewPager:(ViewPagerController *)viewPager{
    return 2;
}
-(UIView *)viewPager:(ViewPagerController *)viewPager viewForTabAtIndex:(NSUInteger)index{
    
    UILabel *temLabel = [[UILabel alloc] init];
    if (index == 0) {
        _label = [UILabel new];
        _label.tag = index;
        _label.backgroundColor = [UIColor clearColor];
        _label.font = [UIFont systemFontOfSize:17.0f];
        _label.textAlignment = NSTextAlignmentCenter;
        
        _label.textColor = [UIColor colorWithRed:20.0/255 green:168.0/255 blue:178.0/255 alpha:1];
        
        _label.text = [NSString stringWithFormat:@"%@",_titleArr[index]];
        [_label sizeToFit];
        temLabel = _label;
    }
    if (index == 1) {
        _label2 = [UILabel new];
        _label2.tag = index;
        _label2.backgroundColor = [UIColor clearColor];
        _label2.font = [UIFont systemFontOfSize:17.0f];
        _label2.textAlignment = NSTextAlignmentCenter;
        
        _label2.textColor = [UIColor colorWithRed:20.0/255 green:168.0/255 blue:178.0/255 alpha:1];
        
        _label2.text = [NSString stringWithFormat:@"%@",_titleArr[index]];
        [_label2 sizeToFit];
        temLabel = _label2;
    }
    if (index == 2) {
        _label3 = [UILabel new];
        _label3.tag = index;
        _label3.backgroundColor = [UIColor clearColor];
        _label3.font = [UIFont systemFontOfSize:17.0f];
        _label3.textAlignment = NSTextAlignmentCenter;
        
        _label3.textColor = [UIColor colorWithRed:20.0/255 green:168.0/255 blue:178.0/255 alpha:1];
        
        _label3.text = [NSString stringWithFormat:@"%@",_titleArr[index]];
        [_label3 sizeToFit];
        temLabel = _label3;
    }
    if (index == 3) {
        _label4 = [UILabel new];
        _label4.tag = index;
        _label4.backgroundColor = [UIColor clearColor];
        _label4.font = [UIFont systemFontOfSize:17.0f];
        _label4.textAlignment = NSTextAlignmentCenter;
        
        _label4.textColor = [UIColor colorWithRed:20.0/255 green:168.0/255 blue:178.0/255 alpha:1];
        
        _label4.text = [NSString stringWithFormat:@"%@",_titleArr[index]];
        [_label4 sizeToFit];
        temLabel = _label4;
    }
    
    return temLabel;
    
}

//-(UILabel*)createLabelWithString:(NSString *)string{
//    UILabel *label = [[UILabel alloc]init];
//    label.text = string;
//    label.backgroundColor = [UIColor clearColor];
//    label.font = [UIFont systemFontOfSize:15.0f];
//    label.textAlignment = NSTextAlignmentCenter;
//    label.textColor = [UIColor colorWithRed:20.0/255 green:168.0/255 blue:178.0/255 alpha:1];
//    
//    
//    [label sizeToFit];
//    return label;
//}

- (UIViewController *)viewPager:(ViewPagerController *)viewPager contentViewControllerForTabAtIndex:(NSUInteger)index{
    id vc;
//    if (index == 0) {
//        vc = _GKVC;
//    }
//    if (index == 1) {
//        vc = _GGVC;
//    }
//    if (index == 2) {
//        vc = _HDVC;
//    }
//    if (index == 3) {
//        vc = _examAc;
//    }
    if (index == 0) {
        UIViewController *view1 = [[UIViewController alloc] init];
        view1.view.backgroundColor = [UIColor yellowColor];
        vc = view1;
    }
    if (index == 1) {
        UIViewController *view2 = [[UIViewController alloc] init];
        view2.view.backgroundColor = [UIColor redColor];
        vc = view2;
    }
    return vc;
}

- (CGFloat)viewPager:(ViewPagerController *)viewPager valueForOption:(ViewPagerOption)option withDefault:(CGFloat)value
{
    switch (option) {
        case ViewPagerOptionStartFromSecondTab:
            return 0.0;
            break;
        case ViewPagerOptionCenterCurrentTab:
            return 1.0;
            break;
        case ViewPagerOptionTabLocation:
            return 1.0;
            break;
        default:
            break;
    }
    
    return value;
}

- (UIColor *)viewPager:(ViewPagerController *)viewPager colorForComponent:(ViewPagerComponent)component withDefault:(UIColor *)color
{
    switch (component) {
        case ViewPagerIndicator:
//            return [UIColor colorWithRed:20.0/255 green:168.0/255 blue:178.0/255 alpha:1];
            return [UIColor greenColor];
            break;
        default:
            break;
    }
    
    return color;
}
- (void)viewPager:(ViewPagerController *)viewPager didChangeTabToIndex:(NSUInteger)index{
    if (index == _label.tag) {
        _label.textColor = [UIColor colorWithRed:20.0/255 green:168.0/255 blue:178.0/255 alpha:1];
        _label2.textColor = [UIColor darkGrayColor];
    }else{
        _label2.textColor = [UIColor colorWithRed:20.0/255 green:168.0/255 blue:178.0/255 alpha:1];
        
        _label.textColor = [UIColor darkGrayColor];
    }
    switch (index) {
        case 0:
        {
            _label.textColor = [UIColor colorWithRed:20.0/255 green:168.0/255 blue:178.0/255 alpha:1];
            _label2.textColor = [UIColor darkGrayColor];
            _label3.textColor = [UIColor darkGrayColor];
            _label4.textColor = [UIColor darkGrayColor];
            _label5.textColor = [UIColor darkGrayColor];
            
            
            
        }
            break;
        case 1:
        {
            _label2.textColor = [UIColor colorWithRed:20.0/255 green:168.0/255 blue:178.0/255 alpha:1];
            _label.textColor = [UIColor darkGrayColor];
            _label3.textColor = [UIColor darkGrayColor];
            _label4.textColor = [UIColor darkGrayColor];
            _label5.textColor = [UIColor darkGrayColor];
            
            
        }
            break;
            
        case 2:
        {
            _label3.textColor = [UIColor colorWithRed:20.0/255 green:168.0/255 blue:178.0/255 alpha:1];
            _label.textColor = [UIColor darkGrayColor];
            _label2.textColor = [UIColor darkGrayColor];
            _label4.textColor = [UIColor darkGrayColor];
            _label5.textColor = [UIColor darkGrayColor];
            
        }
            break;
            
        case 3:
        {
            _label4.textColor = [UIColor colorWithRed:20.0/255 green:168.0/255 blue:178.0/255 alpha:1];
            _label.textColor = [UIColor darkGrayColor];
            _label3.textColor = [UIColor darkGrayColor];
            _label2.textColor = [UIColor darkGrayColor];
            _label5.textColor = [UIColor darkGrayColor];
            
        }
            break;
        case 4:
        {
            _label5.textColor = [UIColor colorWithRed:20.0/255 green:168.0/255 blue:178.0/255 alpha:1];
            _label.textColor = [UIColor darkGrayColor];
            _label3.textColor = [UIColor darkGrayColor];
            _label4.textColor = [UIColor darkGrayColor];
            _label2.textColor = [UIColor darkGrayColor];
            
        }
            break;
            
            
        default:
            break;
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
