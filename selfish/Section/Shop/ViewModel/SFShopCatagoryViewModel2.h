//
//  SFShopCatagoryViewModel2.h
//  selfish
//
//  Created by He on 2017/11/27.
//  Copyright © 2017年 He. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "SFCatagoryItem.h"

typedef void(^ComplectionHandler)(SFCatagoryItem *catagoryItem, NSInteger subCatagoryIdx);
@interface SFShopCatagoryViewModel2 : NSObject <UITableViewDataSource, UITableViewDelegate>
@property(nonatomic,strong) SFCatagoryItem *item;
@property(nonatomic,copy)   ComplectionHandler      complectionHandler;
@end
