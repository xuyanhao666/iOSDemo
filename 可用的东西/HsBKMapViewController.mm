//
//  HsBKMapViewController.m
//  FastRun
//
//  Created by Macbook on 16/3/10.
//  Copyright © 2016年 SIMPLE PLAN. All rights reserved.
//

#import "HsBKMapViewController.h"
#import <BaiduMapAPI_Map/BMKMapView.h>
#import <BaiduMapAPI_Location/BMKLocationComponent.h>
#import <BaiduMapAPI_Search/BMKSearchComponent.h>
#import <BaiduMapAPI_Base/BMKBaseComponent.h>
#import <BaiduMapAPI_Map/BMKMapComponent.h>
#import <BaiduMapAPI_Cloud/BMKCloudSearchComponent.h>
#import <BaiduMapAPI_Utils/BMKUtilsComponent.h>
#import <BaiduMapAPI_Radar/BMKRadarComponent.h>




@interface RouteAnnotation : BMKPointAnnotation
{
    int _type; ///<0:起点 1：终点 2：公交 3：地铁 4:驾乘 5:途经点
    int _degree;
    
    
}

@property (nonatomic) int type;
@property (nonatomic) int degree;
@end

@implementation RouteAnnotation

@synthesize type = _type;
@synthesize degree = _degree;
@end


@interface HsBKMapViewController ()<BMKMapViewDelegate,BMKLocationServiceDelegate,BMKRouteSearchDelegate>
{
    BMKLocationService *_locService;
    
    BMKRouteSearch *searcher1;
    
    BMKWalkingRoutePlanOption *transitRouteSearchOption;
    BMKPolyline* polyLine;
    
    BMKPointAnnotation *animotion;
    BMKPointAnnotation *animotion2;
    BMKPointAnnotation *animotion3;
    BMKPointAnnotation *animotion4;
    NSDictionary *xyDic;
    BMKLocationService *locService;
    
    BMKRouteSearch *searcher;
}


@property(nonatomic,strong)BMKMapView *mapview;

@end

@implementation HsBKMapViewController

