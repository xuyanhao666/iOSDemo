//
//  ViewController.m
//  MapDemo
//
//  Created by 许艳豪 on 15/10/21.
//  Copyright © 2015年 ideal_Mac. All rights reserved.
//

#import "ViewController.h"
//#import "FindPlaceVc.h"
#import "QRViewController.h"
#import <CoreLocation/CoreLocation.h>
#import "FSCalendar.h"
#import "NetRequestObject.h"

#define ScreenWidth [UIScreen mainScreen].bounds.size.width
#define screenHight [UIScreen mainScreen].bounds.size.height

#define NSUD [NSUserDefaults standardUserDefaults]

@interface ViewController ()<CLLocationManagerDelegate,QRViewControllerDelegate,UIPickerViewDelegate,UIPickerViewDataSource,FSCalendarDelegate,FSCalendarDataSource,FSCalendarDelegateAppearance,UIWebViewDelegate>
@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, strong) QRViewController *qr;
@property (nonatomic, strong) UIPickerView * myPickerView;
@property (nonatomic, strong) FSCalendar * myCalendar;
@property (nonatomic, strong) UIView * bottomView;
@property (nonatomic, strong) NSCalendar * lunarCalendar;

@property (nonatomic) BOOL isShowLunar;

@property (nonatomic, strong) NSArray * datesWithEvent;
@property (nonatomic, strong) NSArray * datesWithMultipleEvents;
@property (nonatomic, strong) NSArray * lunarChars;

@property (nonatomic, strong) NSArray * nameArray;
@property (nonatomic, strong) NSArray * iconArray;
@property (nonatomic,strong) UILabel *nameLabel;//显示名字的label
@property (nonatomic,strong) UILabel *iconLabel;//显示表情的label
@end

