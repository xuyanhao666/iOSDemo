//
//  ViewController.m
//  baiduMapDemo
//
//  Created by szyl on 16/5/26.
//  Copyright © 2016年 xyh. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()<BMKMapViewDelegate,BMKPoiSearchDelegate,BMKLocationServiceDelegate,BMKGeoCodeSearchDelegate,BMKRouteSearchDelegate>

@property (nonatomic, strong) BMKMapView * mapView;
//当前位置点
@property (nonatomic, strong) BMKPointAnnotation * MyLocAnnotation;
//热点检索
@property (nonatomic, strong) BMKPoiSearch * pointSearch;
//定位
@property (nonatomic, strong) BMKLocationService * locService;
//当前用户位置
@property (nonatomic, strong) BMKUserLocation * userLocation;
//热点数组
@property (nonatomic, strong) NSMutableArray * poiArr;
//地理编码
@property (nonatomic, strong) BMKGeoCodeSearch * geoCodeSearch;
//反地址编码后获得的地址信息 dic
@property (nonatomic, strong) NSMutableDictionary *locationInfoDic;
//路线规划检索
@property (nonatomic, strong) BMKRouteSearch * routeSearch;
//路线规划线路
@property (nonatomic, strong) BMKPolyline * polyLine;

@end
@implementation ViewController

- (BMKMapView *)mapView{
    if (!_mapView) {
        _mapView = [[BMKMapView alloc] initWithFrame:self.view.bounds];
    }
    return _mapView;
}
//- (BMKPointAnnotation *)annotation{
//    if (!_annotation) {
//        _annotation = [[BMKPointAnnotation alloc]init];
//    }
//    return _annotation;
//}
//- (BMKPoiSearch *)pointSearch{
//    if (!_pointSearch) {
//        _pointSearch = [[BMKPoiSearch alloc]init];
//    }
//    return _pointSearch;
//}
- (void) viewDidAppear:(BOOL)animated {
//    // 添加一个PointAnnotation
//    CLLocationCoordinate2D coor;
//    coor.latitude = 39.915;
//    coor.longitude = 116.404;
//    self.annotation.coordinate = coor;
//    self.annotation.title = @"这里是北京";
//    [_mapView addAnnotation:self.annotation];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.title = @"定位和热点搜索";
    self.navigationController.navigationBar.translucent = NO;
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(removeAnnotationWithLocation:)];
    self.navigationItem.rightBarButtonItem = rightItem;
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemOrganize target:self action:@selector(GeoCodeFromLocation)];
    self.navigationItem.leftBarButtonItem = leftItem;
    
//    _mapView.zoomLevel = 20;
    [self.view addSubview:self.mapView];
    //显示指南针
    CGPoint pt = CGPointMake(10, 10);
    [_mapView setCompassPosition:pt];
    
    _poiArr = [NSMutableArray array];
    _locationInfoDic = [NSMutableDictionary dictionary];
    _MyLocAnnotation = [[BMKPointAnnotation alloc] init];
    _geoCodeSearch = [[BMKGeoCodeSearch alloc] init];
    _geoCodeSearch.delegate = self;
    _routeSearch = [[BMKRouteSearch alloc] init];
    _routeSearch.delegate = self;
    
    _locService = [[BMKLocationService alloc] init];
    _locService.delegate = self;
