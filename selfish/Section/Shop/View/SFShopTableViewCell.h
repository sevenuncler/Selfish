//
//  SFShopTableViewCell.h
//  selfish
//
//  Created by He on 2017/11/25.
//  Copyright © 2017年 He. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SFShopTableViewCell : UITableViewCell
@property(nonatomic,strong,readonly) UIImageView *shopCoverImageView;
@property(nonatomic,strong,readonly) UILabel     *shopNameLabel;
@property(nonatomic,strong,readonly) UILabel     *shopTypeLabel;
@property(nonatomic,strong,readonly) UILabel     *shopAvergaeCostLabel;
@property(nonatomic,strong,readonly) UILabel     *shopDistanceLabel;
@property(nonatomic,strong,readonly) UILabel     *shopLocationLabel;
@end
