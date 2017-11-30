//
//  SFShopCatagoryViewModel.m
//  selfish
//
//  Created by He on 2017/11/27.
//  Copyright © 2017年 He. All rights reserved.
//

#import "SFShopCatagoryViewModel.h"

@implementation SFShopCatagoryViewModel

static NSString * const reuseID = @"reuseID";
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.catagories.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseID];
    if(!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseID];
    }
    SFCatagoryItem *item = [self.catagories objectAtIndex:indexPath.row];
    cell.textLabel.text = item.name;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    SFCatagoryItem *item = [self.catagories objectAtIndex:indexPath.row];
    if(!item.subCatagories || item.subCatagories.count<1) {
        if(self.complectionHandler) {
            self.complectionHandler(item, -1);
        }
        return;
    }else if(self.handler) {
        self.handler(indexPath, item);
    }
}

- (NSMutableArray *)catagories {
    if(!_catagories) {
        _catagories = [NSMutableArray array];
        {
            SFCatagoryItem *catagoryItem = [SFCatagoryItem new];
            catagoryItem.name = @"美食";
            NSMutableArray *items = @[].mutableCopy;
            {
                SFSubCatagory *subCatagory = [SFSubCatagory new];
                subCatagory.name = @"火锅";
                subCatagory.count = 999;
                [items addObject:subCatagory];
            }
            {
                SFSubCatagory *subCatagory = [SFSubCatagory new];
                subCatagory.name = @"干锅";
                subCatagory.count = 999;
                [items addObject:subCatagory];
            }
            {
                SFSubCatagory *subCatagory = [SFSubCatagory new];
                subCatagory.name = @"烤鱼";
                subCatagory.count = 999;
                [items addObject:subCatagory];
            }
            {
                SFSubCatagory *subCatagory = [SFSubCatagory new];
                subCatagory.name = @"火锅";
                subCatagory.count = 999;
                [items addObject:subCatagory];
            }
            {
                SFSubCatagory *subCatagory = [SFSubCatagory new];
                subCatagory.name = @"干锅";
                subCatagory.count = 999;
                [items addObject:subCatagory];
            }
            {
                SFSubCatagory *subCatagory = [SFSubCatagory new];
                subCatagory.name = @"烤鱼";
                subCatagory.count = 999;
                [items addObject:subCatagory];
            }
            catagoryItem.subCatagories = items.copy;
            [_catagories addObject:catagoryItem];
        }
        {
            SFCatagoryItem *catagoryItem = [SFCatagoryItem new];
            catagoryItem.name = @"娱乐";
            NSMutableArray *items = @[].mutableCopy;
            {
                SFSubCatagory *subCatagory = [SFSubCatagory new];
                subCatagory.name = @"KTV";
                subCatagory.count = 999;
                [items addObject:subCatagory];
            }
            {
                SFSubCatagory *subCatagory = [SFSubCatagory new];
                subCatagory.name = @"看书";
                subCatagory.count = 999;
                [items addObject:subCatagory];
            }
            {
                SFSubCatagory *subCatagory = [SFSubCatagory new];
                subCatagory.name = @"逛商场";
                subCatagory.count = 999;
                [items addObject:subCatagory];
            }
            {
                SFSubCatagory *subCatagory = [SFSubCatagory new];
                subCatagory.name = @"看书";
                subCatagory.count = 999;
                [items addObject:subCatagory];
            }
            {
                SFSubCatagory *subCatagory = [SFSubCatagory new];
                subCatagory.name = @"逛商场";
                subCatagory.count = 999;
                [items addObject:subCatagory];
            }
            catagoryItem.subCatagories = items.copy;
            [_catagories addObject:catagoryItem];
        }
        [_catagories addObjectsFromArray:_catagories];
        [_catagories addObjectsFromArray:_catagories];
        [_catagories addObjectsFromArray:_catagories];
        {
            SFCatagoryItem *catagoryItem = [SFCatagoryItem new];
            catagoryItem.name = @"全部分类";
            [_catagories insertObject:catagoryItem atIndex:0];
        }
    }
    return _catagories;
}

@end
