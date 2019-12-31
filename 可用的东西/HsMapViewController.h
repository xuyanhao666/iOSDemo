//
//  HsMapViewController.h
//  Hundsun_InternetSellTicket
//
//  Created by 王金东 on 15/6/19.
//  Copyright (c) 2015年 王金东. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <BaiduMapAPI_Map/BMKMapView.h>
#import <BaiduMapAPI_Location/BMKLocationComponent.h>
#import <BaiduMapAPI_Search/BMKSearchComponent.h>
#import <BaiduMapAPI_Base/BMKBaseComponent.h>
#import <BaiduMapAPI_Map/BMKMapComponent.h>
#import <BaiduMapAPI_Cloud/BMKCloudSearchComponent.h>
#import <BaiduMapAPI_Utils/BMKUtilsComponent.h>
#import <BaiduMapAPI_Radar/BMKRadarComponent.h>
#import <CoreLocation/CoreLocation.h>


typedef struct HsMapLocationPoint {
    CGFloat latitude, longitude;
    const char *title , *subtitle;
    
} HsMapLocationPoint;

UIKIT_STATIC_INLINE HsMapLocationPoint HsMapLocationPointMake(CGFloat latitude, CGFloat longitude, const char *title, const char *subtitle) {
    HsMapLocationPoint point = {latitude, longitude, title, subtitle};
    return point;
}


@interface HsMapViewController : UIViewController

@property (weak, nonatomic) IBOutlet BMKMapView *mapView;

@property (nonatomic,strong) NSString *endAddress;
@property (nonatomic,strong) NSString *city;

//地图缩放级别
@property (nonatomic,assign) CGFloat zoomLevel;

//缩放后右侧菜单布局
@property (nonatomic,assign) UIEdgeInsets scaleRightToolsInsets;
//是否缩放 YES 表示处于缩放状态 NO表示全屏状态
@property (nonatomic,assign) BOOL scale;
//缩放地图
@property (nonatomic,copy) void(^scaleViewBlock)(BOOL selected);
//点击地图
@property (copy, nonatomic) void(^onClickedMapBlank)(void);
//点击标注
@property (copy, nonatomic) void(^onClickedMapAnnotation)(void);

//地图中心点
@property (copy, nonatomic) void(^mapCenterBlock)(CLLocationCoordinate2D point);
@property (copy, nonatomic) void(^reverseGeoCodeResultBlock)(NSDictionary *addressInfo);
//地图刚要滑动
@property (copy, nonatomic) void(^mapWillChange)(void);
//poi检索
@property (copy, nonatomic) void(^poicityAdress)(NSMutableArray *currtArray);
//是否显示用户信息
@property (nonatomic,assign) BOOL showsUserLocation;
/**
 *  @author wangjindong, 15-06-29 10:06:32
 *
 *  @brief  是否显示工具条
 *
 *  @since 1.0
 */
@property (nonatomic,assign) BOOL showTools;

/**
 *  @author wangjindong, 15-06-24 09:06:30
 *
 *  @brief  给地图设置一个点
 *
 *  @param location 经纬度
 *  @param title    点击大头针显示的标题
 *  @param subtitle 点击大头针显示的子标题
 *
 *  @since 1.0
 */
@property (nonatomic,assign) HsMapLocationPoint point;
//关键字检索
- (void)pointByKeyword:(NSString *)keyword;
//来判断是哪里的数值
@property (nonatomic,assign)BOOL isSearch;
//关键信息存入数组
@property (nonatomic,strong)NSMutableArray *_poiListArray;
@property (nonatomic,strong)NSMutableArray *_poiListAddArray;
@property (nonatomic,strong)NSMutableArray *_poiListPtLa;
@property (nonatomic,strong)NSMutableArray *_poiListPtLo;
-(void)currentPoi:(NSArray *)coor;
-(void)dingwei;
-(void)fangda;
-(void)suoxiao;
@end
