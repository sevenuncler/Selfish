//
//  SFShopCatagoryViewModel2.m
//  selfish
//
//  Created by He on 2017/11/27.
//  Copyright © 2017年 He. All rights reserved.
//

#import "SFShopCatagoryViewModel2.h"
#import "SFShopSelectionCell.h"

@implementation SFShopCatagoryViewModel2
static NSString * const reuseID = @"reuseID";
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.item.subCatagories.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SFShopSelectionCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseID];
    if(!cell) {
        cell = [[SFShopSelectionCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseID];
        cell.backgroundColor = [UIColor lightGrayColor];
    }
    cell.selectionButton.selected = NO;
    SFSubCatagory *subCatagory = [self.item.subCatagories objectAtIndex:indexPath.row];
    cell.nameLabel.text = subCatagory.name;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    SFShopSelectionCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.selectionButton.selected = YES;
    if (self.complectionHandler) {
        self.complectionHandler(self.item, indexPath.row);
    }
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    SFShopSelectionCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.selectionButton.selected = NO;
}

- (void)setItem:(SFCatagoryItem *)item {
    if(_item != item) {
        _item = item;
    }
}
@end
