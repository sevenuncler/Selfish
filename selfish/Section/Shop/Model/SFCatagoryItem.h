//
//  SFCatagoryItem.h
//  selfish
//
//  Created by He on 2017/11/27.
//  Copyright © 2017年 He. All rights reserved.
//

#import "SUItem.h"


@class SFSubCatagory;

@interface SFCatagoryItem : SUItem
@property(nonatomic,strong) NSString *name;
@property(nonatomic,copy)   NSArray<SFSubCatagory *>  *subCatagories;
@end

@interface SFSubCatagory : SUItem
@property(nonatomic,strong) NSString   *name;
@property(nonatomic,assign) NSInteger  count;
@end
