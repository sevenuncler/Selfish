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

typedef void(^LocationHandler)(CLLocation *location);
@interface SULocationManager : NSObject <CLLocationManagerDelegate,MKMapViewDelegate>
@property(nonatomic,strong) CLLocationManager *locationManager;
@property(nonatomic,strong) MKMapView         *mapView;

+ (instancetype)defaultManager;
- (void)locationWithHandler:(LocationHandler)handler;
- (CLLocation *)location;

- (float)getDistance:(float)lat1 lng1:(float)lng1 lat2:(float)lat2 lng2:(float)lng2;

@end