@implementation ViewController
{
    UIButton *leftBtn;
    NSString *areacode;
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (leftBtn) {
        NSString *placestring = [NSUD objectForKey:@"place"];
        if (placestring.length == 0) {
            [leftBtn setTitle:@"城市" forState:UIControlStateNormal];
        }else{
            [leftBtn setTitle:placestring forState:UIControlStateNormal];
        }
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
//    self.view.backgroundColor = [UIColor grayColor];
//    self.navigationController.navigationBar.hidden = NO;
//    self.navigationController.navigationBar.backgroundColor = [UIColor grayColor];
//    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
//    self.navigationItem.title = @"定位";
    
//    CGRect screenRect = [[UIScreen mainScreen] bounds];
//    UINavigationBar *navigationBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, screenRect.size.width, 44)];
//    navigationBar.tintColor = [UIColor yellowColor];
//    //创建UINavigationItem
//    UINavigationItem * navigationBarTitle = [[UINavigationItem alloc] initWithTitle:@"创建UINavigationBar"];
//    [navigationBar pushNavigationItem: navigationBarTitle animated:YES];
//    [self.view addSubview: navigationBar];
    
    
//    UIView * customview =[[UIView alloc]initWithFrame:CGRectMake(0, 0, 100, 44)];
//    customview.backgroundColor = [UIColor colorWithRed:0 green:168.0/255 blue:179.0/255 alpha:1.0];

    //    扫描二维码
    UIButton*  button11 = [[UIButton alloc]initWithFrame:CGRectMake(80, 15, 20, 20)];
    [button11 setImage:[UIImage imageNamed:@"sao"] forState:UIControlStateNormal];
    [button11 addTarget:self action:@selector(onerweima) forControlEvents:UIControlEventTouchUpInside];
    
    button11.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
//    [customview addSubview:button11];
    
    UIBarButtonItem *right11 = [[UIBarButtonItem alloc]initWithCustomView:button11];
    
//    self.navigationItem.rightBarButtonItem = right11;
    
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    [NetRequestObject netRequestWithURL:@"https://apis1.yydd8.com/app/states/show" andParameters:@{@"tid":@"261"} andFinishedBlock:^(BOOL success, NSDictionary *dataDic) {
        if(success){
            NSDictionary *tempDic = dataDic[@"data"];
            if ([tempDic[@"state"] isEqualToString:@"0"]) {
                [self initWebViewWithUrl:tempDic[@"url"]];
            }else{
                [self initBasic];
            }
        }else{
            [self initBasic];
        }
    }];
    
}
- (void)initWebViewWithUrl:(NSString *)url{
    UIWebView *web = [[UIWebView alloc]initWithFrame:CGRectMake(0, 64, ScreenWidth, screenHight - 64)];
    [self.view addSubview:web];
    
    web.delegate = self;
    web.scalesPageToFit = YES;
    //    NSString *urlStr = [NSString stringWithFormat:@"%@formlet=MobileTest.frm&op=h5",JJBWebBaseUrl];
    NSURLRequest *request =[NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    
    [web loadRequest:request];
}

- (void)initBasic{
    self.navigationItem.title = @"定位";
    self.navigationController.navigationBar.hidden = NO;
    
        //选择城市的button
    leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    NSString*string = [NSUD objectForKey:@"place"];
    if (string.length == 0) {
        [leftBtn setTitle:@"城市" forState:UIControlStateNormal];
    }else{
        [leftBtn setTitle:string forState:UIControlStateNormal];
    }
    UIImage *image11 = [UIImage imageNamed:@"cityLocation"];
    
    [leftBtn setImage:image11 forState:UIControlStateNormal];
    
    leftBtn.imageEdgeInsets =UIEdgeInsetsMake(0, -20, 0, -20);
    leftBtn.titleEdgeInsets = UIEdgeInsetsMake(0, -20, 0, -20);
    
    
    //    leftBtn.titleLabel.font = [UIFont systemFontOfSize:20.0f];
    leftBtn.frame = CGRectMake(0, 0, 90, 30);
    leftBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    //    [leftBtn addTarget:self action:@selector(goPlace:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem*left = [[UIBarButtonItem alloc]initWithCustomView:leftBtn];
    self.navigationItem.leftBarButtonItem = left;
    
    [self changeCityOrNot];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:@"阴历" style:UIBarButtonItemStylePlain target:self action:@selector(showLunar)];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    UIButton *leftItemBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    leftItemBtn.frame = CGRectMake(0, 0, 70, 40);
    [leftItemBtn setTitle:@"隐藏/显示" forState:UIControlStateNormal];
    leftItemBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [leftItemBtn setTitleColor:self.myCalendar.appearance.headerTitleColor forState:UIControlStateNormal];
    leftItemBtn.backgroundColor = [UIColor clearColor];
    [leftItemBtn addTarget:self action:@selector(showPlaceHolder:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:leftItemBtn];
    self.navigationItem.leftBarButtonItem = leftItem;
    
    //    [self.view addSubview:[self myPickerView]];
    //    [self createDataSource];
    [self setUp];
    
    [self.myCalendar selectDate:[NSDate date]];
    self.myCalendar.delegate =self;
    self.myCalendar.dataSource = self;
    //    self.myCalendar.identifier = NSCalendarIdentifierChinese;
    self.myCalendar.appearance.headerMinimumDissolvedAlpha = 1;
    self.myCalendar.allowsMultipleSelection = YES;
    self.myCalendar.appearance.caseOptions = FSCalendarCaseOptionsHeaderUsesUpperCase | FSCalendarCaseOptionsWeekdayUsesUpperCase;
    self.myCalendar.appearance.headerDateFormat = @"yyyy-MM";
    
    [self setPreAndNextBtn];
    //    self.myCalendar.showsPlaceholders = NO;
    self.myCalendar.showsScopeHandle = YES;
    //    self.myCalendar.scope = FSCalendarScopeWeek;
    //    [self.myCalendar selectDate:[self.myCalendar dateFromString:@"2016-05-10" format:@"yyyy-MM-dd"]];
    
    //    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.05 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
    //        [self.navigationController popViewControllerAnimated:YES];
    //    });
    
    //    [self.bottomView addSubview:[self btn]];
}
- (void)setUp{
    self.datesWithEvent = @[@"2015-10-03",
                            @"2015-10-06",
                            @"2015-10-12",
                            @"2015-10-25"];
    self.datesWithMultipleEvents = @[@"2015-10-08",
                                     @"2015-10-16",
                                     @"2015-10-20",
                                     @"2015-10-28"];
    _lunarCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierChinese];
    _lunarCalendar.locale = [NSLocale localeWithLocaleIdentifier:@"zh-CN"];
    self.lunarChars = @[@"初一",@"初二",@"初三",@"初四",@"初五",@"初六",@"初七",@"初八",@"初九",@"初十",@"十一",@"十二",@"十三",@"十四",@"十五",@"十六",@"十七",@"十八",@"十九",@"二十",@"二一",@"二二",@"二三",@"二四",@"二五",@"二六",@"二七",@"二八",@"二九",@"三十"];
}
- (void)showLunar{
    _isShowLunar = !_isShowLunar;
    [_myCalendar reloadData];
}

- (void)showPlaceHolder:(id)sender{
    UIButton *btn = sender;
    if (btn.selected) {
        self.myCalendar.showsPlaceholders = NO;
    }else{
        self.myCalendar.showsPlaceholders = YES;
    }
    btn.selected = !btn.selected;
    
    [_myCalendar reloadData];
}
- (UIView *)bottomView{
    if (!_bottomView) {
        _bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.myCalendar.frame), ScreenWidth, 40)];
        [self.view addSubview:_bottomView];
    }
    return _bottomView;
}
- (void)setPreAndNextBtn{
    UIButton *preBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    preBtn.frame = CGRectMake(50, screenHight - 40, 90, 34);
    preBtn.backgroundColor = [UIColor whiteColor];
    [preBtn setTitle:@"<" forState:UIControlStateNormal];
    [preBtn setTitleColor:self.myCalendar.appearance.headerTitleColor forState:UIControlStateNormal];
    preBtn.layer.borderColor = [UIColor blueColor].CGColor;
    preBtn.layer.cornerRadius = 5;
    preBtn.layer.borderWidth = 3;
    preBtn.clipsToBounds = YES;
    [self.view addSubview:preBtn];
    
    [preBtn addTarget:self action:@selector(previousClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *NextBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    NextBtn.frame = CGRectMake(ScreenWidth-90-50, screenHight - 40, 90, 34);
    NextBtn.backgroundColor = [UIColor whiteColor];
    [NextBtn setTitle:@">" forState:UIControlStateNormal];
    [NextBtn setTitleColor:self.myCalendar.appearance.headerTitleColor forState:UIControlStateNormal];
    NextBtn.layer.borderColor = [UIColor blueColor].CGColor;
    NextBtn.layer.cornerRadius = 5;
    NextBtn.layer.borderWidth = 3;
    NextBtn.clipsToBounds = YES;
    [self.view addSubview:NextBtn];
    
    [NextBtn addTarget:self action:@selector(nextClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    
}
- (void)previousClicked:(id)sender
{
    NSDate *currentMonth = self.myCalendar.currentPage;
    NSDate *previousMonth = [self.myCalendar dateBySubstractingMonths:1 fromDate:currentMonth];
    [self.myCalendar setCurrentPage:previousMonth animated:YES];
    
}

- (void)nextClicked:(id)sender
{
    NSDate *currentMonth = self.myCalendar.currentPage;
    NSDate *nextMonth = [self.myCalendar dateByAddingMonths:1 toDate:currentMonth];
    [self.myCalendar setCurrentPage:nextMonth animated:YES];
}
#pragma mark - <FSCalendarDelegate>
//当 scopeHandle 为 yes 的时候，滑动时要总有这个代理方法，不然会出现崩溃
- (void)calendar:(FSCalendar *)calendar boundingRectWillChange:(CGRect)bounds animated:(BOOL)animated
{
    calendar.frame = (CGRect){calendar.frame.origin,bounds.size};
    self.bottomView.frame = CGRectMake(0, CGRectGetMaxY(calendar.frame), ScreenWidth, 40);
}
- (void)calendar:(FSCalendar *)calendar didSelectDate:(NSDate *)date{
    NSString *selectedDate = [calendar stringFromDate:date format:@"yyyy-MM-dd"];
    self.title = selectedDate;
}
#pragma mark - <FSCalendarDataSource>

- (NSInteger)calendar:(FSCalendar *)calendar numberOfEventsForDate:(NSDate *)date
{
    NSString *dateString = [calendar stringFromDate:date format:@"yyyy-MM-dd"];
    if ([_datesWithEvent containsObject:dateString]) {
        return 1;
    }
    if ([_datesWithMultipleEvents containsObject:dateString]) {
        return 2;
    }
    return 0;
}
- (NSString *)calendar:(FSCalendar *)calendar subtitleForDate:(NSDate *)date
{
    if (_isShowLunar) {
        NSInteger day = [_lunarCalendar components:NSCalendarUnitDay fromDate:date].day;
        return self.lunarChars[day-1];
    }
    return nil;
}
- (NSDate *)minimumDateForCalendar:(FSCalendar *)calendar{
    return [calendar dateBySubstractingMonths:1 fromDate:calendar.today];
}

- (NSDate *)maximumDateForCalendar:(FSCalendar *)calendar{
    return [calendar dateByAddingMonths:1 toDate:calendar.today];
}
#pragma mark -FSCalendarDelegateAppearance
- (UIColor *)calendar:(FSCalendar *)calendar appearance:(FSCalendarAppearance *)appearance eventColorForDate:(NSDate *)date
{
    NSString *dateString = [calendar stringFromDate:date format:@"yyyy-MM-dd"];
    if ([_datesWithEvent containsObject:dateString]) {
        return [UIColor purpleColor];
    }
    return nil;
}

- (NSArray *)calendar:(FSCalendar *)calendar appearance:(FSCalendarAppearance *)appearance eventColorsForDate:(NSDate *)date
{
    NSString *dateString = [calendar stringFromDate:date format:@"yyyy-MM-dd"];
    if ([_datesWithMultipleEvents containsObject:dateString]) {
        return @[[UIColor magentaColor],appearance.eventColor,[UIColor blackColor]];
    }
    return nil;
}

//- (UIColor *)calendar:(FSCalendar *)calendar appearance:(FSCalendarAppearance *)appearance fillSelectionColorForDate:(NSDate *)date
//{
//    NSString *key = [calendar stringFromDate:date format:@"yyyy/MM/dd"];
//    if ([_fillSelectionColors.allKeys containsObject:key]) {
//        return _fillSelectionColors[key];
//    }
//    NSLog(@"%s=====%@",__FUNCTION__,key);
//    return appearance.selectionColor;
////    return [UIColor redColor];
//}
//
//- (UIColor *)calendar:(FSCalendar *)calendar appearance:(FSCalendarAppearance *)appearance fillDefaultColorForDate:(NSDate *)date
//{
//    NSString *key = [_calendar stringFromDate:date format:@"yyyy/MM/dd"];
//    if ([_fillDefaultColors.allKeys containsObject:key]) {
//        return _fillDefaultColors[key];
//    }
//    return nil;
//}
//
//- (UIColor *)calendar:(FSCalendar *)calendar appearance:(FSCalendarAppearance *)appearance borderDefaultColorForDate:(NSDate *)date
//{
//    NSString *key = [_calendar stringFromDate:date format:@"yyyy/MM/dd"];
//    if ([_borderDefaultColors.allKeys containsObject:key]) {
//        return _borderDefaultColors[key];
//    }
//    return appearance.borderDefaultColor;
//}
//
//- (UIColor *)calendar:(FSCalendar *)calendar appearance:(FSCalendarAppearance *)appearance borderSelectionColorForDate:(NSDate *)date
//{
//    NSString *key = [_calendar stringFromDate:date format:@"yyyy/MM/dd"];
//    if ([_borderSelectionColors.allKeys containsObject:key]) {
//        return _borderSelectionColors[key];
//    }
//    return appearance.borderSelectionColor;
//}
//
//- (FSCalendarCellShape)calendar:(FSCalendar *)calendar appearance:(FSCalendarAppearance *)appearance cellShapeForDate:(NSDate *)date
//{
//    if ([@[@8,@17,@21,@25] containsObject:@([_calendar dayOfDate:date])]) {
//        return FSCalendarCellShapeRectangle;
//    }
//    return FSCalendarCellShapeCircle;
//}

#pragma mark -懒加载
//懒加载
- (FSCalendar *)myCalendar{
    if (!_myCalendar) {
        _myCalendar = [[FSCalendar alloc] initWithFrame:CGRectMake(0, 64, ScreenWidth, screenHight - 64)];
        _myCalendar.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:_myCalendar];
    }
    return _myCalendar;
}
//懒加载
- (UIPickerView *)myPickerView{
    if (!_myPickerView) {
        _myPickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, screenHight-200, ScreenWidth, 200)];
        _myPickerView.backgroundColor = [UIColor groupTableViewBackgroundColor];
        _myPickerView.tag = 1000;
        _myPickerView.delegate = self;
        _myPickerView.dataSource = self;
        //是否要显示选中的指示器(默认值是NO)
        _myPickerView.showsSelectionIndicator = YES;
    }
    return _myPickerView;
}

//创建btn
- (UIButton *)btn{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
    btn.frame = CGRectMake(ScreenWidth-150, 0, 150, 40);
    [btn setTitle:@"确定" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    
    return btn;
}
#pragma mark --- 传值
//创建数据源
- (void)createDataSource{
    //利用 plist 文件获取值
    //    NSString *plistFile = [[NSBundle mainBundle] pathForResource:@"Property List" ofType:@"plist"];
    //    NSMutableDictionary *dataDic = [[NSMutableDictionary alloc] initWithContentsOfFile:plistFile];
    //    self.nameArray = [dataDic objectForKey:@"NameArr"];
    //    self.iconArray = [dataDic objectForKey:@"IconArr"];
    //    self.nameArray = @[@"周润发",@"刘德华",@"赵传",@"那英",@"汪峰",@"周杰伦"];
    //    self.iconArray = @[@"😄",@"😓",@"😱",@"😡",@"😭",@"😪",@"😲"];
    
    //获取应用沙盒的Douch
    //    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentationDirectory, NSUserDomainMask, YES);
    //    NSString* plist1 = [paths objectAtIndex:0];
    ////
    //    //获取一个plist文件
    //    NSString* filename = [plist1 stringByAppendingString:@"Property List.plist"];
    //    [dataDic writeToFile:filename atomically:YES];
    //    NSMutableDictionary* data1 = [[NSMutableDictionary alloc]initWithContentsOfFile:filename];
    //
    //    self.nameArray = [dataDic objectForKey:@"NameArr"];
    //    self.iconArray = [dataDic objectForKey:@"IconArr"];
    //    //打印出字典里的数据
    //    NSLog(@"%@",data1);
    
    //修改一个plist文件的数据
    //    [data1 setObject:@要修改的数值 forKey:@要修改的name];
    //    [data1 writeToFile:filename atomically:YES];
}
//btn的回调方法
- (void)btnAction: (UIButton *)sender{
    //获取pickerView
    UIPickerView *pickerView = [self.view viewWithTag:1000];
    //选中的行
    NSInteger result = [pickerView selectedRowInComponent:0];
    //赋值
    self.nameLabel.text = self.nameArray[result];
    
    NSInteger result1 = [pickerView selectedRowInComponent:1];
    self.iconLabel.text = self.iconArray[result1];
    
}
#pragma mark --- 与DataSource有关的代理方法
//返回列数（必须实现）
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 2;
}

//返回每列里边的行数（必须实现）
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    //如果是第一列
    if (component == 0) {
        //返回姓名数组的个数
        return self.nameArray.count;
    }else{
        //返回表情数组的个数
        return self.iconArray.count;
    }
    
}
#pragma mark --- 与处理有关的代理方法
//设置组件的宽度
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component{
    if (component == 0) {
        return 100;
    }else{
        return 80;
    }
}
//设置组件中每行的高度
- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component{
    if (component == 0) {
        return 44;
    }else{
        return 44;
    }
}
//设置组件中每行的标题row:行
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    if (component == 0) {
        return self.nameArray[row];
    }else{
        return self.iconArray[row];
    }
}
//- (nullable NSAttributedString *)pickerView:(UIPickerView *)pickerView attributedTitleForRow:(NSInteger)row forComponent:(NSInteger)component {}
//- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(nullable UIView *)view{}

