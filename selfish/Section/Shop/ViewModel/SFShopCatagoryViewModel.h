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

@interface SFShopCatagoryViewModel : NSObject<UITableViewDataSource, UITableViewDelegate>
@property(nonatomic,strong) NSMutableArray<SFCatagoryItem *> *catagories;
@end
