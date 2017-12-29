//
//  SULocationManager.m
//  selfish
//
//  Created by He on 2017/12/29.
//  Copyright © 2017年 He. All rights reserved.
//

#import "SULocationManager.h"


@implementation SULocationManager

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
        [self mapView];
    }
    return self;
}

- (void)startLocation {
    [self.mapView setShowsUserLocation:YES];
}

-(void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation{
    CLLocationCoordinate2D coord = [userLocation coordinate];
    NSLog(@"经度:%f,纬度:%f",coord.latitude,coord.longitude);
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
        [_mapView setShowsUserLocation:YES];
        [_mapView setMapType:MKMapTypeStandard];
    }
    return _mapView;
}
@end
