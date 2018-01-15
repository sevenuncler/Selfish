//
//  SUImageBrowserCell.m
//  selfish
//
//  Created by He on 2018/1/14.
//  Copyright © 2018年 He. All rights reserved.
//

#import "SUImageBrowserCell.h"

@interface SUImageBrowserCell()<UIScrollViewDelegate>
@end

@implementation SUImageBrowserCell

- (instancetype)initWithFrame:(CGRect)frame {
    if(self = [super initWithFrame:frame]) {
        [self.contentView addSubview:self.scrollView];
        [self.scrollView addSubview:self.imageView];
//        [self setUp];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.imageView.centerX = self.size.width / 2;
    self.imageView.centerY = self.size.height/ 2;
}

- (void)setUp {
    UIPinchGestureRecognizer *pinGR = [UIPinchGestureRecognizer new];
    [[pinGR rac_gestureSignal] subscribeNext:^(UIPinchGestureRecognizer *x) {
        UIView *view  = x.view;
        CGFloat scale = x.scale;
        view.transform = CGAffineTransformScale(view.transform, scale, scale);
        x.scale = 1;
    }];
    [self addGestureRecognizer:pinGR];
}

- (nullable UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView; {
    return self.imageView;
}

- (UIImageView *)imageView {
    if(!_imageView) {
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.size.width, self.size.height)];
        _imageView.image = [UIImage imageNamed:@"image"];
        _imageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _imageView;
}

- (UIScrollView *)scrollView {
    if(!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
        _scrollView.delegate = self;
        _scrollView.maximumZoomScale = 5;
        _scrollView.minimumZoomScale = 1;
        _scrollView.contentSize      = self.size;
    }
    return _scrollView;
}

@end
