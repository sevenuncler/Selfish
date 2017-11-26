//
//  SFShopTableViewCell.m
//  selfish
//
//  Created by He on 2017/11/25.
//  Copyright © 2017年 He. All rights reserved.
//

#import "SFShopTableViewCell.h"
#import "UIView+Layout.h"

#define PADDING 10
#define SHOP_NAME_FONT_SIZE 16
#define SHOP_TYPE_FONT_SIZE 12
#define SHOP_LOC_FONT_SIZE          SHOP_TYPE_FONT_SIZE
#define SHOP_DISTANCE_FONT_SIEZE    SHOP_TYPE_FONT_SIZE
#define SHOP_AVERGAE_FONT_SIZE      SHOP_TYPE_FONT_SIZE

@implementation SFShopTableViewCell

@synthesize shopCoverImageView      = _shopCoverImageView;
@synthesize shopNameLabel           = _shopNameLabel;
@synthesize shopTypeLabel           = _shopTypeLabel;
@synthesize shopAvergaeCostLabel    = _shopAvergaeCostLabel;
@synthesize shopDistanceLabel       = _shopDistanceLabel;
@synthesize shopLocationLabel       = _shopLocationLabel;

//从代码创建时默认调用此方法
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.contentView addSubview:self.shopCoverImageView];
        [self.contentView addSubview:self.shopNameLabel];
        [self.contentView addSubview:self.shopTypeLabel];
        [self.contentView addSubview:self.shopDistanceLabel];
        [self.contentView addSubview:self.shopAvergaeCostLabel];
        [self.contentView addSubview:self.shopLocationLabel];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    //封面
    CGFloat height = self.size.height - 2*PADDING;
    self.shopCoverImageView.frame = CGRectMake(PADDING, PADDING, height/0.7, height);
    
    //名称
    [self.shopNameLabel sizeToFit];
    self.shopNameLabel.left = self.shopCoverImageView.right + PADDING;
    self.shopNameLabel.top  = self.shopCoverImageView.top;
    
    //类型
    [self.shopTypeLabel sizeToFit];
    self.shopTypeLabel.left     = self.shopCoverImageView.right + PADDING;
    self.shopTypeLabel.botton   = self.shopCoverImageView.botton;
    
    //地点
    [self.shopLocationLabel sizeToFit];
    self.shopLocationLabel.left     = self.shopTypeLabel.right + PADDING;
    self.shopLocationLabel.botton   = self.shopCoverImageView.botton;
    
    //人均
    [self.shopAvergaeCostLabel sizeToFit];
    self.shopAvergaeCostLabel.right = self.contentView.right - PADDING;
    self.shopAvergaeCostLabel.centerY = self.contentView.centerY;
    
    //距离
    [self.shopDistanceLabel sizeToFit];
    self.shopDistanceLabel.right = self.contentView.right - PADDING;
    self.shopDistanceLabel.botton = self.shopCoverImageView.botton;
}

#pragma mark - Getter & Setter

- (UIImageView *)shopCoverImageView {
    if(!_shopCoverImageView) {
        _shopCoverImageView = [[UIImageView alloc] init];
        _shopCoverImageView.image = [UIImage imageNamed:@"image"];
    }
    return _shopCoverImageView;
}

- (UILabel *)shopNameLabel {
    if(!_shopNameLabel) {
        _shopNameLabel = [UILabel new];
        _shopNameLabel.text = @"商店名称（未知）";
        _shopNameLabel.font = [UIFont systemFontOfSize:SHOP_NAME_FONT_SIZE];
    }
    return _shopNameLabel;
}

- (UILabel *)shopTypeLabel {
    if(!_shopTypeLabel) {
        _shopTypeLabel = [UILabel new];
        _shopTypeLabel.text = @"商铺类型";
        _shopTypeLabel.font = [UIFont systemFontOfSize:SHOP_TYPE_FONT_SIZE];
        _shopTypeLabel.textColor = [UIColor lightGrayColor];
    }
    return _shopTypeLabel;
}

- (UILabel *)shopDistanceLabel {
    if(!_shopDistanceLabel) {
        _shopDistanceLabel = [UILabel new];
        _shopDistanceLabel.text = @"9999.9999km";
        _shopDistanceLabel.font = [UIFont systemFontOfSize:SHOP_TYPE_FONT_SIZE];
        _shopDistanceLabel.textColor = [UIColor lightGrayColor];
    }
    return _shopDistanceLabel;
}

- (UILabel *)shopAvergaeCostLabel {
    if(!_shopAvergaeCostLabel) {
        _shopAvergaeCostLabel = [UILabel new];
        _shopAvergaeCostLabel.text = @"人均￥999";
        _shopAvergaeCostLabel.font = [UIFont systemFontOfSize:SHOP_TYPE_FONT_SIZE];
        _shopAvergaeCostLabel.textColor = [UIColor lightGrayColor];
    }
    return _shopAvergaeCostLabel;
}

- (UILabel *)shopLocationLabel {
    if(!_shopLocationLabel) {
        _shopLocationLabel = [UILabel new];
        _shopLocationLabel.text = @"就餐地址（未知）";
        _shopLocationLabel.font = [UIFont systemFontOfSize:SHOP_TYPE_FONT_SIZE];
        _shopLocationLabel.textColor = [UIColor lightGrayColor];
    }
    return _shopLocationLabel;
}

@end
