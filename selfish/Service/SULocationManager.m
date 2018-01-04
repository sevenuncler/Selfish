//
//  SULocationManager.m
//  selfish
//
//  Created by He on 2017/12/29.
//  Copyright © 2017年 He. All rights reserved.
//

#import "SULocationManager.h"

@implementation SULocation

@end

@interface SULocationManager()
@property(nonatomic,copy)   LocationHandler   locationHandler;
@end

static BOOL isUpdateLocation = NO;
@implementation SULocationManager

#pragma mark - Public

+ (instancetype)defaultManager {
    static SULocationManager *manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[SULocationManager alloc] init];
    });
    return manager;
}

- (instancetype)init{
    if(self = [super init]) {
        
    }
    return self;
}

- (void)startLocation {
    [self requestAuth];
    [self mapView];
    [self.mapView setShowsUserLocation:YES];
    
}

- (void)stopUpdate {
    self.locationHandler = nil;
    self.mapView = nil;
}

- (void)locationWithHandler:(LocationHandler)handler {
    self.locationHandler = handler;
    [self requestAuth];
    [self mapView];
}

- (CLLocation *)location {
    [self requestAuth];
    [self mapView];
    [self.mapView setShowsUserLocation:YES];
    MKUserLocation *userLocation = self.mapView.userLocation;
    CLLocationCoordinate2D coord = [userLocation coordinate];
    CLLocation *location = [[CLLocation alloc] initWithLatitude:coord.latitude longitude:coord.longitude];
    return location;
}

- (void)reverseLocation:(SULocation * __autoreleasing *)location  complectionHandler:(CLGeocodeCompletionHandler)handler {
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder reverseGeocodeLocation:(*location).location completionHandler:handler];
    
}

-(double)distanceBetweenOrderBy:(double) lat1 :(double) lat2 :(double) lng1 :(double) lng2 {
    CLLocation *curLocation = [[CLLocation alloc] initWithLatitude:lat1 longitude:lng1];
    CLLocation *otherLocation = [[CLLocation alloc] initWithLatitude:lat2 longitude:lng2];
    double  distance  = [curLocation distanceFromLocation:otherLocation];
    return  distance;
    
}

- (double)distanceBetweenLocation:(CLLocation *)from toLocation:(CLLocation *)to {
    double  distance  = [from distanceFromLocation:to];
    return  distance;
}

- (float)getDistance:(float)lat1 lng1:(float)lng1 lat2:(float)lat2 lng2:(float)lng2 {
    //地球半径
    int R = 6378137;
    //将角度转为弧度
    float radLat1 = [self radians:lat1];
    float radLat2 = [self radians:lat2];
    float radLng1 = [self radians:lng1];
    float radLng2 = [self radians:lng2];
    //结果
    float s = acos(cos(radLat1)*cos(radLat2)*cos(radLng1-radLng2)+sin(radLat1)*sin(radLat2))*R;
    //精度
    s = round(s* 10000)/10000;
    return  round(s);
}

- (void)requestAuth {
    if(kCLAuthorizationStatusAuthorizedWhenInUse > [CLLocationManager authorizationStatus] && [[UIDevice currentDevice] systemVersion].floatValue>8.0) { //iOS8.0以下自动弹出定位权限弹框，否则需要手动调用
        [self.locationManager requestWhenInUseAuthorization];
    }
}

#pragma mark - Private

- (float)radians:(float)degrees{
    return (degrees*3.14159265)/180.0;
}

-(void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation{
    CLLocationCoordinate2D coord = [userLocation coordinate];
    if(self.locationHandler) {
        CLLocation *curLocation = [[CLLocation alloc] initWithLatitude:coord.latitude longitude:coord.longitude];
        SULocation *sulocation = [SULocation new];
        sulocation.location = curLocation;
//        [self reverseLocation:&sulocation];
        self.locationHandler(sulocation);
    }
    isUpdateLocation = YES;
}

- (void)mapViewWillStartLoadingMap:(MKMapView *)mapView {
    NSLog(@"%s", __func__);
}


- (CLLocationManager *)locationManager {
    if(!_locationManager) {
        _locationManager = [[CLLocationManager alloc] init];
        _locationManager.delegate = self;
        _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        [_locationManager setDistanceFilter:kCLDistanceFilterNone];

    }
    return _locationManager;
}

- (MKMapView *)mapView {
    if(!_mapView) {
        _mapView = [[MKMapView alloc] init];
            _mapView.delegate = self;
            _mapView.hidden = YES;
            _mapView.userTrackingMode = MKUserTrackingModeFollow;
            [_mapView setShowsUserLocation:YES];
            [_mapView setMapType:MKMapTypeStandard];
    }
    return _mapView;
}
@end
