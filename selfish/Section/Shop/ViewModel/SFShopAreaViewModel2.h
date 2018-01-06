//
//  SFShopAreaViewModel2.h
//  selfish
//
//  Created by He on 2018/1/6.
//  Copyright © 2018年 He. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SFAddressItem.h"

@interface SFShopAreaViewModel2 : NSObject<UITableViewDataSource, UITableViewDelegate>
@property(nonatomic,strong) SFDistrictItem *item;
@property(nonatomic,copy)   void(^complectionHandler)(SFDistrictItem *item, NSInteger subCatagoryIdx);

@end
