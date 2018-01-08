//
//  SFShopItem.h
//  selfish
//
//  Created by He on 2017/11/26.
//  Copyright © 2017年 He. All rights reserved.
//

#import "SUItem.h"
#import <CoreLocation/CoreLocation.h>
#import "SFLocationItem.h"
#import "SFCommentItem.h"
#import "SFFoodItem.h"

@class SUSQLManager;

typedef NS_ENUM(NSInteger, SFShopType) {
    SFShopTypeDefault    = 0,
    SFShopTypeFood       = 1,
    SFShopTypeEnternment = 2
};

typedef NS_ENUM(NSInteger, SFShopSubType) {
    SFShopFoodSubTypeDefault = 0
};

@interface SFShopQueryItem : NSObject
@property(nonatomic,assign) SFShopType *type;     //种类
@property(nonatomic,strong) CLLocation *location; //区域
@property(nonatomic,assign) NSInteger  distance;
@property(nonatomic,copy)   NSString   *sortName; //排序类型，（综合类型、好评优先、离我最近、人均最低）
@property(nonatomic,copy)   NSString   *keyWords;
@property(nonatomic,assign) NSInteger  page;
@property(nonatomic,assign) NSInteger  offset;
@end

@interface SFShopTypeItem : NSObject
@property(nonatomic,copy) NSString *type;
@property(nonatomic,copy) NSString *subType;
@end

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
@property(nonatomic,copy)   NSArray<SFFoodItem *>   *foods;
@property(nonatomic,strong) SFShopTypeItem  *shopType;
@property(nonatomic,strong) SFLocationItem  *locationItem;
@property(nonatomic,copy)   NSArray<SFCommentItem *> *comments;

+ (void)createItemWithDictionary:(NSDictionary *)json;
+ (void)queryByAccountID:(NSString *)sid complection:(Handler)handler;
- (void)createTable;
- (NSString *)stringOfTag;
//- (NSString *)stringOfFoodWithSpace;

@end
