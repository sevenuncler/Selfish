//
//  SUImageBrowserVC.m
//  selfish
//
//  Created by fanghe on 18/1/13.
//  Copyright © 2018年 He. All rights reserved.
//

#import "SUImageBrowserVC.h"
#import "SUImageBrowserCell.h"
#import "SUImageManager.h"

static NSString * const reuseID = @"reuseCell";

@interface SUImageBrowserVC ()<UIScrollViewDelegate, UICollectionViewDelegate, UICollectionViewDataSource>
@property(nonatomic,strong) UIScrollView *containerView;
@property(nonatomic,strong) UIImageView  *imageView;
@property(nonatomic,strong) UICollectionView           *collectionView;
@property(nonatomic,strong) UICollectionViewFlowLayout *flowLayout;
@property(nonatomic,weak)   SUImageBrowserCell         *imageBrowserCell;
@property(nonatomic,strong) NSMutableArray             *items;
@property(nonatomic,strong) UIPageControl              *pageControl;
@end

@implementation SUImageBrowserVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.collectionView];
    [self.view addSubview:self.pageControl];
    [self setUpBinding];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.currentIndex = 0;
    self.pageControl.numberOfPages = self.images.count;
}

- (void)setUpBinding {
    [self.collectionView registerClass:[SUImageBrowserCell class] forCellWithReuseIdentifier:reuseID];
    self.collectionView.maximumZoomScale = 5;
    self.collectionView.minimumZoomScale = 1;
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 1;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return self.images.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    SUImageBrowserCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseID forIndexPath:indexPath];
    cell.imageView.userInteractionEnabled = YES;
    SUImageManager *imageManager = [SUImageManager defaultImageManager];
    id obj = self.images[indexPath.item];
    [imageManager setImageView:cell.imageView withID:obj];
//    cell.frame = CGRectMake(cell.frame.origin.x, cell.frame.origin.y, self.view.size.width, self.view.size.height);
//    cell.imageView.size = image.size;
//    __weak typeof(self) weakSelf = self;
//    __weak typeof(collectionView) weakCollectionView = collectionView;
//    UIPinchGestureRecognizer *pinGR = [UIPinchGestureRecognizer new];
//    [[pinGR rac_gestureSignal] subscribeNext:^(UIPinchGestureRecognizer *x) {
//        UIView *view = x.view;
//        CGFloat scale = x.scale;
//        view.transform = CGAffineTransformScale(view.transform, scale, scale);
//        x.scale = 1;
//        SUItem *item = weakSelf.items[indexPath.section];
//        CGFloat width = view.size.width<weakSelf.view.size.width?weakSelf.view.size.width:view.size.width;
//        CGFloat heigth= view.size.height<weakSelf.view.size.height?weakSelf.view.size.height:view.size.height;
//        item.itemFrame = CGRectMake(0, 0, width, heigth);
//
//        NSIndexSet *set = [NSIndexSet indexSetWithIndex:indexPath.section];
//        dispatch_async(dispatch_get_main_queue(), ^{
//            [weakCollectionView reloadSections:set];
//        });
//    }];
//    [cell addGestureRecognizer:pinGR];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return self.view.size;
}

#pragma mark - UIScrollViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    self.imageBrowserCell = (SUImageBrowserCell *)[collectionView cellForItemAtIndexPath:indexPath];
}

- (void)collectionView:(UICollectionView *)collectionView didEndDisplayingCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    SUImageBrowserCell *imageBrowserCell = (SUImageBrowserCell *)cell;
    imageBrowserCell.scrollView.zoomScale = 1;
}

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    self.pageControl.currentPage = indexPath.section;
}

//-(UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
//{
//    return self.imageBrowserCell;
//}


- (UIScrollView *)containerView {
    if(nil == _containerView) {
        _containerView = [[UIScrollView alloc]initWithFrame:self.view.bounds];
        _containerView.backgroundColor = [UIColor whiteColor];
    }
    return _containerView;
}

- (UIImageView *)imageView {
    if(nil == _imageView) {
        _imageView = [[UIImageView alloc]initWithFrame:self.view.bounds];
        _imageView.image = [UIImage imageNamed:@"image"];
        _imageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _imageView;
}

- (void)setCurrentIndex:(NSInteger)currentIndex {
    _currentIndex = currentIndex;
    if(!self.images || currentIndex<0 || currentIndex>self.images.count) {
        return;
    }
//    UIImage *image = [self.images objectAtIndex:_currentIndex];
//    self.imageView.image = image;
//    self.containerView.contentSize = CGSizeMake(image.size.width*5, image.size.height*5);
}

- (NSMutableArray *)images {
    if(nil == _images) {
        _images = [NSMutableArray array];
        {
            [_images addObject:[UIImage imageNamed:@"image"]];
            SUItem *item = [SUItem new];
            item.itemFrame = CGRectMake(0, 0, self.view.size.width, self.view.size.height);
            [self.items addObject:item];
        }
        {
            [_images addObject:[UIImage imageNamed:@"image"]];
            SUItem *item = [SUItem new];
            item.itemFrame = CGRectMake(0, 0, self.view.size.width, self.view.size.height);
            [self.items addObject:item];
        }
        {
            [_images addObject:[UIImage imageNamed:@"image"]];
            SUItem *item = [SUItem new];
            item.itemFrame = CGRectMake(0, 0, self.view.size.width, self.view.size.height);
            [self.items addObject:item];
        }
    }
    return _images;
}

- (UICollectionView *)collectionView {
    if(!_collectionView) {
        _collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:self.flowLayout];
        _collectionView.delegate      = self;
        _collectionView.dataSource    = self;
        _collectionView.pagingEnabled = YES;
    }
    return _collectionView;
}

- (UICollectionViewFlowLayout *)flowLayout {
    if(!_flowLayout) {
        _flowLayout = [UICollectionViewFlowLayout new];
        _flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _flowLayout.itemSize = self.view.size;
        _flowLayout.minimumLineSpacing = 0;
    }
    return _flowLayout;
}

- (NSMutableArray *)items {
    if(!_items) {
        _items = [NSMutableArray array];
    }
    return _items;
}

- (UIPageControl *)pageControl {
    if(!_pageControl) {
        _pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, self.view.size.height - 44, 150, 44)];
        _pageControl.centerX = self.view.size.width/2;
    }
    return _pageControl;
}



@end
