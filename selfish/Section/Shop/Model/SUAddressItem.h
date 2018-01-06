//
//  SUAddressItem.h
//  selfish
//
//  Created by He on 2018/1/6.
//  Copyright © 2018年 He. All rights reserved.
//

#import "SUItem.h"

@class SUCountryItem;
@class SUProvinceItem;
@class SUCityItem;
@class SUDistrictItem;
@class SUStreetItem;
@class SUNeigborhoodItem;
@class SUAddressItem;

@interface SUCountryItem : SUItem
@property(nonatomic,copy) NSString *country;
@property(nonatomic,copy) NSString *countryCode;
@property(nonatomic,copy) NSArray<SUProvinceItem *>  *provinces;
@end

@interface SUProvinceItem : SUCountryItem
@property(nonatomic,copy) NSString *province;
@property(nonatomic,copy) NSString *provinceCode;
@property(nonatomic,copy) NSArray<SUCityItem *>  *cities;
@end

@interface SUCityItem : SUProvinceItem
@property(nonatomic,copy) NSString *city;
@property(nonatomic,copy) NSString *cityCode;
@property(nonatomic,copy) NSArray<SUDistrictItem *>  *districts;
@end

@interface SUDistrictItem : SUCityItem
@property(nonatomic,copy) NSString *district;
@property(nonatomic,copy) NSString *districtCode;
@property(nonatomic,copy) NSArray<SUStreetItem *>  *streets;
@property(nonatomic,copy) NSArray<SUNeigborhoodItem *>  *neigborhoods;
@end

@interface SUStreetItem : SUDistrictItem
@property(nonatomic,copy) NSString *street;
@property(nonatomic,copy) NSString *streetCode;
@property(nonatomic,copy) NSArray<SUAddressItem *>  *addresses;
@end

@interface SUNeigborhoodItem : SUDistrictItem
@property(nonatomic,copy) NSString *neigborhood;
@property(nonatomic,copy) NSString *neigborhoodCode;
@property(nonatomic,copy) NSArray<SUAddressItem *>  *addresses;
@end

@interface SUAddressItem : SUStreetItem

@end
