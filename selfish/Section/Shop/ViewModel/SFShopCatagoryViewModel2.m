//
//  SFShopCatagoryViewModel2.m
//  selfish
//
//  Created by He on 2017/11/27.
//  Copyright © 2017年 He. All rights reserved.
//

#import "SFShopCatagoryViewModel2.h"

@implementation SFShopCatagoryViewModel2
static NSString * const reuseID = @"reuseID";
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.item.subCatagories.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseID];
    if(!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseID];
        cell.backgroundColor = [UIColor lightGrayColor];
    }
    SFSubCatagory *subCatagory = [self.item.subCatagories objectAtIndex:indexPath.row];
    cell.textLabel.text = subCatagory.name;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.complectionHandler) {
        self.item = nil;
        self.complectionHandler(self.item, indexPath.row);
    }
}
@end
