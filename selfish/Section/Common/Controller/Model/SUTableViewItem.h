//
//  SUTableViewItem.h
//  selfish
//
//  Created by He on 2017/11/26.
//  Copyright © 2017年 He. All rights reserved.
//

#import "SUItem.h"

@interface SUTableViewItem : SUItem
@property(nonatomic,strong) SUItem                   *headerItem;
@property(nonatomic,strong) NSMutableArray<SUItem *> *rowItems;
@property(nonatomic,strong) SUItem                   *footerItem;
@end
