//
//  SFLocationItem.h
//  selfish
//
//  Created by He on 2018/1/6.
//  Copyright © 2018年 He. All rights reserved.
//

#import "SUItem.h"
#import <AMapLocationKit/AMapLocationKit.h>
#import <AMapFoundationKit/AMapFoundationKit.h>
@interface SFLocationItem : SUItem
@property(nonatomic,strong) AMapLocationReGeocode *reGecode;
///纬度
@property (nonatomic, assign) CGFloat latitude;
///经度
@property (nonatomic, assign) CGFloat longitude;
@end
