//
//  SFShopItem.h
//  selfish
//
//  Created by He on 2017/11/26.
//  Copyright © 2017年 He. All rights reserved.
//

#import "SUItem.h"
#import <CoreLocation/CoreLocation.h>

@class SUSQLManager;

typedef NS_ENUM(NSInteger, SFShopType) {
    SFShopTypeDefault    = 0,
    SFShopTypeFood       = 1,
    SFShopTypeEnternment = 2
};

@interface SFShopItem : SUItem
@property(nonatomic,copy)   NSString        *sid;
@property(nonatomic,copy)   NSArray         *pics;
@property(nonatomic,copy)   NSString        *name;
@property(nonatomic,strong) NSString        *announcement;
@property(nonatomic,assign) CGFloat         longtitude;
@property(nonatomic,assign) CGFloat         latitude;
@property(nonatomic,strong) NSString        *locationName;
@property(nonatomic,copy)   NSArray         *tags;
@property(nonatomic,copy)   NSString        *commentsID;
@property(nonatomic,copy)   NSString        *accout_aid;
@property(nonatomic,assign) CGFloat         averageCost;
@property(nonatomic,assign) CGFloat         starLevel;
@property(nonatomic,assign) SFShopType      type;
@property(nonatomic,copy)   NSArray         *foods;

+ (void)createItemWithDictionary:(NSDictionary *)json;
+ (void)queryByAccountID:(NSString *)sid complection:(Handler)handler;
- (void)createTable;
- (NSString *)stringOfTag;
- (NSString *)stringOfFoodWithSpace;

@end
