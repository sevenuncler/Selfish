//
//  SFShopFoodCustomeViewModel.h
//  selfish
//
//  Created by He on 2017/12/2.
//  Copyright © 2017年 He. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SFShopFoodCustomeViewModel : NSObject <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>
@property(nonatomic, strong) NSMutableArray *pics;

- (void)addImage:(id)image;
- (void)addImages:(NSArray *)images;
- (NSArray *)getImages;
- (void)clearImages;
@end
