//
//  SFShopCustomeDecorationVC.m
//  selfish
//
//  Created by He on 2017/12/2.
//  Copyright © 2017年 He. All rights reserved.
//

#import "SFShopCustomeDecorationVC.h"
#import "SFShopCustomeRowView.h"
#import "SFShopCustomeRowViewModel.h"

@interface SFShopCustomeDecorationVC ()
@property(nonatomic, strong) SFShopCustomeRowView *gateView;
@property(nonatomic, strong) SFShopCustomeRowView *enviromentView;
@property(nonatomic, strong) SFShopCustomeRowView *diningTableView;
@property(nonatomic, strong) SFShopCustomeRowView *kitchenView;
@property(nonatomic, strong) SFShopCustomeRowView *VRView;
@property(nonatomic, strong) UIScrollView         *contentScrollView;
@property(nonatomic, strong) SFShopCustomeRowViewModel *viewModel;
@property(nonatomic, strong) UIButton             *submitButton;
@end

@implementation SFShopCustomeDecorationVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.contentScrollView addSubview:self.gateView];
    [self.contentScrollView addSubview:self.enviromentView];
    [self.contentScrollView addSubview:self.diningTableView];
    [self.contentScrollView addSubview:self.kitchenView];
    [self.contentScrollView addSubview:self.VRView];
    [self.contentScrollView addSubview: self.submitButton];
    [self.view addSubview:self.contentScrollView];
    
    [self setUpDataBinding];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    self.gateView.top = 0;
    self.enviromentView.top = self.gateView.botton;
    self.diningTableView.top = self.enviromentView.botton;
    self.kitchenView.top = self.diningTableView.botton;
    self.VRView.top = self.kitchenView.botton;
    self.submitButton.top = self.VRView.botton;
    
    self.contentScrollView.contentSize = CGSizeMake(self.view.size.width, self.submitButton.botton + 100);
}

- (void)setUpDataBinding {
    self.viewModel = [SFShopCustomeRowViewModel new];
    self.gateView.picsCollectionView.dataSource = self.viewModel;
    self.gateView.picsCollectionView.delegate   = self.viewModel;
    
    self.enviromentView.picsCollectionView.dataSource = self.viewModel;
    self.enviromentView.picsCollectionView.delegate   = self.viewModel;
    
    self.diningTableView.picsCollectionView.dataSource = self.viewModel;
    self.diningTableView.picsCollectionView.delegate   = self.viewModel;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Getter & Setter

- (SFShopCustomeRowView *)gateView {
    if(!_gateView) {
        _gateView = [[SFShopCustomeRowView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_WIDTH*0.5f)];
        _gateView.nameLabel.text = @"大门";
    }
    return _gateView;
}

- (SFShopCustomeRowView *)enviromentView {
    if(!_enviromentView) {
        _enviromentView = [[SFShopCustomeRowView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_WIDTH*0.618f)];
        _enviromentView.nameLabel.text = @"周围环境";
    }
    return _enviromentView;
}

- (SFShopCustomeRowView *)diningTableView {
    if(!_diningTableView) {
        _diningTableView = [[SFShopCustomeRowView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_WIDTH*0.618f)];
        _diningTableView.nameLabel.text = @"餐桌";
    }
    return _diningTableView;
}

- (SFShopCustomeRowView *)kitchenView {
    if(!_kitchenView) {
        _kitchenView = [[SFShopCustomeRowView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_WIDTH*0.55f)];
        _kitchenView.nameLabel.text = @"厨房";
    }
    return _kitchenView;
}

- (SFShopCustomeRowView *)VRView {
    if(!_VRView) {
        _VRView = [[SFShopCustomeRowView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_WIDTH*0.618f)];
        _VRView.nameLabel.text = @"VR";
    }
    return _VRView;
}

- (UIScrollView *)contentScrollView {
    if(!_contentScrollView) {
        _contentScrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    }
    return _contentScrollView;
}

- (UIButton *)submitButton {
    if(!_submitButton) {
        _submitButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_submitButton setTitle:@"创建" forState:UIControlStateNormal];
        [_submitButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _submitButton.size = CGSizeMake(self.view.size.width, 44);
    }
    return _submitButton;
}


@end
