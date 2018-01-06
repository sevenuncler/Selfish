//
//  SFCatagoryItem.h
//  selfish
//
//  Created by He on 2017/11/27.
//  Copyright © 2017年 He. All rights reserved.
//

#import "SUItem.h"


@class SFSubCatagory;

@class SFSubCatagory;

@interface SFCatagoryItem : SUItem
@property(nonatomic,strong) NSString *name;

@property(nonatomic,copy)   NSArray<SFSubCatagory *>  *subCatagories;
@end

@interface SFSubCatagory : SFCatagoryItem
@property(nonatomic,strong) NSString   *subName;
@property(nonatomic,assign) NSInteger  count;
@end