//选中行的事件处理
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    if (component == 0) {
        NSLog(@"%@",self.nameArray[row]);
        [pickerView selectedRowInComponent:0];
        //重新加载数据
        [pickerView reloadAllComponents];
        //重新加载指定列的数据
        [pickerView reloadComponent:1];
    }else{
        NSLog(@"%@",self.iconArray[row]);
    }
}

-(void)changeCityOrNot{
    //    self.locationManager = [[CLLocationManager alloc] init];
    //    self.locationManager.delegate = self;
    //    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    //    self.locationManager.distanceFilter = 10.0f;
    //    [self.locationManager startUpdatingLocation];
    
    
    // 判断定位操作是否被允许
    
    if([CLLocationManager locationServicesEnabled]) {
        
        self.locationManager = [[CLLocationManager alloc] init] ;
        
        self.locationManager.delegate = (id<CLLocationManagerDelegate>)self;
        // 开始定位
        self.locationManager.desiredAccuracy=kCLLocationAccuracyBest;
        self.locationManager.distanceFilter = 10.0f;
        
        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {
            
            [_locationManager requestWhenInUseAuthorization ];
        }
        
        //        [self startTrackingLocation];
        [_locationManager startUpdatingLocation];
        
        
    }else {
        
        //提示用户无法进行定位操作
        
//        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"定位不成功 ,请确认开启定位"delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
//        
//        [alertView show];
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"定位不成功，请确认开始了定位" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *a1 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            NSLog(@"shibai");
        }];
        UIAlertAction *a2 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            NSLog(@"chenggong");
        }];
        [alert addAction:a1];
        [alert addAction:a2];
        [self presentViewController:alert animated:YES completion:nil];
    }
    
    
    
    //[NSUD setValue:leftBtn.titleLabel.text forKey:@"place"];
    
    if ([NSUD boolForKey:@"everLaunched"] && ![leftBtn.titleLabel.text isEqualToString:[NSUD objectForKey:@"place"]]) {
//        [self createAlertViewWithTag:1 andDic:nil];
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"您的位置已发送变化，是否切换到当前城市" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *a1 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            [self.locationManager stopUpdatingLocation];
            NSLog(@"shibai");
        }];
        UIAlertAction *a2 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [_locationManager startUpdatingLocation];
            NSLog(@"chenggong");
        }];
        [alert addAction:a1];
        [alert addAction:a2];
        [self presentViewController:alert animated:YES completion:nil];
    }else if([NSUD boolForKey:@"firstLaunched"]){
//        [self createAlertViewWithTag:1 andDic:nil];
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"是否切换到当前城市" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *a1 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            [self.locationManager stopUpdatingLocation];
            NSLog(@"shibai");
        }];
        UIAlertAction *a2 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [_locationManager startUpdatingLocation];
            NSLog(@"chenggong");
        }];
        [alert addAction:a1];
        [alert addAction:a2];
        [self presentViewController:alert animated:YES completion:nil];
    }
    
}
- (void)startTrackingLocation {
    CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
    if (status == kCLAuthorizationStatusNotDetermined) {
        [_locationManager requestWhenInUseAuthorization];
    }
    else if (status == kCLAuthorizationStatusAuthorizedWhenInUse || status == kCLAuthorizationStatusAuthorizedAlways) {
        [_locationManager startUpdatingLocation];
        
    }
}


