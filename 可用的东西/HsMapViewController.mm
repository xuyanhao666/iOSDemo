//
//  HsMapViewController.m
//  Hundsun_InternetSellTicket
//
//  Created by 王金东 on 15/6/19.
//  Copyright (c) 2015年 王金东. All rights reserved.
//

#import "HsMapViewController.h"
#import "UIImage+Rotate.h"
#import "HsPoiAddress.h"
#import "Const.h"


//@interface RouteAnnotation : BMKPointAnnotation{
//    int _type; ///<0:起点 1：终点 2：公交 3：地铁 4:驾乘 5:途经点
//    int _degree;
//}
//@property (nonatomic) int type;
//@property (nonatomic) int degree;
//@end
//
//@implementation RouteAnnotation
//
//@synthesize type = _type;
//@synthesize degree = _degree;
//@end

#pragma mark

@interface HsMapViewController ()<BMKMapViewDelegate,BMKRouteSearchDelegate,BMKPoiSearchDelegate,BMKGeoCodeSearchDelegate,BMKLocationServiceDelegate>{
    //想要定位的位置
    BMKPointAnnotation *_pointAnnotation;
    CGPoint _location;
    //路径检索
    BMKRouteSearch *_routesearch;
    //周边检索
    BMKPoiSearch *_poisearch;
    //位置检索
    BMKGeoCodeSearch *_geocodesearch;
    //当前中心点
    CLLocationCoordinate2D _centerLocation;
    //两点距离
    CGFloat _meterBetwwenTwoPoint;
    //定位服务
    BMKLocationService *_locService;
    //用户位置
    BMKPointAnnotation *animotion4;
    //蚂蚁点
    
    NSMutableArray *poianiPoint;
    
    BMKPointAnnotation* poniview;
    
  
    
}

//用户位置
@property (nonatomic,strong) BMKUserLocation *userLocation;

@property (nonatomic,strong)UIButton *FangDaBtn;

@property (nonatomic,strong)UIButton *suoxiaoBtn;

@property (nonatomic,strong)UIButton *dingweiBtn;

@end

@implementation HsMapViewController

#pragma mark ---------------------life cycle----------------------------------
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setup];
    //初始化数组
    __poiListArray = [[NSMutableArray alloc]init];
    __poiListPtLa = [[NSMutableArray alloc]init];
    __poiListPtLo = [[NSMutableArray alloc]init];
    __poiListAddArray = [[NSMutableArray alloc]init];
    poianiPoint = [[NSMutableArray alloc]init];
//    if(CGPointEqualToPoint(_location, CGPointZero)){
//        CLLocationCoordinate2D coor;
//        //经纬度 默认杭州
//        coor.latitude = 120.20000;
//        coor.longitude = 30.26667;
//        [self setCenterLocation:coor];
//    }
    //设置当前点
    //self.point = _point;
    _mapView.delegate =self;
    _mapView.rotateEnabled = NO;
    //设置地图缩放级别
    if(self.zoomLevel > 0 )
         _mapView.zoomLevel = self.zoomLevel;
    else
        self.zoomLevel = 11;
    
    //设置是否缩放
    [self setScale:_scale];
    
    //自定义设置用户的位置
    
    animotion4 = [[BMKPointAnnotation alloc]init];
    [_mapView addAnnotation:animotion4];
    //路径检索
    //_routesearch = [[BMKRouteSearch alloc]init];
    //周边检索
    _poisearch = [[BMKPoiSearch alloc]init];
    //_poisearch.delegate = self;
    //地址位置检索
    _geocodesearch = [[BMKGeoCodeSearch alloc]init];
   // _geocodesearch.delegate = self;
    
    //右侧菜单事件
    if (self.endAddress) {
        [self pointByKeyword:self.endAddress];
    }
    [self startLocation];
    if (![HsMapViewController locationServicesEnabled]) {
        [self openGpsSetting];
        
    }else
    {
        
    }

}
-(void)setup
{
    self.dingweiBtn = [[UIButton alloc]init];
    self.dingweiBtn.frame = CGRectMake(20, SCREEN_HEIGHT-150-25+64, 25, 25);
    [self.dingweiBtn setBackgroundImage:[UIImage imageNamed:@"back_default"] forState:UIControlStateNormal];
    [self.dingweiBtn setBackgroundImage:[UIImage imageNamed:@"back_selected"] forState:UIControlStateSelected];
    [self.view addSubview:self.dingweiBtn];
    [self.dingweiBtn addTarget:self action:@selector(dingwei) forControlEvents:UIControlEventTouchUpInside];
    self.suoxiaoBtn = [[UIButton alloc]init];
    self.suoxiaoBtn.frame = CGRectMake(SCREEN_WIDTH-45, SCREEN_HEIGHT-150-25+64, 25, 25);
    [self.suoxiaoBtn setBackgroundImage:[UIImage imageNamed:@"selected_suoxiao"] forState:UIControlStateNormal];
    [self.suoxiaoBtn setBackgroundImage:[UIImage imageNamed:@"selected_suoxiao_xuanzhong"] forState:UIControlStateSelected];
    [self.view addSubview:self.suoxiaoBtn];
    [self.suoxiaoBtn addTarget:self action:@selector(fangda) forControlEvents:UIControlEventTouchUpInside];
    self.FangDaBtn =[[UIButton alloc]init];
    self.FangDaBtn.frame = CGRectMake(SCREEN_WIDTH-45, SCREEN_HEIGHT-150-10+25, 25, 25);
    [self.FangDaBtn setBackgroundImage:[UIImage imageNamed:@"selected_fangda"] forState:UIControlStateNormal];
    [self.FangDaBtn setBackgroundImage:[UIImage imageNamed:@"selected_fangda_xuanzhong"] forState:UIControlStateSelected];
    [self.view addSubview:self.FangDaBtn];
    [self.FangDaBtn addTarget:self action:@selector(suoxiao) forControlEvents:UIControlEventTouchUpInside];
    UIImageView *iconImage = [[UIImageView alloc]init];
    iconImage.frame = CGRectMake(20,  SCREEN_HEIGHT-150, 60, 20);
    iconImage.image = [UIImage imageNamed:@"baidumap_logo_1"];
    [self.view addSubview:iconImage];
}

