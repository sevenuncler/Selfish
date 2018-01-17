//
//  SFShopCustomeRowPic.m
//  selfish
//
//  Created by He on 2017/12/2.
//  Copyright © 2017年 He. All rights reserved.
//

#import "SFShopCustomeRowPic.h"

@implementation SFShopCustomeRowPic

- (instancetype)initWithFrame:(CGRect)frame {
    if(self = [super initWithFrame:frame]) {
        [self.contentView addSubview:self.imageView];
        [self.contentView addSubview:self.deleteButton];
        __weak typeof(self) weakSelf = self;
        [[self.deleteButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            if(weakSelf.deleteHandler) {
                weakSelf.deleteHandler();
            }
        }];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.imageView.size = self.contentView.size;
    
    self.deleteButton.center = CGPointMake(0, 0);
}

- (UIImageView *)imageView {
    if(!_imageView) {
        _imageView = [[UIImageView alloc] init];
        _imageView.image = [UIImage imageNamed:@"image"];
        _imageView.layer.masksToBounds = YES;
        _imageView.layer.cornerRadius  = 10;
    }
    return _imageView;
}

- (UIButton *)deleteButton {
    if(!_deleteButton) {
        _deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_deleteButton setImage:[UIImage imageNamed:@"drew.jpg"] forState:UIControlStateNormal];
        _deleteButton.size = CGSizeMake(20, 20);
        _deleteButton.layer.cornerRadius  = 10;
        _deleteButton.layer.masksToBounds = YES;
    }
    return _deleteButton;
}

@end
