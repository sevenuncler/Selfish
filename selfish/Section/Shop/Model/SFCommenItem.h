//
//  SFCommenItem.h
//  selfish
//
//  Created by He on 2018/1/7.
//  Copyright © 2018年 He. All rights reserved.
//

#import "SUItem.h"

@interface SFCommenItem : SUItem
@property(nonatomic,copy) NSString *cid;
@property(nonatomic,copy) NSString *to_cid;
@property(nonatomic,copy) NSString *dateString;
@property(nonatomic,copy) NSString *content;
@property(nonatomic,assign) NSInteger likedCount;
@property(nonatomic,assign) NSInteger dislikedCount;
@property(nonatomic,copy)   NSArray<NSString *> *pics;
@property(nonatomic,assign) CGFloat   starLevel;
@end
