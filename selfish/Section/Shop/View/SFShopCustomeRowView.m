//
//  SFShopCustomeRowView.m
//  selfish
//
//  Created by He on 2017/12/2.
//  Copyright © 2017年 He. All rights reserved.
//

#import "SFShopCustomeRowView.h"

@interface SFShopCustomeRowView ()
@property(nonatomic,strong) UICollectionViewFlowLayout *flowLayout;
@end

@implementation SFShopCustomeRowView

- (instancetype)initWithFrame:(CGRect)frame {
    if(self =[super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.nameLabel];
        [self addSubview:self.picsCollectionView];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGFloat padding = 10;
    
    [self.nameLabel sizeToFit];
    self.nameLabel.left = padding;
    self.nameLabel.centerY = self.size.height / 2;
    
    self.picsCollectionView.size = CGSizeMake(self.size.width - self.nameLabel.right - 2*padding, self.size.height - 2*padding);
    self.picsCollectionView.left = self.nameLabel.right + padding;
    self.picsCollectionView.centerY = self.nameLabel.centerY;
}

- (UILabel *)nameLabel {
    if(!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.text = @"类目名称";
    }
    return _nameLabel;
}

- (UICollectionView *)picsCollectionView {
    if(!_picsCollectionView) {
        _picsCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, 100, 100) collectionViewLayout:self.flowLayout];
        _picsCollectionView.backgroundColor = [UIColor whiteColor];
        _picsCollectionView.clipsToBounds = NO;
    }
    return _picsCollectionView;
}

- (UICollectionViewFlowLayout *)flowLayout {
    if(!_flowLayout) {
        _flowLayout = [[UICollectionViewFlowLayout alloc] init];
    }
    return _flowLayout;
}

@end