-(void)onGetWalkingRouteResult:(BMKRouteSearch *)searcher result:(BMKWalkingRouteResult *)result errorCode:(BMKSearchErrorCode)error
{
    NSLog(@"%@",result.routes);
    
    
    
    if (error == BMK_SEARCH_NO_ERROR) {
         BMKWalkingRouteLine* plan = (BMKWalkingRouteLine*)[result.routes objectAtIndex:0];
        // 计算路线方案中的路段数目
        NSInteger size = [plan.steps count];
        int planPointCounts = 0;
        for (int i = 0; i < size; i++) {
            BMKWalkingStep* transitStep = [plan.steps objectAtIndex:i];
            if(i==0){
                RouteAnnotation* item = [[RouteAnnotation alloc]init];
                item.coordinate = plan.starting.location;
                item.title = @"您的位置";
                
                item.type = 0;
                
                //[_mapview addAnnotation:item]; // 添加起点标注
                
            }else if(i==size-1){
                RouteAnnotation* item = [[RouteAnnotation alloc]init];
                item.coordinate = plan.terminal.location;
                item.title = @"收货地";
                
                item.type = 1;
                
                
                
                //[_mapview addAnnotation:item]; // 添加终点标注
            }
            //添加annotation节点
            RouteAnnotation* item = [[RouteAnnotation alloc]init];
            item.coordinate = transitStep.entrace.location;
            item.title = transitStep.entraceInstruction;
            item.degree = transitStep.direction * 30;
            item.type = 4;
            //            [_mapview addAnnotation:item];
            
            //轨迹点总数累计
            planPointCounts += transitStep.pointsCount;
        }
        
        
        //轨迹点
        BMKMapPoint * temppoints = new BMKMapPoint[planPointCounts];
        
        int i = 0;
        for (int j = 0; j < size; j++) {
            BMKDrivingStep* transitStep = [plan.steps objectAtIndex:j];
            int k=0;
            for(k=0;k<transitStep.pointsCount;k++) {
                temppoints[i].x = transitStep.points[k].x;
                temppoints[i].y = transitStep.points[k].y;
                i++;
            }
            
        }
        
        // 通过points构建BMKPolyline
        polyLine = [BMKPolyline polylineWithPoints:temppoints count:planPointCounts];
        [_mapview addOverlay:polyLine]; // 添加路线overlay
        //        delete []temppoints;
        [self mapViewFitPolyLine:polyLine];
    }//else
//    {
//        //步行路线
//        BMKWalkingRouteLine* plan = (BMKWalkingRouteLine*)[result.routes objectAtIndex:0];
//        // 计算路线方案中的路段数目
//        NSInteger size = [plan.steps count];
//        int planPointCounts = 0;
//        for (int i = 0; i < size; i++) {
//            BMKDrivingStep* transitStep = [plan.steps objectAtIndex:i];
//            if(i==0){
//                RouteAnnotation* item = [[RouteAnnotation alloc]init];
//                item.coordinate = plan.starting.location;
//                item.title = @"您的位置";
//                
//                item.type = 0;
//                
//                //[_mapview addAnnotation:item]; // 添加起点标注
//                
//            }else if(i==size-1){
//                RouteAnnotation* item = [[RouteAnnotation alloc]init];
//                item.coordinate = plan.terminal.location;
//                item.title = @"收货地";
//                
//                item.type = 1;
//                
//                
//                
//                //[_mapview addAnnotation:item]; // 添加终点标注
//            }
//            //添加annotation节点
//            RouteAnnotation* item = [[RouteAnnotation alloc]init];
//            item.coordinate = transitStep.entrace.location;
//            item.title = transitStep.entraceInstruction;
//            item.degree = transitStep.direction * 30;
//            item.type = 4;
//            //            [_mapview addAnnotation:item];
//            
//            //轨迹点总数累计
//            planPointCounts += transitStep.pointsCount;
//        }
//        
//        
//        //轨迹点
//        BMKMapPoint * temppoints = new BMKMapPoint[planPointCounts];
//        
//        int i = 0;
//        for (int j = 0; j < size; j++) {
//            BMKDrivingStep* transitStep = [plan.steps objectAtIndex:j];
//            int k=0;
//            for(k=0;k<transitStep.pointsCount;k++) {
//                temppoints[i].x = transitStep.points[k].x;
//                temppoints[i].y = transitStep.points[k].y;
//                i++;
//            }
//            
//        }
//        
//        // 通过points构建BMKPolyline
//        polyLine = [BMKPolyline polylineWithPoints:temppoints count:planPointCounts];
//        [_mapview addOverlay:polyLine]; // 添加路线overlay
//        //        delete []temppoints;
//        [self mapViewFitPolyLine:polyLine];
//    }
//    
    
    
}

-(void)creatWalking
{
    
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
    [_mapview setVisibleMapRect:rect];
    _mapview.zoomLevel = _mapview.zoomLevel - 0.3;
}