-(void)dingwei
{
    [_locService startUserLocationService];
}
-(void)fangda
{
     _mapView.zoomLevel = _mapView.zoomLevel--;
}
-(void)suoxiao
{
    _mapView.zoomLevel = _mapView.zoomLevel++;
}
- (void)startLocation {
    //_mapView.showsUserLocation = self.showsUserLocation;
    if (_locService == nil) {
        _locService = [[BMKLocationService alloc]init];
        // Do any additional setup after loading the view from its nib.
        // 设置距离过滤，表示每移动10更新一次位置
        _locService.distanceFilter = kCLDistanceFilterNone;
        // 设置定位精度;
        _locService.desiredAccuracy = kCLLocationAccuracyBest;
    }
    _locService.delegate = self;
    [_locService startUserLocationService];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    //[_mapView viewWillAppear];
    //_mapView.delegate = self; // 此处记得不用的时候需要置nil，否则影响内存的释放
     //_routesearch.delegate = self; // 此处记得不用的时候需要置nil，否则影响内存的释放
    _poisearch.delegate = self; // 此处记得不用的时候需要置nil，否则影响内存的释放
     _geocodesearch.delegate = self; // 此处记得不用的时候需要置nil，否则影响内存的释放
//    if (self.showsUserLocation) {
//         [self startLocation];
//    }
    _locService.delegate = self;
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated ];
    //[_mapView viewWillDisappear];
    //_mapView.delegate = nil; // 不用时，置nil
    //_routesearch.delegate = nil; // 不用时，置nil
    _poisearch.delegate = nil; // 不用时，置nil
    _geocodesearch.delegate = nil; // 不用时，置nil
    
    //[_locService stopUserLocationService];
    _locService.delegate = nil;
}
- (void)setZoomLevel:(CGFloat)zoomLevel {
    _zoomLevel = zoomLevel;
    _mapView.zoomLevel = self.zoomLevel;
}
- (void)dealloc {
    if (_mapView) {
        self.mapView = nil;
    }
    NSLog(@"mapViewController 释放了");
}

#pragma mark ----------------------delegate-----------------------------------

