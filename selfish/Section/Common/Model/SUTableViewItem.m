//
//  SUTableViewItem.m
//  selfish
//
//  Created by He on 2017/11/26.
//  Copyright © 2017年 He. All rights reserved.
//

#import "SUTableViewItem.h"

@implementation SUTableViewItem


- (NSMutableArray<SUItem *> *)rowItems {
    if(!_rowItems) {
        _rowItems = [NSMutableArray arrayWithCapacity:9];
    }
    return _rowItems;
}
@end
