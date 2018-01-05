//
//  SULocationManager.h
//  selfish
//
//  Created by He on 2017/12/29.
//  Copyright © 2017年 He. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>
#import <AMapFoundationKit/AMapFoundationKit.h>
#import <AMapLocationKit/AMapLocationKit.h>

@interface SULocation : SUItem
@property(nonatomic,copy) NSString *country;
@property(nonatomic,copy) NSString *province;
@property(nonatomic,copy) NSString *city;
@property(nonatomic,copy) NSString *area;
@property(nonatomic,copy) NSString *street;
@property(nonatomic,strong) CLLocation *location;
@property(nonatomic,strong) AMapLocationReGeocode *reGeocode;
@end

typedef void(^LocationHandler)(SULocation *location);
@interface SULocationManager : NSObject <CLLocationManagerDelegate,MKMapViewDelegate>
@property(nonatomic,strong) CLLocationManager *locationManager;
@property(nonatomic,strong) MKMapView         *mapView;

+ (instancetype)defaultManager;
- (void)locationWithHandler:(LocationHandler)handler;
- (CLLocation *)location;
- (void)stopUpdate;
- (void)reverseLocation:(SULocation * __autoreleasing *)location complectionHandler:(CLGeocodeCompletionHandler)handler;
- (float)getDistance:(float)lat1 lng1:(float)lng1 lat2:(float)lat2 lng2:(float)lng2;

//利用高德地图SDK
- (void)getLocation:(void(^)(CLLocation *location, AMapLocationReGeocode *regeocode, NSError *error))complectionHandler;
@end
