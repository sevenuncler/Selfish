//
//  SUImageBrowserVC.m
//  selfish
//
//  Created by fanghe on 18/1/13.
//  Copyright © 2018年 He. All rights reserved.
//

#import "SUImageBrowserVC.h"

@interface SUImageBrowserVC ()<UIScrollViewDelegate>
@property(nonatomic,strong) UIScrollView *containerView;
@property(nonatomic,strong) UIImageView  *imageView;
@end

@implementation SUImageBrowserVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.containerView];
    [self.containerView addSubview:self.imageView];
    [self setUpBinding];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.currentIndex = 0;
}

- (void)setUpBinding {
//    __weak typeof(self) weakSelf = self;
//    UIPinchGestureRecognizer *pinGR = [[UIPinchGestureRecognizer alloc] init];
//    [[pinGR rac_gestureSignal] subscribeNext:^(UIPinchGestureRecognizer *pinchGestureRecognizer) {
//        NSLog(@"%lf", pinchGestureRecognizer.scale);
//
//    }];
//    [self.containerView addGestureRecognizer:pinGR];
    self.containerView.maximumZoomScale = 5;
    self.containerView.minimumZoomScale = 0.8;
    self.containerView.delegate = self;
    self.imageView.userInteractionEnabled = NO;

}
#pragma mark - UIScrollViewDelegate

-(UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.imageView;
}


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
    UIImage *image = [self.images objectAtIndex:_currentIndex];
    self.imageView.image = image;
    self.containerView.contentSize = CGSizeMake(image.size.width*5, image.size.height*5);
}

- (NSMutableArray *)images {
    if(nil == _images) {
        _images = [NSMutableArray array];
        {
            [_images addObject:[UIImage imageNamed:@"image"]];
        }
    }
    return _images;
}

@end