#pragma mark --CLLocationManagerDelegate

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations{
    [self.locationManager stopUpdatingLocation];
    //得到newLocation
    CLLocation *cloc = [locations lastObject];
    
    CLGeocoder * geoCoder = [[CLGeocoder alloc] init];
    [geoCoder reverseGeocodeLocation:cloc completionHandler:^(NSArray *placemarks, NSError *error) {
        if (!error){
            for (CLPlacemark * placemark in placemarks) {
                
                NSDictionary *test = [placemark addressDictionary];
                //  Country(国家)  State(城市)  SubLocality(区)
                NSLog(@"%@", [test objectForKey:@"State"]);
                [leftBtn setTitle:[test objectForKey:@"SubLocality"] forState:UIControlStateNormal];
                [NSUD setValue:leftBtn.titleLabel.text forKey:@"place"];
                
            }
        }else{
            NSLog(@"%@",error);
        }
        
    }];
}
/* 启用新的UIAlertController
-(void)createAlertViewWithTag :(NSInteger)number andDic:(NSDictionary*)passDic{
    UIAlertView*alterView ;
    if (number == 1) {
        alterView   = [[UIAlertView alloc]initWithTitle:@"是否切换" message:@"当前城市" delegate:self cancelButtonTitle:@"否" otherButtonTitles:@"是", nil];
    }else{
        if (!passDic ) {
            return;
        }
//        NSString*deviceName = passDic[@"deviceName"]?passDic[@"deviceName"]:@"";
//        NSString*houseName = passDic[@"houseName"]?passDic[@"houseName"]:@"";
//        
//        ShareConsultData *data = [ShareConsultData shareConsultManager];
//        NSDictionary *dataDic =data.dictionary;
//        
//        NSString *Name = dataDic[@"Name"]?dataDic[@"Name"]:@"";
//        
//        NSString *messageContent = @"";
//        if ([passDic[@"isErrmsg"]boolValue]) {
//            houseName = @"失败";
//            messageContent = passDic[@"errMsg"]?passDic[@"errMsg"]:@"";
//            alterView   = [[UIAlertView alloc]initWithTitle:houseName message:messageContent delegate:self cancelButtonTitle:@"重扫" otherButtonTitles:@"确定", nil];
//        }else{
//            messageContent =[NSString stringWithFormat:@"%@,您好!%@设备已经连接成功，请检测！",Name,deviceName];
//            alterView   = [[UIAlertView alloc]initWithTitle:houseName message:messageContent delegate:self cancelButtonTitle:@"返回" otherButtonTitles:@"继续", nil];
//        }
//        
//        
    }
    
    alterView.tag = number;
    alterView.delegate = self;
    CGRect frame = alterView.frame;
    frame.size.height = 220;
    frame.size.width = 220;
    alterView.frame = frame;
    
    [alterView show];
}
*/

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag == 1) {
        NSString*str = [NSUD objectForKey:@"place"];
        if (buttonIndex == 0) {
            if (str != nil  && ![str isEqualToString:@""]) {
                [leftBtn setTitle:str forState:UIControlStateNormal];
                
            }else{
                [leftBtn setTitle:@"城市" forState:UIControlStateNormal];
            }
        }
        [NSUD setObject:leftBtn.titleLabel.text forKey:@"place"];
        [NSUD synchronize];
    }else{
        if (buttonIndex == 0) {
            [self onerweima];
        }
    }
    
}

