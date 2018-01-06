//
//  SFShopQreaViewModel.m
//  selfish
//
//  Created by He on 2018/1/4.
//  Copyright © 2018年 He. All rights reserved.
//

#import "SFShopQreaViewModel.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "SFCatagoryItem.h"

@implementation SFShopQreaViewModel

static NSString * const reuseID = @"reuseID";
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.item.subAddress.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseID];
    if(!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseID];
    }
    SFDistrictItem *item = [self.item.subAddress objectAtIndex:indexPath.row];
    if(item) {
        cell.textLabel.text = item.name;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    SFDistrictItem *item = [self.item.subAddress objectAtIndex:indexPath.row];
    if(!item.subNeigborhoods || item.subNeigborhoods.count<1) {
        if(self.complectionHandler) {
            self.complectionHandler(item, -1);
        }
        return;
    }else if(self.handler) {
        self.handler(indexPath, item);
    }
}

- (SFCityItem *)item {
    if(!_item) {
        SFCityItem *cityItem = [SFCityItem new];
        cityItem.name = @"杭州";
        NSMutableArray *disArray = [NSMutableArray array];
        {
            SFDistrictItem *item = [SFDistrictItem new];
            item.name = @"滨江";
            NSMutableArray *array = [NSMutableArray array];
            {
                SFNeigborhoodItem *item = [SFNeigborhoodItem new];
                item.name = @"全部";
                [array addObject:item];
            }
            {
                SFNeigborhoodItem *item = [SFNeigborhoodItem new];
                item.name = @"滨江高教园";
                [array addObject:item];
            }
            {
                SFNeigborhoodItem *item = [SFNeigborhoodItem new];
                item.name = @"联庄";
                [array addObject:item];
            }
            {
                SFNeigborhoodItem *item = [SFNeigborhoodItem new];
                item.name = @"龙湖滨江天街";
                [array addObject:item];
            }
            item.subNeigborhoods = array.copy;
            [disArray addObject:item];
        }
        {
            SFDistrictItem *item = [SFDistrictItem new];
            item.name = @"西湖区";
            NSMutableArray *array = [NSMutableArray array];
            {
                SFNeigborhoodItem *item = [SFNeigborhoodItem new];
                item.name = @"全部";
                [array addObject:item];
            }
            {
                SFNeigborhoodItem *item = [SFNeigborhoodItem new];
                item.name = @"转塘";
                [array addObject:item];
            }
            {
                SFNeigborhoodItem *item = [SFNeigborhoodItem new];
                item.name = @"文二路沿线";
                [array addObject:item];
            }
            {
                SFNeigborhoodItem *item = [SFNeigborhoodItem new];
                item.name = @"西溪";
                [array addObject:item];
            }
            item.subNeigborhoods = array.copy;
            [disArray addObject:item];
        }
        
        cityItem.subAddress = disArray.copy;
        _item = cityItem;
    }
    return _item;
}


@end
