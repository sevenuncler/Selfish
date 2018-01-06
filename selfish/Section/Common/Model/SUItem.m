//
//  SUItem.m
//  selfish
//
//  Created by He on 2017/11/26.
//  Copyright © 2017年 He. All rights reserved.
//

#import "SUItem.h"

@implementation SUItem
+ (NSArray *)ignoredCodingPropertyNames {
    
    return @[@"itemFrame"];
}
@end
