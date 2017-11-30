//
//  SFShopCatagoryView.m
//  selfish
//
//  Created by He on 2017/11/27.
//  Copyright © 2017年 He. All rights reserved.
//

#import "SFShopCatagoryView.h"
#import "Macros.h"
#import "UIView+Layout.h"

#define WIDTH (SCREEN_WIDTH) / 3.f
@implementation SFShopCatagoryView

- (instancetype)init {
    return [self initWithFrame:CGRectMake(0, 0,SCREEN_WIDTH, SCREEN_WIDTH/0.7)];
}

- (instancetype)initWithFrame:(CGRect)frame {
    if(self = [super initWithFrame:frame]) {
        [self addSubview:self.menuTableView];
        [self addSubview:self.contentTableView];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGFloat width = self.size.width / 3;
    CGFloat height = self.size.height;
    
    self.menuTableView.size = CGSizeMake(width, height);
    
    self.contentTableView.size = CGSizeMake(2*width, height);
    self.contentTableView.left = width;
}

- (void)refresh {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.menuTableView reloadData];
        [self.contentTableView reloadData];
    });
}

- (UITableView *)menuTableView {
    if(!_menuTableView) {
        _menuTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 3*WIDTH) style:UITableViewStylePlain];
        _menuTableView.tableFooterView = [UIView new];
    }
    return _menuTableView;
}

- (UITableView *)contentTableView {
    if(!_contentTableView) {
        _contentTableView = [[UITableView alloc] initWithFrame:CGRectMake(WIDTH+1, 0, WIDTH*2, 3*WIDTH)  style:UITableViewStylePlain];
        _contentTableView.backgroundColor = [UIColor lightGrayColor];
        _contentTableView.tableFooterView = [UIView new];
    }
    return _contentTableView;
}

@end
