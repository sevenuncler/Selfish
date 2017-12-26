//
//  SFShopFoodCustomeViewModel.m
//  selfish
//
//  Created by He on 2017/12/2.
//  Copyright © 2017年 He. All rights reserved.
//

#import "SFShopFoodCustomeViewModel.h"
#import "SFShopCustomeRowPic.h"
#import "SUImageManager.h"
#import <JLRoutes/JLRoutes.h>
#import "SUImagePickerViewController.h"

static NSString * const reuseID = @"SFShopCustomeRowPic";
@implementation SFShopFoodCustomeViewModel {
    __weak UICollectionView *_internalCollection;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    _internalCollection = collectionView;
    return self.pics.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView registerClass:[SFShopCustomeRowPic class] forCellWithReuseIdentifier:reuseID];
    SFShopCustomeRowPic *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseID forIndexPath:indexPath];
    id obj = [self.pics objectAtIndex:indexPath.row];
    if([obj isKindOfClass:[UIImage class]]) {
        cell.imageView.image = obj;
    }else if([obj isKindOfClass:[NSURL class]]) {
        SUImageManager *imageManager = [SUImageManager defaultImageManager];
        [imageManager setImageView:cell.imageView withURL:obj];
    }else if([obj isKindOfClass:[NSString class]]) {
        SUImageManager *imageManager = [SUImageManager defaultImageManager];
        [imageManager setImageView:cell.imageView withUrl:obj];
    }
    return cell;
}

#pragma mark - UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(65, 65);
}
    
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.item == self.pics.count - 1) {
        SUImagePickerViewController *imagePickerVC = [SUImagePickerViewController new];
        __weak typeof(self) weakSelf = self;
        imagePickerVC.completionHandler = ^(NSArray *array) {
            [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                [weakSelf.pics insertObject:obj atIndex:0];
            }];
            dispatch_async(dispatch_get_main_queue(), ^{
                [_internalCollection reloadData];
            });
        };
        [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:imagePickerVC animated:YES completion:nil];
    }
}
    
#pragma mark - Getter & Setter
    
- (NSMutableArray *)pics {
    if(nil == _pics) {
        _pics = [NSMutableArray array];
        [_pics addObject:[[NSBundle mainBundle] pathForResource:@"image" ofType:@"png"] ];
    }
    return _pics;
}
@end
