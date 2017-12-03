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
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.imageView.size = self.contentView.size;
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

@end