// 根据anntation生成对应的View
- (BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id <BMKAnnotation>)annotation {
    NSString *AnnotationViewID = @"renameMark";
    BMKPinAnnotationView *newAnnotation;
    if (newAnnotation == nil) {
        newAnnotation = [[BMKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:AnnotationViewID];
        
        if (annotation == animotion4) {
            UIView *viewForImaget=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 40, 40)];
            UIImageView *iconImaget = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 40, 40)];
            iconImaget.layer.cornerRadius = iconImaget.frame.size.height / 2;
            iconImaget.layer.borderColor = [UIColor clearColor].CGColor;
            iconImaget.layer.borderWidth = 1.0;
            iconImaget.clipsToBounds = YES;
            [iconImaget setImage:[UIImage imageNamed:@"butter-iocation@3x"]];
            [viewForImaget addSubview:iconImaget];
            newAnnotation.image = [self getImageFromView:viewForImaget];
            if (SCREEN_WIDTH<414) {
                newAnnotation.centerOffset = CGPointMake(0, -(newAnnotation.frame.size.height * 0.5+4));
            }else
            {
                newAnnotation.centerOffset = CGPointMake(0, -(newAnnotation.frame.size.height * 0.5+10));
            }

        }else if(annotation == poniview){
            newAnnotation.image = [UIImage imageNamed:@"1_111"];
            
        }
        
      return newAnnotation;
    }
    
    //普通annotation
//    if (annotation == _pointAnnotation) {//定位
//        NSString *AnnotationViewID = @"renameMark";
//        BMKPinAnnotationView *annotationView = (BMKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:AnnotationViewID];
//        if (annotationView == nil) {
//            annotationView = [[BMKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:AnnotationViewID];
//            // 设置颜色
//            annotationView.pinColor = BMKPinAnnotationColorPurple;
//            // 从天上掉下效果
//            annotationView.animatesDrop = YES;
//            // 设置可拖拽
//            annotationView.draggable = YES;
//        }
//        return annotationView;
//    if (annotation == animotion4)
//    {
//        NSString *AnnotationViewID = @"userLocation";
//        BMKPinAnnotationView *annotationView = (BMKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:AnnotationViewID];
//        if (annotationView == nil) {
//            annotationView = [[BMKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:AnnotationViewID];
//            UIView *viewForImaget=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 40, 40)];
//            UIImageView *iconImaget = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 40, 40)];
//            iconImaget.layer.cornerRadius = iconImaget.frame.size.height / 2;
//            iconImaget.layer.borderColor = [UIColor clearColor].CGColor;
//            iconImaget.layer.borderWidth = 1.0;
//            iconImaget.clipsToBounds = YES;
//            [iconImaget setImage:[UIImage imageNamed:@"butter-iocation@3x"]];
//            [viewForImaget addSubview:iconImaget];
//            annotationView.image = [self getImageFromView:viewForImaget];
//            if (SCREEN_WIDTH<414) {
//            annotationView.centerOffset = CGPointMake(0, -(annotationView.frame.size.height * 0.5+4));
//            }else
//            {
//            annotationView.centerOffset = CGPointMake(0, -(annotationView.frame.size.height * 0.5+10));
//            }
//
//        }
//        return annotationView;
//    }else{//周边检索
//        NSString *AnnotationViewID = @"userLocation";
//        BMKPinAnnotationView *annotationView = (BMKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:AnnotationViewID];
//        if (annotationView == nil) {
//            annotationView = [[BMKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:AnnotationViewID];
//           annotationView.image = [UIImage imageNamed:@"1_111"];
//        }
//        return annotationView;
////        // 生成重用标示identifier
////        NSString *AnnotationViewID = @"zhoubianMark";
////        // 检查是否有重用的缓存
////        BMKAnnotationView* annotationView = [mapView dequeueReusableAnnotationViewWithIdentifier:AnnotationViewID];
////        
////        // 缓存没有命中，自己构造一个，一般首次添加annotation代码会运行到此处
////        if (annotationView == nil) {
////            annotationView = [[BMKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:AnnotationViewID];
////            ((BMKPinAnnotationView*)annotationView).pinColor = BMKPinAnnotationColorRed;
////            // 设置重天上掉下的效果(annotation)
////            ((BMKPinAnnotationView*)annotationView).animatesDrop = YES;
////        }
////        
////        // 设置位置
////        annotationView.centerOffset = CGPointMake(0, -(annotationView.frame.size.height * 0.5));
////        annotationView.annotation = annotation;
////        // 单击弹出泡泡，弹出泡泡前提annotation必须实现title属性
////        annotationView.canShowCallout = YES;
////        // 设置是否可以拖拽
////        annotationView.draggable = NO;
////        
////        return annotationView;
//    }
    return nil;
}
-(UIImage *)getImageFromView:(UIView *)view{
    UIGraphicsBeginImageContext(view.bounds.size);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}
