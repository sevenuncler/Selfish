//
//  SFAddressItem.h
//  selfish
//
//  Created by He on 2018/1/6.
//  Copyright © 2018年 He. All rights reserved.
//

#import "SUItem.h"


@class SFUUIDItem;

@interface SFStreetItem : NSObject
@property(nonatomic,copy) NSString *name;
@property(nonatomic,copy) NSString *code;
@property(nonatomic,copy) NSString *parentCode;
@property(nonatomic,copy) NSArray<SFUUIDItem *>  *subAddress;
@end

@interface SFNeigborhoodItem : NSObject
@property(nonatomic,copy) NSString *name;
@property(nonatomic,copy) NSString *code;
@property(nonatomic,copy) NSString *parentCode;
@property(nonatomic,copy) NSArray<SFUUIDItem *>  *subAddress;
@end

@interface SFDistrictItem : NSObject
@property(nonatomic,copy) NSString *name;
@property(nonatomic,copy) NSString *code;
@property(nonatomic,copy) NSString *parentCode;
@property(nonatomic,copy) NSArray<SFStreetItem *>  *subAddress;
@property(nonatomic,copy) NSArray<SFNeigborhoodItem *>  *subNeigborhoods;

@end

@interface SFCityItem : NSObject
@property(nonatomic,copy) NSString *name;
@property(nonatomic,copy) NSString *code;
@property(nonatomic,copy) NSString *parentCode;
@property(nonatomic,copy) NSArray<SFDistrictItem *>  *subAddress;
@end

@interface SFProvinceItem : NSObject
@property(nonatomic,copy) NSString *name;
@property(nonatomic,copy) NSString *code;
@property(nonatomic,copy) NSString *parentCode;
@property(nonatomic,copy) NSArray<SFCityItem *>  *subAddress;
@end

@interface SFCountryItem : NSObject
@property(nonatomic,copy) NSString *name;
@property(nonatomic,copy) NSString *code;
@property(nonatomic,copy) NSString *parentCode;
@property(nonatomic,copy) NSArray<SFProvinceItem *>  *subAddress;
@end

@interface SFUUIDItem : NSObject
@property(nonatomic,copy) NSString *name;
@property(nonatomic,copy) NSString *code;
@property(nonatomic,copy) NSString *parentCode;
@end

@interface SFAddressItem : SUItem

@end