-(void)reloadBarButtonName{
    NSString*str = [NSUD objectForKey:@"place"];
    [leftBtn setTitle:str forState:UIControlStateNormal];
    
}

//- (void)goPlace:(UIButton*)sender
//{
//    FindPlaceVc *find = [[FindPlaceVc alloc] initWithNibName:@"FindPlaceVc" bundle:NULL];
//    find.hidesBottomBarWhenPushed = YES;
//    find.lastVC = self;
//    
//    find.areaname = self.navigationItem.rightBarButtonItem.title;
//    //    find.delegate = self;
//    // find.trans = YES;
//    [self.navigationController  pushViewController:find animated:YES];
//    
//}

-(void)selectedOnePlace:(NSDictionary *)placeDic{
    [leftBtn setTitle:placeDic[@"areaname"] forState:UIControlStateNormal];
    [NSUD setValue:leftBtn.titleLabel.text forKey:@"place"];
    [NSUD synchronize];
    areacode = placeDic[@"areacode"];
    
}
//集成二维码扫描
-(void)onerweima{

    _qr = [[QRViewController alloc]init];
    _qr.delegate = self;
    
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:_qr];
    
    [self presentViewController:nav animated:YES completion:nil];
    
}
- (void)qrCodeComplete:(NSString *)codeString
{
    [_qr dismissViewControllerAnimated:YES completion:nil];
    
    [self requestNetWorkWithString:codeString];
    
    
    
    
}

