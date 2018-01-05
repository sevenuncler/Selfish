//
//  SFShopSelectionCell.m
//  selfish
//
//  Created by He on 2018/1/5.
//  Copyright © 2018年 He. All rights reserved.
//

#import "SFShopSelectionCell.h"

@implementation SFShopSelectionCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.contentView addSubview:self.selectionButton];
        [self.contentView addSubview:self.nameLabel];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.selectionButton.centerY = self.size.height / 2;
    self.selectionButton.left    = 5;
    
    [self.nameLabel sizeToFit];
    self.nameLabel.centerY = self.selectionButton.centerY;
    self.nameLabel.left    = self.selectionButton.right + 5;
}

- (UIButton *)selectionButton {
    if(!_selectionButton) {
        _selectionButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _selectionButton.size = CGSizeMake(40, 40);
        [_selectionButton setImage:[UIImage imageNamed:@"image"] forState:UIControlStateSelected];
    }
    return _selectionButton;
}

- (UILabel *)nameLabel {
    if(!_nameLabel) {
        _nameLabel = [UILabel new];
        _nameLabel.size = CGSizeMake(200, 0);
        _nameLabel.text = @"综合排序";
        _nameLabel.font = [UIFont systemFontOfSize:13];
    }
    return _nameLabel;
}

@end