//    _mapView.showsUserLocation = NO;//先关闭显示的定位图层
//    _mapView.userTrackingMode = BMKUserTrackingModeNone;//设置定位的状态
//    _mapView.showsUserLocation = YES;//显示定位图层
    _locService.distanceFilter = 10.0;
    _locService.desiredAccuracy = kCLLocationAccuracyBest;
    //启动定位
    [_locService startUserLocationService];
    
    if (![self locationServicesEnabled]) {
        [self showNoticeForLocation];
    }
    
    
}
//计算两点距离
- (CGFloat)meterBetweenMapPoint:(CGPoint)startPoint endPoint:(CGPoint)endPoint {
    BMKMapPoint startMapPoint = BMKMapPointMake(startPoint.x, startPoint.y);
    BMKMapPoint endMapPoint = BMKMapPointMake(endPoint.x, endPoint.y);
    CLLocationDistance dis = BMKMetersBetweenMapPoints(startMapPoint, endMapPoint);
    return dis/1000;
}
//路线规划
- (void)showBusRoute{
    //我的起始位置
    BMKPlanNode *start = [[BMKPlanNode alloc]init];
    start.pt = _userLocation.location.coordinate;
    
    //终点
    BMKPlanNode *end = [[BMKPlanNode alloc]init];
    end.cityName = [_locationInfoDic objectForKey:@"city"];
//    end.cityName = @"上海市";
    CLLocationCoordinate2D endCoor;
    endCoor.longitude = _userLocation.location.coordinate.longitude+0.03;
    endCoor.latitude = _userLocation.location.coordinate.latitude+0.03;
    end.pt = endCoor;
//    BMKPointAnnotation *annotion = _poiArr[0];
//    end.pt = annotion.coordinate;
    
    BMKTransitRoutePlanOption *transitRoutePlanOption = [[BMKTransitRoutePlanOption alloc] init];
    transitRoutePlanOption.city = [_locationInfoDic objectForKey:@"city"];
    transitRoutePlanOption.from = start;
    transitRoutePlanOption.to = end;
    BOOL flag = [_routeSearch transitSearch:transitRoutePlanOption];
    if (flag) {
        NSLog(@"公交路线规划成功");
    }else{
        NSLog(@"公交路线规划失败");
    }
    
}
//路线规划代理方法
- (void)onGetTransitRouteResult:(BMKRouteSearch*)searcher result:(BMKTransitRouteResult*)result errorCode:(BMKSearchErrorCode)error {
    //清理地图图标
    //[self clearMap];
    if(error == BMK_SEARCH_RESULT_NOT_FOUND){
        NSLog(@"没有找到检索结果");
    }else if(error == BMK_SEARCH_NOT_SUPPORT_BUS_2CITY){
        NSLog(@"不支持跨城市公交");
    }else if (error == BMK_SEARCH_NO_ERROR) {
        NSLog(@"规划结果无错误");
        NSLog(@"result.routes======%@",result.routes);
        BMKTransitRouteLine *transitRouteLine = (BMKTransitRouteLine *)[result.routes objectAtIndex:0];
        // 计算路线方案中的路段数目
        NSInteger stepNum = [transitRouteLine.steps count];
        int transitRouteLineCounts = 0;
        for (int i = 0; i < stepNum; i++) {
            BMKTransitStep *busStep = [transitRouteLine.steps objectAtIndex:i];
            if (i==0) {
                BMKPointAnnotation *point = [[BMKPointAnnotation alloc] init];
                point.coordinate = transitRouteLine.starting.location;
                point.subtitle = @"出发点";
                [_mapView addAnnotation:point];
            }else if (i==stepNum-1){
                BMKPointAnnotation *point = [[BMKPointAnnotation alloc] init];
                point.coordinate = transitRouteLine.terminal.location;
                point.title = @"目的地";
                [_mapView addAnnotation:point];
            }
            BMKPointAnnotation *point = [[BMKPointAnnotation alloc] init];
            point.coordinate = busStep.entrace.location;
            point.title = busStep.instruction;
            [_mapView addAnnotation:point];
            
            //计算路线转折点数
            transitRouteLineCounts += busStep.pointsCount;
        }
        BMKMapPoint *polyPoints = new BMKMapPoint[transitRouteLineCounts];
        int i = 0;
        for (int j = 0; j < stepNum; j++) {
            BMKTransitStep* transitStep = [transitRouteLine.steps objectAtIndex:j];
            int k=0;
            for(k=0;k<transitStep.pointsCount;k++) {
                polyPoints[i].x = transitStep.points[k].x;
                polyPoints[i].y = transitStep.points[k].y;
                i++;
            }
            
        }
        _polyLine = [[BMKPolyline alloc] init];
        [_polyLine setPolylineWithPoints:polyPoints count:transitRouteLineCounts];
        [_mapView addOverlay:_polyLine];
        [self mapViewFitPolyLine:_polyLine];
    }else if (error == BMK_SEARCH_ST_EN_TOO_NEAR){
        NSLog(@"起止点离的太近");
    }
        
}
//根据polyline设置地图范围
- (void)mapViewFitPolyLine:(BMKPolyline *) polyLine {
    CGFloat ltX, ltY, rbX, rbY;
    if (polyLine.pointCount < 1) {
        return;
    }
    BMKMapPoint pt = polyLine.points[0];
    ltX = pt.x, ltY = pt.y;
    rbX = pt.x, rbY = pt.y;
    for (int i = 1; i < polyLine.pointCount; i++) {
        BMKMapPoint pt = polyLine.points[i];
        if (pt.x < ltX) {
            ltX = pt.x;
        }
        if (pt.x > rbX) {
            rbX = pt.x;
        }
        if (pt.y > ltY) {
            ltY = pt.y;
        }
        if (pt.y < rbY) {
            rbY = pt.y;
        }
    }
    BMKMapRect rect;
    rect.origin = BMKMapPointMake(ltX , ltY);
    rect.size = BMKMapSizeMake(rbX - ltX, rbY - ltY);
    [_mapView setVisibleMapRect:rect];
    _mapView.zoomLevel = _mapView.zoomLevel - 0.3;
}

