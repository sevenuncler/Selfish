//
//  SFShopCustomeFoodRowView.m
//  selfish
//
//  Created by He on 2017/12/2.
//  Copyright © 2017年 He. All rights reserved.
//

#import "SFShopCustomeFoodRowView.h"

@implementation SFShopCustomeFoodRowView

- (instancetype)initWithFrame:(CGRect)frame {
    if(self = [super initWithFrame:frame]) {
        [self addSubview:self.namelabel];
        [self addSubview:self.contentView];
        [self addSubview:self.rightButton];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGFloat padding = 15;
    
    [self.namelabel sizeToFit];
    self.namelabel.left = padding;
    self.namelabel.centerY = self.size.height / 2;
    
    [self.contentView sizeToFit];
    self.contentView.left    = 100;
    self.contentView.centerY = self.namelabel.centerY;
    
    self.rightButton.size    = CGSizeMake(20, 20);
    self.rightButton.right   = self.size.width - padding;
    self.rightButton.centerY =  self.contentView.centerY;
}

#pragma mark - Getter

- (UILabel *)namelabel {
    if(!_namelabel) {
        _namelabel = [[UILabel alloc] init];
        _namelabel.text = @"类目";
    }
    return _namelabel;
}

- (UIButton *)rightButton {
    if(!_rightButton) {
        _rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_rightButton setImage:[UIImage imageNamed:@"image"] forState:UIControlStateNormal];
    }
    return _rightButton;
}

- (UILabel *)contentView {
    if(!_contentView) {
        _contentView = [UILabel new];
        _contentView.text = @"内容";
    }
    return _contentView;
}



@end
