//
//  SFShopCatagoryToolBarView.m
//  selfish
//
//  Created by He on 2017/11/27.
//  Copyright © 2017年 He. All rights reserved.
//

#import "SFShopCatagoryToolBarView.h"
#import "UIView+Layout.h"

@implementation SFShopCatagoryToolBarView

- (instancetype)initWithFrame:(CGRect)frame {
    if(self = [super initWithFrame:frame]) {
        [self addSubview:self.leftButton];
        [self addSubview:self.centerButton];
        [self addSubview:self.rightButton];
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGFloat padding = 2;
    CGFloat width   = (self.size.width - 2*padding) / 3;
    CGFloat heigth  = self.size.height;
    
    self.leftButton.size   = CGSizeMake(width, heigth);
    self.leftButton.left   = 0;
    self.leftButton.top    = 0;
    
    self.centerButton.size = CGSizeMake(width, heigth);
    self.centerButton.left = self.leftButton.right + padding;
    self.centerButton.top  = self.leftButton.top;
    
    self.rightButton.size  = CGSizeMake(width, heigth);
    self.rightButton.left  = self.centerButton.right + padding;
    self.rightButton.top   = self.leftButton.top;
}

- (UIButton *)leftButton {
    if(!_leftButton) {
        _leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_leftButton setTitle:@"全部" forState:UIControlStateNormal];
        _leftButton.titleLabel.font = [UIFont systemFontOfSize:12];
        [_leftButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    }
    return _leftButton;
}

- (UIButton *)centerButton {
    if(!_centerButton) {
        _centerButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_centerButton setTitle:@"全部" forState:UIControlStateNormal];
        _centerButton.titleLabel.font = [UIFont systemFontOfSize:12];
        [_centerButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    }
    return _centerButton;
}

- (UIButton *)rightButton {
    if(!_rightButton) {
        _rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_rightButton setTitle:@"全部" forState:UIControlStateNormal];
        _rightButton.titleLabel.font = [UIFont systemFontOfSize:12];
        _rightButton.titleLabel.tintColor = [UIColor grayColor];
        [_rightButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];

    }
    return _rightButton;
}

@end
