//
//  SFShopDetailVC.h
//  selfish
//
//  Created by He on 2017/11/26.
//  Copyright © 2017年 He. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SFShopItem.h"

@interface SFShopDetailVC : UITableViewController
@property(nonatomic,strong) NSMutableArray *items;
@property(nonatomic,strong) SFShopItem     *shopItem;
@end
