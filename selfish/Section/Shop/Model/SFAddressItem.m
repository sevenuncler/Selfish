//
//  SFAddressItem.m
//  selfish
//
//  Created by He on 2018/1/6.
//  Copyright © 2018年 He. All rights reserved.
//

#import "SFAddressItem.h"
@implementation SFStreetItem
@end

@implementation SFNeigborhoodItem
@end

@implementation SFDistrictItem
+(NSDictionary *)objectClassInArray{
    return @{@"subAddress":@"SFStreetItem"};
}
@end

@implementation SFCityItem
+(NSDictionary *)objectClassInArray{
    return @{@"subAddress":@"SFDistrictItem"};
}
@end

@implementation SFProvinceItem

+(NSDictionary *)objectClassInArray{
    return @{@"subAddress":@"SFCityItem"};
}

@end

@implementation SFCountryItem
+(NSDictionary *)objectClassInArray{
    return @{@"subAddress":@"SFProvinceItem"};
}
@end

@implementation SFUUIDItem
@end
@implementation SFAddressItem

@end
