//
//  SFShopAreaViewModel2.m
//  selfish
//
//  Created by He on 2018/1/6.
//  Copyright © 2018年 He. All rights reserved.
//

#import "SFShopAreaViewModel2.h"
#import "SFShopSelectionCell.h"

@implementation SFShopAreaViewModel2
static NSString * const reuseID = @"reuseID";
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.item.subNeigborhoods.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SFShopSelectionCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseID];
    if(!cell) {
        cell = [[SFShopSelectionCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseID];
        cell.backgroundColor = [UIColor lightGrayColor];
    }
    cell.selectionButton.selected = NO;
    SFNeigborhoodItem *subCatagory = [self.item.subNeigborhoods objectAtIndex:indexPath.row];
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

@end