- (BMKOverlayView*)mapView:(BMKMapView *)map viewForOverlay:(id<BMKOverlay>)overlay
{
    if ([overlay isKindOfClass:[BMKPolyline class]]) {
        BMKPolylineView* polylineView = [[BMKPolylineView alloc] initWithOverlay:overlay];
        polylineView.fillColor = [[UIColor alloc] initWithRed:0 green:1 blue:1 alpha:1];
        polylineView.strokeColor = [[UIColor alloc] initWithRed:0 green:0 blue:1 alpha:0.7];
        polylineView.lineWidth = 1.5;
        return polylineView;
    }
    return nil;
}
-(BMKAnnotationView*)mapView:(BMKMapView *)mapView viewForAnnotation:(id<BMKAnnotation>)annotation
{
    if ([annotation isKindOfClass:[BMKPointAnnotation class]]) {
        BMKPinAnnotationView *newAnnotationView = [[BMKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"myAnnotation"];
        if (annotation == animotion) {
             newAnnotationView.image = [UIImage imageNamed:@"mayi_11@2x"];
           
        }else if (annotation == animotion2){
            newAnnotationView.image = [UIImage imageNamed:@"icon_nav_start_1"];
        }else if (annotation == animotion3){
            newAnnotationView.image = [UIImage imageNamed:@"icon_nav_end_1"];
        }else if (annotation == animotion4)
        {
            //newAnnotationView.image = [UIImage imageNamed:@"icon_nav_end_1"];
            UIView *viewForImaget=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
            UIImageView *iconImaget = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
            iconImaget.layer.cornerRadius = iconImaget.frame.size.height / 2;
            iconImaget.layer.borderColor = [UIColor clearColor].CGColor;
            iconImaget.layer.borderWidth = 1.0;
            iconImaget.clipsToBounds = YES;
            [iconImaget setImage:[UIImage imageNamed:@"butter-iocation@3x"]];
            [viewForImaget addSubview:iconImaget];
            newAnnotationView.image = [self getImageFromView:viewForImaget];
        }
        else{

            
        }
        newAnnotationView.canShowCallout = YES;
        return newAnnotationView;
    }
    return nil;
}
-(UIImage *)getImageFromView:(UIView *)view{
    UIGraphicsBeginImageContext(view.bounds.size);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}



-(void)setup
{
    _mapview = [[BMKMapView alloc]init];
    _mapview.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    _mapview.delegate=self;
    [self addSubview:_mapview];
    [_mapview setCenterCoordinate:_recodeCoor animated:YES];
    [_mapview setZoomLevel:17];
    [self dingwei];
    animotion2 = [[BMKPointAnnotation alloc]init];
    animotion2.coordinate = _recodeCoor;
    [_mapview addAnnotation:animotion2];
    animotion3 = [[BMKPointAnnotation alloc]init];
    animotion3.coordinate = _sendCoor;
    [_mapview addAnnotation:animotion3];
    animotion = [[BMKPointAnnotation alloc]init];
    animotion.coordinate = _xpeople;
    [_mapview addAnnotation:animotion];
    BMKPlanNode *start = [[BMKPlanNode alloc]init];
    CLLocationCoordinate2D coor1;
    float one =[[NSString stringWithFormat:@"%.6f",_recodeCoor.latitude]doubleValue];
    float two = [[NSString stringWithFormat:@"%.6f",_recodeCoor.longitude]doubleValue];
    coor1.latitude = one;
    coor1.longitude = two;
    start.pt = coor1;;
    transitRouteSearchOption.from = start;
//    start.cityName = @"郑州市";
    BMKPlanNode *end = [[BMKPlanNode alloc]init];
    CLLocationCoordinate2D coor2;
    float three =[[NSString stringWithFormat:@"%.6f",_sendCoor.latitude]doubleValue];
    float four = [[NSString stringWithFormat:@"%.6f",_sendCoor.longitude]doubleValue];
    coor2.latitude = three;
    coor2.longitude = four;
    end.pt = coor2;
    
    transitRouteSearchOption.to = end;
//     end.cityName = @"郑州市";
    searcher = [[BMKRouteSearch alloc]init];
    searcher.delegate = self;
    
    BOOL flag = [searcher walkingSearch:transitRouteSearchOption];
    
    if (flag) {
        NSLog(@"cehngg");
    }

}
-(void)dingwei{
    //初始化BMKLocationService
    if (_locService == nil) {
        _locService = [[BMKLocationService alloc]init];
        _locService.delegate = self;
        //启动LocationService
        [_locService startUserLocationService];
        transitRouteSearchOption = [[BMKWalkingRoutePlanOption alloc]init];
        
        animotion4 = [[BMKPointAnnotation alloc]init];
        [_mapview addAnnotation:animotion4];
    }
}
#pragma mark BMKLocationServiceDelegate
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{
    animotion4.coordinate = userLocation.location.coordinate;
    [_locService stopUserLocationService];
    
    
}

-(void)creatMap
{
    
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
