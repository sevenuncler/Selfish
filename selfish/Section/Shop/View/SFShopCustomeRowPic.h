//
//  SFShopCustomeRowPic.h
//  selfish
//
//  Created by He on 2017/12/2.
//  Copyright © 2017年 He. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SFShopCustomeRowPic : UICollectionViewCell
@property(nonatomic,strong) UIImageView *imageView;
@property(nonatomic,strong) UIButton    *deleteButton;
@property(nonatomic,copy)   void(^deleteHandler)(void);
@end
