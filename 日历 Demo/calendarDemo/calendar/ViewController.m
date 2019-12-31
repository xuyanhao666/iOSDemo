//
//  ViewController.m
//  calendarDemo
//
//  Created by szyl on 16/6/13.
//  Copyright © 2016年 xyh. All rights reserved.
//

#import "ViewController.h"
#import "FSCalendar.h"
#import "NetRequestObject.h"

#define ScreenWidth [UIScreen mainScreen].bounds.size.width
#define screenHight [UIScreen mainScreen].bounds.size.height

@interface ViewController ()<UIPickerViewDelegate,UIPickerViewDataSource,FSCalendarDelegate,FSCalendarDataSource,FSCalendarDelegateAppearance,UIWebViewDelegate>
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
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
