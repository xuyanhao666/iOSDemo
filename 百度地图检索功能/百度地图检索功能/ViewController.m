//
//  ViewController.m
//  百度地图检索功能
//
//  Created by huandi on 15/12/15.
//  Copyright © 2015年 Chndyx_Team. All rights reserved.
//

#import "ViewController.h"
#import <BaiduMapAPI/BMapKit.h>

/*
 *  定义当前屏宽(全局)
 */
#define SIZE_WIDTH [UIScreen mainScreen].bounds.size.width

@interface ViewController ()<BMKMapViewDelegate,BMKLocationServiceDelegate,BMKGeoCodeSearchDelegate,BMKPoiSearchDelegate,UISearchBarDelegate>
{
    /**
     *   实例化mapManager对象
     */
    BMKMapManager * _mapManager;
    /**
     *   地图
     */
    BMKMapView * _mapView;
    /**
     *   定位
     */
    BMKLocationService * _service;
    /**
     *   地址解析
     */
    BMKGeoCodeSearch * _search;
    /**
     *   搜索服务
     */
    BMKPoiSearch * _searcher;
    /**
     *   周边检索参数信息类
     */
    BMKNearbySearchOption * _option;
    /**
     *   大头针(表示一个点)
     */
    BMKPointAnnotation * _point;
}
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUIWithInitData];
    [self addressAutho];
}
/**
 *   布局UI并且初始化相关信息
 */
-(void)createUIWithInitData{
    /**
     *   对地图设置代理，并且使用标准地图
     */
    _mapView = [[BMKMapView alloc] initWithFrame:CGRectMake(0, 64, SIZE_WIDTH, 200)];
    _mapView.delegate = self;
    _mapView.mapType = BMKMapTypeStandard;
    /**
     *   设置显示定位图层
     */
    _mapView.showsUserLocation = YES;
    [self.view addSubview:_mapView];
    /**
     *  设置定位精度 ，默认：kCLLocationAccuracyBest
     *  指定最小距离（米），默认：kCLDistanceFilterNone(best)
     */
    [BMKLocationService setLocationDesiredAccuracy:kCLLocationAccuracyBest];
    [BMKLocationService setLocationDistanceFilter:kCLLocationAccuracyBest];
     /**
      *  初始化BMKLocationService (定位信息)
      */
    _service = [[BMKLocationService alloc] init];
    _service.delegate = self;
    /**
     *   打开定位信息
     */
    [_service startUserLocationService];
    /**
     *   地址解析
     */
    _search = [[BMKGeoCodeSearch alloc] init];
    _search.delegate = self;
    /**
     *   初始化检索对象
     */
    _searcher = [[BMKPoiSearch alloc] init];
    _searcher.delegate = self;
}
/**
 *   定位权限授权获取
 */
-(void)addressAutho{
    _mapManager = [[BMKMapManager alloc] init];
    //网络授权验证
    BOOL ret = [_mapManager start:@"" generalDelegate:nil];
    if (!ret) {
        NSLog(@"manager start failed !!!");
    }else{
        NSLog(@"manager start success !!!");
    }
}
#pragma mark  ------- BMKLocationServiceDelegate -----
-(void)willStartLocatingUser{
    NSLog(@"willStartLocatingUser");
}
-(void)didStopLocatingUser{
    NSLog(@"didStopLocatingUser");
}
/**
 *  位置更新时调用的delegate方法
 */
-(void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation{
    /**
     *   周边检索:  pageIndex:检索索引 pageCapacity:检索分页量0-50
     *            radius:检索半径   location:检索中心点坐标
     */
    _option = [[BMKNearbySearchOption alloc] init];
    _option.pageIndex = 0;
    _option.pageCapacity = 50;
    _option.radius = 300;
    _option.location = userLocation.location.coordinate;
    /**
     *   反geo检索信息类
     */
    BMKReverseGeoCodeOption *reverseGeoCodeSearchOption = [[BMKReverseGeoCodeOption alloc] init];
    reverseGeoCodeSearchOption.reverseGeoPoint = userLocation.location.coordinate;
    /**
     *   根据地理坐标获取地理信息
     */
    BOOL flag = [_search reverseGeoCode:reverseGeoCodeSearchOption];
    if (flag) {
        NSLog(@"success");
    }else{
        NSLog(@"fail");
    }
    
    /**
     *   大头针标注
     */
    _point = [[BMKPointAnnotation alloc] init];
    _point.coordinate = userLocation.location.coordinate;
    [_mapView addAnnotations:@[_point]];
    /**
     *   构造 BMKCoordinateRegion 对象
     */
    BMKCoordinateRegion viewRegion = BMKCoordinateRegionMake(userLocation.location.coordinate, BMKCoordinateSpanMake(0.02f, 0.02f));
    BMKCoordinateRegion adjustedRegion = [_mapView regionThatFits:viewRegion];
    [_mapView setRegion:adjustedRegion animated:YES];
    [_service stopUserLocationService];
    
}
#pragma mark  ------- BMKGeoCodeSearchDelegate -----
/**
 *返回反地理编码搜索结果
 *@param searcher 搜索对象
 *@param result 搜索结果
 *@param error 错误号，@see BMKSearchErrorCode
 */
-(void)onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error{
    NSLog(@"%@",result.address);
    _point.title = result.address;
    /**
     *  poi信息类 遍历 周边信息
     */
    for (BMKPoiInfo * poi in result.poiList) {
        NSLog(@"result.poiList: %@  poi.name: %@",poi.address,poi.name);
    }
    
    _option.keyword = result.address;
    BOOL FLAG = [_searcher poiSearchNearBy:_option];
    if (FLAG) {
        NSLog(@"周边信息检索发送成功");
    }else{
        NSLog(@"周边信息检索发送失败");
    }
}
#pragma mark  ------- BMKPoiSearchDelegate -----
/**
 *返回POI搜索结果
 *@param searcher 搜索对象
 *@param poiResult 搜索结果列表
 *@param errorCode 错误号，@see BMKSearchErrorCode
 */
-(void)onGetPoiResult:(BMKPoiSearch *)searcher result:(BMKPoiResult *)poiResult errorCode:(BMKSearchErrorCode)errorCode{
    /**
     *   打印poi成员列表
     */
    NSLog(@"poiInfoList: %@",poiResult.poiInfoList);
    for (BMKPoiInfo *poi in poiResult.poiInfoList) {
        NSLog(@"poi.address %@",poi.address);
    }
    if (errorCode == BMK_SEARCH_NO_ERROR) {
        //检索结果正常返回
    }else if (errorCode == BMK_SEARCH_AMBIGUOUS_KEYWORD){
        NSLog(@"检索词有歧义");
    }else{
        NSLog(@"其它未知错误或为结果,可进入type enum  查询");
    }
}
#pragma mark  ------- UISearchBarDelegate -----
/**
 *   serachBar的text输入有改变时调用
 */
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    NSLog(@"%@",searchText);
    _option.keyword = searchText;
    BOOL FLAG = [_searcher poiSearchNearBy:_option];
    if (FLAG) {
        NSLog(@"周边信息检索发送成功");
    }else{
        NSLog(@"周边信息检索发送失败");
    }
}
#pragma mark --------- CancelBtnClick ---------
- (IBAction)CancelBtnClick:(id)sender {
}


@end