-(void)currentPoi:(NSArray*)coor
{

    [_mapView removeAnnotation:poniview];
    [_mapView removeAnnotations:poianiPoint];
        [poianiPoint removeAllObjects];
    
    for (NSDictionary *arr in coor) {
        poniview = [[BMKPointAnnotation alloc]init];
        CLLocationCoordinate2D  coorAnin;
        coorAnin.latitude = [arr[@"xcoordinate"] doubleValue];
        coorAnin.longitude = [arr[@"ycoordinate"] doubleValue];
        //                poniview.coordinate = coorAnin;
        //                [self._mapAnnotations addObject:poniview];
        //                [mapview addAnnotations:_mapAnnotations];
       
        poniview.coordinate = coorAnin;
        [poianiPoint addObject:poniview];
        [_mapView addAnnotations:poianiPoint];
      
        //
    }
    

}
/**
 *点中底图空白处会回调此接口
 *@param mapview 地图View
 *@param coordinate 空白处坐标点的经纬度
 */
- (void)mapView:(BMKMapView *)mapView onClickedMapBlank:(CLLocationCoordinate2D)coordinate {
    if (self.onClickedMapBlank) {
        self.onClickedMapBlank();
    }
}
-(void)mapView:(BMKMapView *)mapView regionWillChangeAnimated:(BOOL)animated
{

    if (self.mapWillChange) {
        self.mapWillChange();
    }
}
- (void)mapView:(BMKMapView *)mapView regionDidChangeAnimated:(BOOL)animated {
    if (self.mapCenterBlock) {
        self.mapCenterBlock(mapView.centerCoordinate);
    }
    [self pointByKeywordWithLocation:mapView.centerCoordinate];
}
#pragma mark ------------------定位delagete---------------------
- (void)didUpdateUserHeading:(BMKUserLocation *)userLocation {
   // [self didUpdateBMKUserLocation:userLocation];
}
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation {
    [_mapView updateLocationData:userLocation];
    if (CGPointEqualToPoint(_location, CGPointZero)) {
        [self setCenterLocation:userLocation.location.coordinate]; 
    }
    BMKCoordinateRegion region;
    region.center.longitude = userLocation.location.coordinate.longitude;
    region.center.latitude = userLocation.location.coordinate.latitude;
    region.span.latitudeDelta = 0.03;
    region.span.longitudeDelta = 0.03;
    _mapView.region = region;
    
    _userLocation = userLocation;
   
    animotion4.coordinate = userLocation.location.coordinate;
   
    
    
    [_locService stopUserLocationService];
}

#pragma mark BMKRouteSearchDelegate 检索delegate

#define MYBUNDLE_NAME @ "mapapi.bundle"
#define MYBUNDLE_PATH [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent: MYBUNDLE_NAME]
#define MYBUNDLE [NSBundle bundleWithPath: MYBUNDLE_PATH]

- (NSString*)getMyBundlePath1:(NSString *)filename{
    
    NSBundle  *libBundle = MYBUNDLE ;
    if ( libBundle && filename ){
        NSString * s=[[libBundle resourcePath ] stringByAppendingPathComponent : filename];
        return s;
    }
    return nil ;
}

//- (void)onGetTransitRouteResult:(BMKRouteSearch*)searcher result:(BMKTransitRouteResult*)result errorCode:(BMKSearchErrorCode)error {
//    //清理地图图标
//    //[self clearMap];
//    if(error == BMK_SEARCH_RESULT_NOT_FOUND){
//        [self showTipsMessage:@"没有找到检索结果"];
//    }else if(error == BMK_SEARCH_NOT_SUPPORT_BUS_2CITY){
//        [self showTipsMessage:@"不支持跨城市公交"];
//    }else if (error == BMK_SEARCH_NO_ERROR) {
//    }
//}
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