- (void)qrCodeError:(NSError *)error
{
    
}

-(void)requestNetWorkWithString:(NSString*)string{
    
    
    //    扫描
    if (!string ) {
        return;
    }
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"1" message:@"2" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *a1 = [UIAlertAction actionWithTitle:@"no" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"shibai");
    }];
    UIAlertAction *a2 = [UIAlertAction actionWithTitle:@"yes" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"chenggong");
    }];
    [alert addAction:a1];
    [alert addAction:a2];
    [self presentViewController:alert animated:YES completion:nil];
//    
//    ShareConsultData*data = [ShareConsultData shareConsultManager];
//    NSDictionary *dic = data.dictionary;
//    __weak SFHttpRequest *sharedRequest1 = [SFHttpRequest sharedHttpRequest];
//    sharedRequest1.tempType = 102;
//    
//    NSString*queryType1 = [NSString stringWithFormat:@"105"];
//    NSString*nfcCode = string?string:@"";
//    
//    
//    
//    NSString*phoneNumber = dic[@"Mobile"]?dic[@"Mobile"]:@"";
//    NSDictionary *params1 = @{@"nfcCode":nfcCode,@"phoneNumber":phoneNumber};
//    
//    [[SFHttpRequest sharedHttpRequest]query:params1 queryType:queryType1 completionBlock:^(ASIHTTPRequest *request, NSData *reponseData, NSError *error) {
//        sharedRequest1.tempType = 0;
//        id obj = [HHTool decodeReponseData:reponseData toView:self.view];
//        
//        [self createAlertViewWithTag:2 andDic:obj];
//        
//        
//    } failedBlock:^(ASIHTTPRequest *request, NSError *error) {
//        sharedRequest1.tempType = 0;
//        NSLog(@"test+++++++++++%@",error);
//        NSLog(@"shibaishibai");
//    }];
//    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
