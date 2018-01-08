//
//  SFShopDetailCoverCell.m
//  selfish
//
//  Created by He on 2017/11/26.
//  Copyright © 2017年 He. All rights reserved.
//

#import "SFShopDetailCoverCell.h"
#import "UIView+Layout.h"

#define PADDING 10
@implementation SFShopDetailCoverCell

@synthesize coverImageView  = _coverImageView;
@synthesize picNumberButton = _picNumberButton;

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.contentView addSubview:self.coverImageView];
        [self.contentView addSubview:self.picNumberButton];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    //
    self.coverImageView.size = self.contentView.size;
    self.coverImageView.left = 0;
    self.coverImageView.top  = 0;
    
    //
    self.picNumberButton.size   = CGSizeMake(40, 40);
    self.picNumberButton.layer.cornerRadius = 20;
    self.picNumberButton.clipsToBounds = YES;
    self.picNumberButton.right  = self.contentView.right  - 10;
    self.picNumberButton.botton = self.contentView.botton - 2*PADDING;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - Getter & Setter

- (UIImageView *)coverImageView {
    if(!_coverImageView) {
        _coverImageView = [[UIImageView alloc] init];
        _coverImageView.image = [UIImage imageNamed:@"image"];
    }
    return _coverImageView;
}

- (UIButton *)picNumberButton {
    if(!_picNumberButton) {
        _picNumberButton = [UIButton buttonWithType:UIButtonTypeCustom];
//        [_picNumberButton setImage:[UIImage imageNamed:@"image"] forState:UIControlStateNormal];
        [_picNumberButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _picNumberButton.titleLabel.font = [UIFont systemFontOfSize:8];
    }
    return _picNumberButton;
}

@end
