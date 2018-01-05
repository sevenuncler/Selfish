//
//  SFShopSortViewModel.h
//  selfish
//
//  Created by He on 2018/1/4.
//  Copyright © 2018年 He. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SFCatagoryItem.h"

@interface SFShopSortViewModel : NSObject<UITableViewDataSource, UITableViewDelegate>
@property(nonatomic,strong) NSMutableArray<SFCatagoryItem *> *catagories;

@end
