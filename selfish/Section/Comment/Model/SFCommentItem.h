//
//  SFCommentItem.h
//  selfish
//
//  Created by He on 2017/12/27.
//  Copyright © 2017年 He. All rights reserved.
//

#import "SUItem.h"

@interface SFCommentItem : SUItem
@property(nonatomic,copy)   NSString    *cid;
@property(nonatomic,copy)   NSString    *shop_sid;
@property(nonatomic,copy)   NSString    *dateString;
@property(nonatomic,copy)   NSString    *content;
@property(nonatomic,assign) NSInteger   likedCount;
@property(nonatomic,assign) NSInteger   dislikedCount;
@property(nonatomic,assign) CGFloat     starLevel;
@property(nonatomic,copy)   NSString    *to_cid;
@property(nonatomic,copy)   NSArray     *pics;
@end
