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

@interface SULocationManager : NSObject <CLLocationManagerDelegate,MKMapViewDelegate>
@property(nonatomic,strong) CLLocationManager *locationManager;
@property(nonatomic,strong) MKMapView         *mapView;

+ (instancetype)defaultManager;
- (void)startLocation;

@end