////根据polyline设置地图范围
//- (void)mapViewFitPolyLine:(BMKPolyline *) polyLine {
//    CGFloat ltX, ltY, rbX, rbY;
//    if (polyLine.pointCount < 1) {
//        return;
//    }
//    BMKMapPoint pt = polyLine.points[0];
//    ltX = pt.x, ltY = pt.y;
//    rbX = pt.x, rbY = pt.y;
//    for (int i = 1; i < polyLine.pointCount; i++) {
//        BMKMapPoint pt = polyLine.points[i];
//        if (pt.x < ltX) {
//            ltX = pt.x;
//        }
//        if (pt.x > rbX) {
//            rbX = pt.x;
//        }
//        if (pt.y > ltY) {
//            ltY = pt.y;
//        }
//        if (pt.y < rbY) {
//            rbY = pt.y;
//        }
//    }
//    BMKMapRect rect;
//    rect.origin = BMKMapPointMake(ltX , ltY);
//    rect.size = BMKMapSizeMake(rbX - ltX, rbY - ltY);
//    [_mapView setVisibleMapRect:rect];
//    _mapView.zoomLevel = _mapView.zoomLevel - 0.3;
//}
//
#pragma mark BMKPoiSearchDelegate
#pragma mark -
#pragma mark implement BMKMapViewDelegate

/**
 *根据anntation生成对应的View
 *@param mapView 地图View
 *@param annotation 指定的标注
 *@return 生成的标注View
 */
- (void)mapView:(BMKMapView *)mapView didSelectAnnotationView:(BMKAnnotationView *)view{
    [mapView bringSubviewToFront:view];
    [mapView setNeedsDisplay];
    
    
}
- (void)mapView:(BMKMapView *)mapView didAddAnnotationViews:(NSArray *)views{
   // NSLog(@"didAddAnnotationViews");
    
    
}

#pragma mark -
#pragma mark implement BMKSearchDelegate
- (void)onGetPoiResult:(BMKPoiSearch *)searcher result:(BMKPoiResult*)result errorCode:(BMKSearchErrorCode)error
{

    NSMutableArray*currtArray = [[NSMutableArray alloc]init];//存放当前列表信息
    if (error == BMK_SEARCH_NO_ERROR) {
        for (int i = 0; i < result.poiInfoList.count; i++) {;
            [currtArray addObject:[result.poiInfoList objectAtIndex:i]];
       
        }
        if (self.poicityAdress) {
            self.poicityAdress(currtArray);
        }
    } else if (error == BMK_SEARCH_AMBIGUOUS_ROURE_ADDR){
       // NSLog(@"起始点有歧义");
    } else {
        // 各种情况的判断。。。
    }
}

#pragma mark BMKGeoCodeSearchDelegate
- (void)onGetGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error{
//    NSArray* array = [NSArray arrayWithArray:_mapView.annotations];
//    [_mapView removeAnnotations:array];
//    array = [NSArray arrayWithArray:_mapView.overlays];
//    [_mapView removeOverlays:array];
//    if (error == 0) {
//        _pointAnnotation = [[BMKPointAnnotation alloc]init];
//        _pointAnnotation.coordinate = result.location;
//        _pointAnnotation.title = result.address;
//        [_mapView addAnnotation:_pointAnnotation];
//        _mapView.centerCoordinate = result.location;
//        //移到中心点
//        [self setCenterLocation:result.location];
//    }
}
- (void)onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error {
    NSMutableDictionary *locationInfo = nil;
    if (error == BMK_SEARCH_NO_ERROR) {
        [__poiListAddArray removeAllObjects];
        [__poiListArray removeAllObjects];
        [__poiListPtLa removeAllObjects];
        [__poiListPtLo removeAllObjects];
        for(BMKPoiInfo *poiInfo in result.poiList)
        {
            NSLog(@"%@",poiInfo.name);
            [__poiListArray addObject:poiInfo.name];
            [__poiListAddArray addObject:poiInfo.address];
            NSString *latitudeStr = [NSString stringWithFormat:@"%.15f",poiInfo.pt.latitude];
            NSString *longitudeStr = [NSString stringWithFormat:@"%.15f",poiInfo.pt.longitude];
            [__poiListPtLa addObject:latitudeStr];
            [__poiListPtLo addObject:longitudeStr];
        }

        locationInfo = [NSMutableDictionary dictionary];
        [locationInfo setValue:result.addressDetail.city forKey:@"city"];
        [locationInfo setValue:result.addressDetail.streetNumber forKey:@"streetNumber"];
        [locationInfo setValue:result.addressDetail.streetName forKey:@"streetName"];
        [locationInfo setValue:result.addressDetail.district forKey:@"district"];
        [locationInfo setValue:result.addressDetail.city forKey:@"city"];
        [locationInfo setValue:result.addressDetail.province forKey:@"province"];
        [locationInfo setValue:result.address forKey:@"address"];
        [kUserDefault setObject:result.addressDetail.city forKey:@"cityShop"];
    }
    if (self.reverseGeoCodeResultBlock) {
        self.reverseGeoCodeResultBlock(locationInfo);
    }
}



