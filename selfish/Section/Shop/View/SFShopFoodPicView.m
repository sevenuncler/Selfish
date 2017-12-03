//
//  SFShopFoodPicView.m
//  selfish
//
//  Created by He on 2017/12/2.
//  Copyright © 2017年 He. All rights reserved.
//

#import "SFShopFoodPicView.h"

@implementation SFShopFoodPicView

- (instancetype)initWithFrame:(CGRect)frame {
    if(self =[super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.picsCollectionView];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGFloat padding = 10;
    
    self.picsCollectionView.size = CGSizeMake(self.size.width - 2*padding, self.size.height - 2*padding);
    self.picsCollectionView.left = padding;
    self.picsCollectionView.centerY = self.size.height / 2;
}

- (UICollectionView *)picsCollectionView {
    if(!_picsCollectionView) {
        _picsCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, 100, 100) collectionViewLayout:self.flowLayout];
        _picsCollectionView.backgroundColor = [UIColor whiteColor];
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
