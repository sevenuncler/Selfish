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

@interface SFShopItem : SUItem
@property(nonatomic,copy)   NSString        *sid;
@property(nonatomic,copy)   NSArray         *pics;
@property(nonatomic,copy)   NSString        *name;
@property(nonatomic,strong) CLLocation      *location;
@property(nonatomic,strong) NSString        *locationName;
@property(nonatomic,copy)   NSArray         *tags;
@property(nonatomic,copy)   NSString        *commentsID;


+ (void)createItemWithDictionary:(NSDictionary *)json;
- (void)createTable;

+ (void)queryByAccountID:(NSString *)sid complection:(Handler)handler;

    
    
@end
