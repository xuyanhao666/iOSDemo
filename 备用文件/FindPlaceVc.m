//
//  FindPlaceVc.m
//  TianYIHealth
//
//  Created by 曹 胜全 on 3/19/14.
//  Copyright (c) 2014 曹 胜全. All rights reserved.
//

#import "FindPlaceVc.h"
#import "ChineseToPinyin.h"
#import <CoreLocation/CoreLocation.h>
#import "FindPlaceDetailVC.h"
@interface FindPlaceVc ()<UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, CLLocationManagerDelegate>

@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;

@property (weak, nonatomic) IBOutlet UITableView *leftTableView;

@property (weak, nonatomic) IBOutlet UITableView *rightTableView;


@property (nonatomic, assign) BOOL bSearching;

@property (nonatomic, strong) NSArray *leftArray;
@property (nonatomic, strong) NSArray *rightArray;
@property (nonatomic, strong) NSMutableArray *filterArray;

@end

@implementation FindPlaceVc
{
    CLLocationManager *_manager;
    NSDictionary *_selectDic;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"bt_back_up"] style:UIBarButtonItemStylePlain target:self action:@selector(toBack)];
    leftItem.imageInsets =  UIEdgeInsetsMake(0,-10,0,0);
    self.navigationItem.leftBarButtonItem = leftItem;
    
    
}
-(void)viewDidAppear:(BOOL)animated{
    
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"bt_back_up"] style:UIBarButtonItemStylePlain target:self action:@selector(toBack)];
    leftItem.imageInsets =  UIEdgeInsetsMake(0,-10,0,0);
    self.navigationItem.leftBarButtonItem = leftItem;
    
    [super viewDidAppear:animated];
    
    
}

-(void)toBack{
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"location_up"] style:UIBarButtonItemStylePlain target:self action:@selector(location:)];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    [self.navigationItem setTitleView:[HHTool naviTitle:@"选择城市"]];
    
    [self.leftTableView setBackgroundColor:[UIColor colorWithRed:248.0/255.0 green:248.0/255.0 blue:248.0/255.0 alpha:1.0]];
//    [self.rightTableView setBackgroundColor:[UIColor whiteColor]];
//    self.rightTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.leftTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"lefttablecell"];
//    [self.rightTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"righttablecell"];
    
    _filterArray = [NSMutableArray new];
    
    self.searchBar.delegate = self;
    
    if ([CLLocationManager locationServicesEnabled]) {
        _manager = [[CLLocationManager alloc] init];
        _manager.delegate = self;
        _manager.desiredAccuracy = kCLLocationAccuracyBest;
        
    }
    [self requestDataModal];
//    [self performSelectorInBackground:@selector(requestDataModal) withObject:nil];
}

- (void)toBack:(id)sender
{
//    if (_delegate && [_delegate respondsToSelector:@selector(selectedOnePlace:)] && _selectDic) {
//        [_delegate selectedOnePlace:_selectDic];
//    }
//    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
//    NSDictionary *dic = @{@"back":@"YES"};
//    [nc postNotificationName:@"backToView" object:self userInfo:dic];
//    
   // [super toBack:nil];
    [self toBack];
    
}

- (void)location:(id)sender
{
    [HHTool addPromptToView:self.view andPrompText:@"定位中...." autoSize:YES durationTime:0.5f];
    [_manager startUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    CLLocation *currentLocation = [locations lastObject];
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder reverseGeocodeLocation:currentLocation completionHandler:^(NSArray *placemarks, NSError *error) {
        if (error == nil &&[placemarks count] > 0) {
            
            CLPlacemark *placemark = [placemarks firstObject];
            NSDictionary *d = placemark.addressDictionary;
            NSString *state = d[@"State"];
            
//            NSDictionary *params = @{@"area": @{@"areaname":state}, @"operType":@"379"};
            
//            [[SFHttpRequest sharedHttpRequest] query:params queryType:@"379" completionBlock:^(ASIHTTPRequest *request, NSData *reponseData, NSError *error) {
//                
//                id obj = [HHTool decodeReponseData:reponseData toView:self.view];
//                if (obj != nil) {
//                    if (_delegate && [_delegate respondsToSelector:@selector(selectedOnePlace:)]) {
//                        NSDictionary *nowDic = @{@"areacode":obj[@"sysAreaT"][@"id"],@"areaname":state};
//                        [_delegate selectedOnePlace:nowDic];
//                        [self toBack:nil];
//                    }
//                }
//                
//            } failedBlock:^(ASIHTTPRequest *request, NSError *error) {
//                
//            }];
          
        }
    }];
    [_manager stopUpdatingLocation];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([tableView isEqual:self.leftTableView]) {
        return  self.bSearching ? [self.filterArray count] : [self.leftArray count];
    }else if ([tableView isEqual:self.rightTableView]){
//        return [self.rightArray count];
        return 0;
    }else
        return 0;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    if ([tableView isEqual:self.leftTableView]) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"lefttablecell" forIndexPath:indexPath];
        if (cell == nil) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"lefttablecell"];
        }
        NSDictionary *nowDic =  self.bSearching ? [self.filterArray objectAtIndex:indexPath.row]: [self.leftArray objectAtIndex:indexPath.row];
        NSString *title = [nowDic objectForKey:@"areaname"];
        cell.textLabel.text = title;
        [cell setBackgroundColor:[UIColor colorWithRed:248.0/255.0 green:248.0/255.0 blue:248.0/255.0 alpha:1.0]];

    }
    cell.textLabel.numberOfLines = 0;
    cell.textLabel.lineBreakMode = NSLineBreakByClipping;
    
    
    
    
    return cell;
}


- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
            //点击查询相关地级市
        NSDictionary *nowDic = self.bSearching ? [self.filterArray objectAtIndex:indexPath.row]: [self.leftArray objectAtIndex:indexPath.row];
//
//        if (_delegate && [_delegate respondsToSelector:@selector(selectedOnePlace:)]) {
//            [_delegate selectedOnePlace:nowDic];
//            
//        }
//        NSString *title = [nowDic objectForKey:@"areaname"];
//       // [super toBack:nil];
//        [NSUD setObject:title forKey:@"place"];
//        [NSUD synchronize];
////        [[NSNotificationCenter defaultCenter]postNotificationName:@"refreashHospList" object:nil];
//
//        [self toBack];

    FindPlaceDetailVC *findVC = [[FindPlaceDetailVC alloc]init];
    findVC.parentid = nowDic[@"id"];
    findVC.delegate = (id<FindPlaceDelegate>)self.lastVC;
    [self.navigationController pushViewController:findVC animated:YES];

   
}

- (void) requestDataModal
{
    
    NSDictionary *param = @{@"parentid": @"889022A5-2254-4572-B170-69C0E1D03B0B"};
    NSDictionary *params = @{@"area": param};
    __weak SFHttpRequest *sharedRequest = [SFHttpRequest sharedHttpRequest];

    sharedRequest.tempType = 103;
    [[SFHttpRequest sharedHttpRequest] query:params queryType:@"326" completionBlock:^(ASIHTTPRequest *request, NSData *reponseData, NSError *error) {
        sharedRequest.tempType = 0;
        id obj = [HHTool decodeReponseData:reponseData toView:self.view];
        if (obj != nil) {
            NSArray *arealist = [obj objectForKey:@"arealist"];
            self.leftArray = arealist;
            [self.leftTableView reloadData];
        }
    } failedBlock:^(ASIHTTPRequest *request, NSError *error) {
        
    }];
}

- (void) requestPlaceBy:(NSDictionary *) pDic
{
    NSString *ID = nil;
    NSString *areaname = [pDic objectForKey:@"areaname"];
    if ([areaname isEqualToString:@"北京市"]) {
        ID = @"756C92C3-A302-4DCA-A362-37EED640877F";
    }else if ([areaname isEqualToString:@"上海市"]){
        ID = @"AB776646-799E-4A0D-BEDE-A88FC1992063";
    }else if ([areaname isEqualToString:@"天津市"]){
        ID = @"67EFB7AF-A9D6-4088-BCE2-C294A7818AF3";
    }else if ([areaname isEqualToString:@"重庆市"]){
        ID = @"858C08C9-8D62-410F-A388-E848B614BBD0";
    }else{
        ID = [pDic objectForKey:@"id"];
    }

    if (ID == nil) {
        self.rightArray = nil;
//        [self.rightTableView reloadData];
    }
    
    NSDictionary *param = @{@"parentid": ID};
    NSDictionary *params = @{@"area": param,
                             @"operType": @"326"};
    
    [[SFHttpRequest sharedHttpRequest] query:params queryType:@"326" completionBlock:^(ASIHTTPRequest *request, NSData *reponseData, NSError *error) {
        id obj = [HHTool decodeReponseData:reponseData toView:self.view];
        if (obj != nil) {
            NSArray *arealist = [obj objectForKey:@"arealist"];
            self.rightArray = arealist;
//            [self.rightTableView reloadData];
        }
    } failedBlock:^(ASIHTTPRequest *request, NSError *error) {
        
    }];
}


- (void) searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    self.bSearching = [searchText length] > 0;
    
    [self.filterArray removeAllObjects];
    
    [self.leftArray enumerateObjectsUsingBlock:^(NSDictionary * diseaseDic, NSUInteger idx, BOOL *stop) {
        
        NSString *diseaseName = [diseaseDic objectForKey:@"areaname"];
        NSComparisonResult result = [diseaseName compare:searchText options:(NSCaseInsensitiveSearch | NSDiacriticInsensitiveSearch) range:NSMakeRange(0, [searchText length])];
        if (result == NSOrderedSame) {
            [self.filterArray addObject:diseaseDic];
        }else{
            NSString *pinyin = [ChineseToPinyin pinyinFromChiniseString:diseaseName];
            result = [pinyin compare:searchText options:(NSCaseInsensitiveSearch|NSDiacriticInsensitiveSearch) range:NSMakeRange(0, [searchText length])];
            if (result == NSOrderedSame) {
                [self.filterArray addObject:diseaseDic];
            }
        }
    }];
    
    [self.leftTableView reloadData];
    self.rightArray = nil;
//    [self.rightTableView reloadData];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
}





@end
