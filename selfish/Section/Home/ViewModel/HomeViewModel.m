//
//  HomeViewModel.m
//  selfish
//
//  Created by He on 2017/11/22.
//  Copyright © 2017年 He. All rights reserved.
//

#import "HomeViewModel.h"
#import "UIView+Layout.h"
#import "HomeViewHeader.h"
#import "HomeTableViewCell.h"

static NSString * const reuseHomeCellIdentifier     = @"reuseID";
static NSString * const reuseHomeHeaderIdentifier   = @"reuseHeader";
@implementation HomeViewModel

#pragma mark - Private

- (CGFloat)cellHeightForItem:(id)sender {
    static HomeTableViewCell *cell;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        cell = [[HomeTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"one"];
    });
    [cell setNeedsLayout];
    [cell layoutIfNeeded];
    return cell.size.height;
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 5;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HomeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseHomeCellIdentifier];
    if(nil == cell) {
        cell = [[HomeTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:reuseHomeCellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor blueColor];
    }
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    HomeViewHeader *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:reuseHomeHeaderIdentifier];
    if(nil == header) {
        header = [[HomeViewHeader alloc] initWithReuseIdentifier:reuseHomeHeaderIdentifier];
    }
    header.textLabel.text = @"主标题";
    UIFont *myFont = [ UIFont fontWithName: @"Arial" size: 18.0 ];
    header.textLabel.font = myFont;
    header.textLabel.textColor = [UIColor redColor];
    header.detailTextLabel.text = @"副标题";
    header.detailTextLabel.font = myFont;
    header.contentView.backgroundColor = [UIColor greenColor];
    return header;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [self cellHeightForItem:nil];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 100;
}


@end
