//
//  SFShopDetailMenuCell.m
//  selfish
//
//  Created by He on 2017/11/26.
//  Copyright © 2017年 He. All rights reserved.
//

#import "SFShopDetailMenuCell.h"
#import "UIView+Layout.h"

@implementation SFShopDetailMenuCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.contentView addSubview:self.menuLabel];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat padding = 15;
    
    self.menuLabel.size = CGSizeMake(self.contentView.size.width - 2*padding, 0);
    [self.menuLabel sizeToFit];
    self.menuLabel.left = padding;
    self.menuLabel.top  = padding;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (UILabel *)menuLabel {
    if(!_menuLabel) {
        _menuLabel = [UILabel new];
        _menuLabel.text = @"梅干菜 扣肉 红烧鱼 红烧肉 永康肉麦饼 烤鱼 干锅 火锅 拌饭 卤肉饭 哈尔滨快餐 砂锅 过桥米线 酸菜鸡杂米线"; //我饿了
        _menuLabel.font = [UIFont systemFontOfSize:13];
        _menuLabel.numberOfLines = 2;
    }
    return _menuLabel;
}

@end
