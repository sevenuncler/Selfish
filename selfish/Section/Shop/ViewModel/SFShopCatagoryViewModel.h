//
//  SFShopCatagoryViewModel.h
//  selfish
//
//  Created by He on 2017/11/27.
//  Copyright © 2017年 He. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "SFCatagoryItem.h"

typedef void(^HandlerCatagorySelected)(NSIndexPath *index, SFCatagoryItem *item);
typedef void(^ComplectionHandler)(SFCatagoryItem *catagoryItem, NSInteger subCatagoryIdx);
@interface SFShopCatagoryViewModel : NSObject<UITableViewDataSource, UITableViewDelegate>
@property(nonatomic,strong) NSMutableArray<SFCatagoryItem *> *catagories;
@property(nonatomic,copy)   HandlerCatagorySelected handler;
@property(nonatomic,copy)   ComplectionHandler      complectionHandler;
@end