#pragma mark ----------------------action-------------------------------------
////当前点
//- (void)setPoint:(HsMapLocationPoint)point {
//    _point = point;
//    if(_mapView != nil){
//        [self location:CGPointMake(point.latitude, point.longitude) title:point.title subtitle:point.subtitle];
//    }
//}
////定位
//- (void)location:(CGPoint)location title:(const char *)title subtitle:(const char *)subtitle {
//    if (CGPointEqualToPoint(location, CGPointZero) ) {
//        return;
//    }
//    _location = location;
//    [_mapView removeAnnotation:_pointAnnotation];
//    _pointAnnotation = [[BMKPointAnnotation alloc]init];
//    CLLocationCoordinate2D coor;
//    coor.latitude = location.x;
//    coor.longitude = location.y;
//    _pointAnnotation.coordinate = coor;
//    if (title) {
//        _pointAnnotation.title = [NSString stringWithUTF8String:title];
//    
//    }
//    if (subtitle) {
//        _pointAnnotation.subtitle = [NSString stringWithUTF8String:subtitle];
//    }
//    
//    [_mapView addAnnotation:_pointAnnotation];
//    //移到中心点
//    [self setCenterLocation:coor];
//    
//}

- (void)setCenterLocation:(CLLocationCoordinate2D )center{
    _centerLocation = center;
    [_mapView setCenterCoordinate:center animated:YES];
}
//- (void)clearMap{
//    NSArray *array = [NSArray arrayWithArray:_mapView.annotations];
//    for (BMKPointAnnotation *annotation in array) {
//        if (annotation != _pointAnnotation) {
//            [_mapView removeAnnotation:annotation];
//        }
//    }
//    array = [NSArray arrayWithArray:_mapView.overlays];
//    [_mapView removeOverlays:array];
//}
//#pragma mark 显示公交
//- (void)showBusLines {
//    if (![HsMapViewController locationServicesEnabled]) {
//        [self openGpsSetting];
//        return;
//    }
//    //我的位置
//    BMKPlanNode *start = [[BMKPlanNode alloc]init];
//    start.pt = _userLocation.location.coordinate;
//    
//    //终点
//    BMKPlanNode *end = [[BMKPlanNode alloc]init];
//    end.name = self.endAddress;
//    end.cityName = self.city;
//    CLLocationCoordinate2D endCoor ;
//    endCoor.latitude = _location.x;
//    endCoor.longitude = _location.y;
//    end.pt = endCoor;
//    
//    BMKTransitRoutePlanOption *transitRouteSearchOption = [[BMKTransitRoutePlanOption alloc]init];
//    transitRouteSearchOption.city = self.city;
//    transitRouteSearchOption.from = start;
//    transitRouteSearchOption.to = end;
//    BOOL flag = [_routesearch transitSearch:transitRouteSearchOption];
//    if(flag){
//       // ProgressShowTipMessage(@"公交检索成功");
//    }else{
//        [self showTipsMessage:@"公交站检索失败"];
//    }
//}
//#pragma mark 显示自驾
//- (void)showDriveLines {
//    if (![HsMapViewController locationServicesEnabled]) {
//       [self openGpsSetting];
//        return;
//    }
//    
//    //我的位置
//    BMKPlanNode *start = [[BMKPlanNode alloc]init];
//    start.pt = _userLocation.location.coordinate;
//    start.cityName = self.city;
//    //终点
//    BMKPlanNode *end = [[BMKPlanNode alloc]init];
//    end.name = self.endAddress;
//    end.cityName = self.city;
//    CLLocationCoordinate2D endCoor ;
//    endCoor.latitude = _location.x;
//    endCoor.longitude = _location.y;
//    end.pt = endCoor;
//    
//    BMKDrivingRoutePlanOption *drivingRouteSearchOption = [[BMKDrivingRoutePlanOption alloc]init];
//    drivingRouteSearchOption.from = start;
//    drivingRouteSearchOption.to = end;
//    BOOL flag = [_routesearch drivingSearch:drivingRouteSearchOption];
//    if(flag){
//        //ProgressShowTipMessage(@"自驾检索成功");
//    }else{
//         [self showTipsMessage:@"自驾检索失败"];
//    }
//}
//#pragma mark 显示周边
//- (void)showZhouBian:(NSString *)type {
//    BMKNearbySearchOption *nearSearchOption = [[BMKNearbySearchOption alloc]init];
//    nearSearchOption.pageIndex = 0;
//    nearSearchOption.pageCapacity = 20;
//    //检索我的周边
//    nearSearchOption.location = self.mapView.centerCoordinate;
//    nearSearchOption.keyword = type;
//    BOOL flag = [_poisearch poiSearchNearBy:nearSearchOption];
//    if(flag){
//        //ProgressShowTipMessage(@"周边检索成功");
//    }else{
//       [self showTipsMessage:@"周边检索失败"];
//    }
//}
//
- (void)pointByKeyword:(NSString *)keyword{
    BMKCitySearchOption *geocodeSearchOption = [[BMKCitySearchOption alloc]init];
    geocodeSearchOption.pageIndex = 0;
    geocodeSearchOption.pageCapacity = 20;
    geocodeSearchOption.city= self.city;
    geocodeSearchOption.keyword = keyword;
    BOOL flag= [_poisearch poiSearchInCity:geocodeSearchOption];
    if(flag){
        //ProgressShowTipMessage(@"城市检索成功");
    }else{
        [self showTipsMessage:@"城市检索失败"];
    }

}
- (void)pointByKeywordWithLocation:(CLLocationCoordinate2D)location {
    BMKReverseGeoCodeOption *reverseGeocodeSearchOption = [[BMKReverseGeoCodeOption alloc]init];
    reverseGeocodeSearchOption.reverseGeoPoint = location;
    BOOL flag = [_geocodesearch reverseGeoCode:reverseGeocodeSearchOption];
    if(flag)
    {
        NSLog(@"反geo检索发送成功");
    }
    else
    {
        NSLog(@"反geo检索发送失败");
    }
}
- (CGFloat)meterBetweenMapPoint:(CGPoint)startPoint endPoint:(CGPoint)endPoint {
    BMKMapPoint startMapPoint = BMKMapPointMake(startPoint.x, startPoint.y);
    BMKMapPoint endMapPoint = BMKMapPointMake(endPoint.x, endPoint.y);
    CLLocationDistance dis = BMKMetersBetweenMapPoints(startMapPoint, endMapPoint);
    return dis/1000;
}


