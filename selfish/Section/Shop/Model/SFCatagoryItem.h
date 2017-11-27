//
//  SFCatagoryItem.h
//  selfish
//
//  Created by He on 2017/11/27.
//  Copyright © 2017年 He. All rights reserved.
//

#import "SUItem.h"

@interface SFSubCatagory : SUItem
@property(nonatomic,strong) NSString   *name;
@property(nonatomic,assign) NSInteger  count;
@end

@interface SFCatagoryItem : SUItem
@property(nonatomic,strong) NSString *name;
@property(nonatomic,copy)   NSArray<SFSubCatagory *>  *subCatagories;
@end
