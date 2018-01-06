//
//  SFShopQreaViewModel.h
//  selfish
//
//  Created by He on 2018/1/4.
//  Copyright © 2018年 He. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SFLocationItem.h"
#import "SFAddressItem.h"

@interface SFShopQreaViewModel : NSObject<UITableViewDataSource, UITableViewDelegate>
@property(nonatomic,strong) SFCityItem *item;
@property(nonatomic,copy)   void(^handler)(NSIndexPath *index, SFDistrictItem *item);
@property(nonatomic,copy)   void(^complectionHandler)(SFDistrictItem *item, NSInteger subCatagoryIdx);
@end
