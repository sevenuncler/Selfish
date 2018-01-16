//
//  SFShopTypeItem.h
//  selfish
//
//  Created by He on 2018/1/16.
//  Copyright © 2018年 He. All rights reserved.
//

#import "SUItem.h"

@interface SFShopSubType1 : NSObject
@property(nonatomic,copy) NSString *name;
@end

@interface SFShopType1 : SUItem
@property(nonatomic,copy) NSString *name;
@property(nonatomic,strong) NSArray<SFShopSubType1 *> *subTypes;
@end