- (BMKOverlayView*)mapView:(BMKMapView *)map viewForOverlay:(id<BMKOverlay>)overlay
{
    if ([overlay isKindOfClass:[BMKPolyline class]]) {
        BMKPolylineView* polylineView = [[BMKPolylineView alloc] initWithOverlay:overlay];
        polylineView.fillColor = [[UIColor alloc] initWithRed:0 green:1 blue:1 alpha:1];
        polylineView.strokeColor = [[UIColor alloc] initWithRed:0 green:0 blue:1 alpha:0.7];
        polylineView.lineWidth = 5;
        return polylineView;
    }
    return nil;
}

//- (void)onGetDrivingRouteResult:(BMKRouteSearch*)searcher result:(BMKDrivingRouteResult*)result errorCode:(BMKSearchErrorCode)error
//{
//    //清理地图图标
//    //[self clearMap];
//
//    if(error == BMK_SEARCH_RESULT_NOT_FOUND){
//        [self showTipsMessage:@"没有找到检索结果"];
//    }else  if (error == BMK_SEARCH_NO_ERROR) {
//    }
//}

// 标注点代理方法
- (BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id <BMKAnnotation>)annotation
{
    if ([annotation isKindOfClass:[BMKPointAnnotation class]]) {
        BMKPinAnnotationView *newAnnotationView = [[BMKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"myAnnotation"];
        if (annotation == _MyLocAnnotation) {
            newAnnotationView.image = [UIImage imageNamed:@"poi_1"];
        }else if([annotation.title isEqualToString:@"加油站"]){
            newAnnotationView.image = [UIImage imageNamed:@"poi_3"];
        }else{
            newAnnotationView.pinColor = BMKPinAnnotationColorPurple;
        }
//        newAnnotationView.animatesDrop = YES;// 设置该标注点动画显示
        return newAnnotationView;
    }
    return nil;
}
//检索周边热点
- (void)removeAnnotationWithLocation:(BMKUserLocation *)location{
    //    if (_annotation!= nil) {
    //        [_mapView removeAnnotation:_annotation];
    //    }
    //发起检索
    _pointSearch = [[BMKPoiSearch alloc]init];
    _pointSearch.delegate = self;
    BMKNearbySearchOption *option = [[BMKNearbySearchOption alloc]init];
    option.pageIndex = 0;
    option.pageCapacity = 10;
    option.location = _userLocation.location.coordinate;
    option.radius = 3000;
    option.keyword = @"加油站";
    
    BMKCitySearchOption *option2 = [[BMKCitySearchOption alloc]init];
    option2.city = @"上海市";
    option2.pageIndex = 0;
    option2.pageCapacity = 20;
    option2.keyword = @"加油站";
    BOOL flag = [_pointSearch poiSearchNearBy:option];
    if (flag) {
        NSLog(@"周围搜索成功");
    }else{
        NSLog(@"周围搜索失败");
    }
}

// 周边搜索代理方法，实现PoiSearchDeleage处理回调结果
- (void)onGetPoiResult:(BMKPoiSearch*)searcher result:(BMKPoiResult*)poiResultList errorCode:(BMKSearchErrorCode)error
{
    if (error == BMK_SEARCH_NO_ERROR) {
        //在此处理正常结果
         NSLog(@"检索到 poi");
        NSMutableArray *poiInfoArr = [NSMutableArray array];
        for (int i = 0; i < poiResultList.poiInfoList.count; i++) {
            [poiInfoArr addObject:[poiResultList.poiInfoList objectAtIndex:i]];
        }
        for (BMKPoiInfo *poiInfo in poiInfoArr) {
            BMKPointAnnotation *pointAnnotation = [[BMKPointAnnotation alloc] init];
            pointAnnotation.coordinate = poiInfo.pt;
            pointAnnotation.title = @"加油站";
            [_poiArr addObject:pointAnnotation];
        }
        NSLog(@"arrNum======%ld",_poiArr.count);
        //添加周围热点的标注点
        [_mapView addAnnotations:_poiArr];
        //公交路线规划
        [self showBusRoute];
    }else if (error == BMK_SEARCH_AMBIGUOUS_KEYWORD){
        //当在设置城市未找到结果，但在其他城市找到结果时，回调建议检索城市列表
        // result.cityList;
        NSLog(@"起始点有歧义");
    }else {
        NSLog(@"抱歉，未找到结果");
    }
}
// 定位服务代理方法
//处理方向变更信息
- (void)didUpdateUserHeading:(BMKUserLocation *)userLocation
{
//    NSLog(@"heading is %@",userLocation.heading);
}
//处理位置坐标更新
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{
    NSLog(@"didUpdateUserLocation lat %f,long %f",userLocation.location.coordinate.latitude,userLocation.location.coordinate.longitude);
    CLLocationCoordinate2D coor;
    coor = userLocation.location.coordinate;
    BMKPointAnnotation *annotion = [[BMKPointAnnotation alloc]init];
    annotion.coordinate = coor;
    annotion.title = userLocation.title;
    annotion.subtitle = @"哈哈";
    _userLocation = userLocation;
    _MyLocAnnotation = annotion;
    [_mapView addAnnotation:annotion];
    _MyLocAnnotation.coordinate = userLocation.location.coordinate;
//    [_mapView setCenterCoordinate:coor];
    //设置默认的显示范围，和显示的中心点
    [self passLocationValueWithLocation:userLocation];
    [_locService stopUserLocationService];
}
//反地址编码
- (void)GeoCodeFromLocation{
    BMKReverseGeoCodeOption *reverseGeoCodeOption = [[BMKReverseGeoCodeOption alloc] init];
    reverseGeoCodeOption.reverseGeoPoint = _userLocation.location.coordinate;
    BOOL flag = [_geoCodeSearch reverseGeoCode:reverseGeoCodeOption];
    if (flag) {
        NSLog(@"geo 反地址编码成功！");
    }else{
        NSLog(@"geo 反地址编码失败！");
    }
    [_mapView removeAnnotations:_poiArr];
}
//反地址编码代理方法
- (void)onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error{
    
    if (error == BMK_SEARCH_NO_ERROR) {
        for (BMKPoiInfo *poiInfo in result.poiList) {
            NSLog(@"name=====%@,address=====%@",poiInfo.name,poiInfo.address);
        }
        [_locationInfoDic setObject:result.addressDetail.city forKey:@"city"];
        [_locationInfoDic setObject:result.addressDetail.streetName forKey:@"streetName"];
        [_locationInfoDic setObject:result.addressDetail.streetNumber forKey:@"streetNumber"];
        [_locationInfoDic setObject:result.addressDetail.district forKey:@"district"];
        [_locationInfoDic setObject:result.addressDetail.province forKey:@"province"];
        NSLog(@"%@%@%@%@%@",[_locationInfoDic objectForKey:@"province"],[_locationInfoDic objectForKey:@"city"],[_locationInfoDic objectForKey:@"district"],[_locationInfoDic objectForKey:@"streetName"],[_locationInfoDic objectForKey:@"streetNumber"]);
        NSString *titleStr = [NSString stringWithFormat:@"%@%@%@",[_locationInfoDic objectForKey:@"city"],[_locationInfoDic objectForKey:@"district"],[_locationInfoDic objectForKey:@"streetName"]];
        self.title = titleStr;
    }
}
-(void)passLocationValueWithLocation:(BMKUserLocation *)location
{
    CLLocationCoordinate2D coor;
    coor = location.location.coordinate;
    BMKCoordinateRegion viewRegion;
    viewRegion.center = coor;
//    viewRegion.span.latitudeDelta = 0.008;
//    viewRegion.span.longitudeDelta = 0.008;
    viewRegion.span.latitudeDelta = 0.07;
    viewRegion.span.longitudeDelta = 0.07;
    BMKCoordinateRegion adjustedRegion = [_mapView regionThatFits:viewRegion];
    [_mapView setRegion:adjustedRegion animated:YES];
    
}
-(void)viewWillAppear:(BOOL)animated
{
    [_mapView viewWillAppear];
    _mapView.delegate = self; // 此处记得不用的时候需要置nil，否则影响内存的释放
//    _pointSearch.delegate = self;
}
-(void)viewWillDisappear:(BOOL)animated
{
    [_mapView viewWillDisappear];
    _mapView.delegate = nil; // 不用时，置nil
    _pointSearch.delegate = nil;
    _locService.delegate = nil;
    _geoCodeSearch.delegate = nil;
    _routeSearch.delegate = nil;
}
//判断是否允许启用位置，一直，和未决定（根据需要可更改或添加在使用期间）
- (BOOL)locationServicesEnabled {
    if ([CLLocationManager locationServicesEnabled] &&
        ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedAlways
         || [CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined)) {
            //定位功能可用，开始定位
            return YES;
        }
    else if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied){
        return NO;
    }
    return YES;
}
- (void)showNoticeForLocation{
    UIAlertController *locationAlert = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"定位服务未开启，请进入系统【设置】>【隐私】>【定位服务】中打开开关，并允许爸爸去哪儿了使用定位服务" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancleAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *openLocationAction = [UIAlertAction actionWithTitle:@"立即开启" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //定位服务设置界面
        NSURL *url = [NSURL URLWithString:@"prefs:root=LOCATION_SERVICES"];
        if ([[UIApplication sharedApplication] canOpenURL:url])
        {
            [[UIApplication sharedApplication] openURL:url];
        }
    }];
    [locationAlert addAction:cancleAction];
    [locationAlert addAction:openLocationAction];
    [self presentViewController:locationAlert animated:YES completion:nil];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
