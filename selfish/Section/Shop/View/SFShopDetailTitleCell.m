//
//  SFShopDetailTitleCell.m
//  selfish
//
//  Created by He on 2017/11/26.
//  Copyright © 2017年 He. All rights reserved.
//

#import "SFShopDetailTitleCell.h"
#import "UIView+Layout.h"

@implementation SFShopDetailTitleCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.contentView addSubview:self.shopNameLabel];
        [self.contentView addSubview:self.shopAverageCostLabel];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat padding = 10;
    
    [self.shopNameLabel sizeToFit];
    self.shopNameLabel.left = 2*padding;
    self.shopNameLabel.top  = padding;
    
    [self.shopAverageCostLabel sizeToFit];
    self.shopAverageCostLabel.left = 2*padding;
    self.shopAverageCostLabel.botton = self.contentView.botton - padding;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (UILabel *)shopNameLabel {
    if(!_shopNameLabel) {
        _shopNameLabel = [[UILabel alloc] init];
        _shopNameLabel.text = @"商铺名称（未知）";
        _shopNameLabel.font = [UIFont systemFontOfSize:16];
    }
    return _shopNameLabel;
}

- (UILabel *)shopAverageCostLabel {
    if(!_shopAverageCostLabel) {
        _shopAverageCostLabel = [UILabel new];
        _shopAverageCostLabel.font = [UIFont systemFontOfSize:12];
        _shopAverageCostLabel.text = @"人均：￥9999.99";
        _shopAverageCostLabel.textColor = [UIColor lightGrayColor];
    }
    return _shopAverageCostLabel;
}

@end