- (void)showTipsMessage:(NSString *)message {
   
}


- (void)openGpsSetting {
    //做一个友好的提示
    UIAlertView * alart = [[UIAlertView alloc]initWithTitle:@"打开定位开关" message:@"定位服务未开启，请进入系统【设置】>【隐私】>【定位服务】中打开开关，并允许快快跑呗使用定位服务" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"立即开启",nil];
    alart.tag = 101;
    alart.delegate = self;
    [alart show];
//    if (IOS8ORLate) {
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:
//                              NSLocalizedString( @"定位服务未开启", nil )
//                                                        message: NSLocalizedString( @"去设置开启定位服务?", nil )
//                                                       delegate:self
//                                              cancelButtonTitle: NSLocalizedString( @"不去", nil )
//                                              otherButtonTitles: NSLocalizedString( @"去开启", nil ), nil];
//        
//        [alert show];
//    
//    }else{
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:
//                              NSLocalizedString( @"定位服务未开启", nil )
//                                                        message: NSLocalizedString( @"请到【设置>隐私】开启定位服务", nil )
//                                                       delegate:nil
//                                              cancelButtonTitle: NSLocalizedString( @"知道了", nil )
//                                              otherButtonTitles: nil];
//        
//        [alert show];
//    }
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if(buttonIndex == 1){
        //定位服务设置界面
        NSURL *url = [NSURL URLWithString:@"prefs:root=LOCATION_SERVICES"];
        if ([[UIApplication sharedApplication] canOpenURL:url])
        {
            [[UIApplication sharedApplication] openURL:url];
        }

//        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
    }
}

- (void)mapView:(BMKMapView *)mapView annotationViewForBubble:(BMKAnnotationView *)view {
    if (_onClickedMapAnnotation != nil) {
        self.onClickedMapAnnotation();
    }
}
#pragma mark ----------------------getter-------------------------------------

#pragma mark --------------------------------工具条-----------------------

+ (BOOL)locationServicesEnabled {
    if ([CLLocationManager locationServicesEnabled] &&
        ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorized
         || [CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined)) {
            //定位功能可用，开始定位
            return YES;
        }
    else if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied){
        return NO;
    }
    return YES;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
