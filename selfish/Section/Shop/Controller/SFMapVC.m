//
//  SFMapVC.m
//  selfish
//
//  Created by He on 2018/1/10.
//  Copyright © 2018年 He. All rights reserved.
//

#import "SFMapVC.h"
#import <AMapFoundationKit/AMapFoundationKit.h>
#import <MAMapKit/MAMapKit.h>
#import <AMapLocationKit/AMapLocationKit.h>
#import <AMapSearchKit/AMapSearchKit.h>

@interface SFMapVC () <MAMapViewDelegate,AMapSearchDelegate>
@property(nonatomic,strong) AMapSearchAPI *search;
@end

@implementation SFMapVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [AMapServices sharedServices].enableHTTPS = YES;
    
    ///初始化地图
    MAMapView *_mapView = [[MAMapView alloc] initWithFrame:self.view.bounds];
    _mapView.delegate = self;

    ///把地图添加至view
    [self.view addSubview:_mapView];
    
    _mapView.showsUserLocation = YES;
    _mapView.distanceFilter = 10;
    _mapView.headingFilter  = 10;
    _mapView.userTrackingMode = MAUserTrackingModeFollow;
    _mapView.zoomLevel = 19;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)mapView:(MAMapView *)mapView didUpdateUserLocation:(MAUserLocation *)location updatingLocation:(BOOL)updatingLocation {
    AMapReGeocodeSearchRequest *regeo = [[AMapReGeocodeSearchRequest alloc] init];
    regeo.location = [AMapGeoPoint locationWithLatitude:location.coordinate.latitude longitude:location.coordinate.longitude];
    regeo.requireExtension = YES;
    //发起逆地理编码
    [self.search AMapReGoecodeSearch:regeo];
}

- (void)mapViewDidFinishLoadingMap:(MAMapView *)mapView {
    
}

- (void)onReGeocodeSearchDone:(AMapReGeocodeSearchRequest *)request response:(AMapReGeocodeSearchResponse *)response {
    if (response.regeocode != nil)
    {
        CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(request.location.latitude, request.location.longitude);
        //添加一根针
//        ReGeocodeAnnotation *reGeocodeAnnotation = [[ReGeocodeAnnotation alloc] initWithCoordinate:coordinate
//                                                                                         reGeocode:response.regeocode];
//
//        [self.mapView addAnnotation:reGeocodeAnnotation];//要添加标注
//        [self.mapView selectAnnotation:reGeocodeAnnotation animated:YES];//标注是否有动画效果
    }
}

- (AMapSearchAPI *)search {
    if(!_search) {
        _search = [[AMapSearchAPI alloc] init];
        _search.delegate = self;
    }
    return _search;
}

@end
