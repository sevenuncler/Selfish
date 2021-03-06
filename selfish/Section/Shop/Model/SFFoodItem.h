//
//  SFFoodItem.h
//  selfish
//
//  Created by He on 2017/12/21.
//  Copyright © 2017年 He. All rights reserved.
//

#import "SUItem.h"

@interface SFFoodItem : SUItem
@property(nonatomic,copy) NSString *fid;
@property(nonatomic,copy) NSString *name;
@property(nonatomic,copy) NSString *desc;
@property(nonatomic,copy) NSArray  *pics;
@property(nonatomic,copy) NSArray  *tags;
@property(nonatomic,assign) CGFloat price;
@property(nonatomic,copy) NSArray  *sizes;
@property(nonatomic,copy) NSString *shop_sid;
@end
