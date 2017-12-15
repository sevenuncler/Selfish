//
//  SFShopCustomeVC.m
//  selfish
//
//  Created by He on 2017/12/1.
//  Copyright © 2017年 He. All rights reserved.
//

#import "SFShopCustomeVC.h"
#import "UIView+Layout.h"

@interface SFShopCustomeVC ()
@property(nonatomic,strong) UILabel  *menuLabel;
@property(nonatomic,strong) UIButton *menuAddButton;

@property(nonatomic,strong) UILabel  *shopDetailLabel;
@property(nonatomic,strong) UIButton *shopDetailAddButton;

@property(nonatomic,strong) UILabel    *shopMottoLabel;
@property(nonatomic,strong) UITextView *shopMottoTextView;

@end

@implementation SFShopCustomeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.menuLabel];
    [self.view addSubview:self.menuAddButton];
    [self.view addSubview:self.shopDetailLabel];
    [self.view addSubview:self.shopDetailAddButton];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    
    [self.menuLabel sizeToFit];
    self.menuLabel.left = 15;
    self.menuLabel.top  = 70;
    
    self.menuAddButton.size    = CGSizeMake(60, 60);
    self.menuAddButton.centerX = self.view.size.width / 2;;
    self.menuAddButton.centerY = self.menuLabel.centerY;
    
    self.shopDetailAddButton.size    = CGSizeMake(60, 60);
    self.shopDetailAddButton.centerX = self.view.size.width / 2;;
    self.shopDetailAddButton.top     = self.menuAddButton.botton + 20;
    
    [self.shopDetailLabel sizeToFit];
    self.shopDetailLabel.left     = 15;
    self.shopDetailLabel.centerY  = self.shopDetailAddButton.centerY;
}

- (UILabel *)menuLabel {
    if(!_menuLabel) {
        _menuLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 150, 44)];
        _menuLabel.text = @"菜单类目:";
    }
    return _menuLabel;
}

- (UIButton *)menuAddButton {
    if(!_menuAddButton) {
        _menuAddButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_menuAddButton setImage:[UIImage imageNamed:@"image"] forState:UIControlStateNormal];
        [_menuAddButton addTarget:self action:@selector(handleShopAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _menuAddButton;
}

- (UILabel *)shopDetailLabel {
    if(!_shopDetailLabel) {
        _shopDetailLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 150, 44)];
        _shopDetailLabel.text = @"店铺图片:";
    }
    return _shopDetailLabel;
}

- (UIButton *)shopDetailAddButton {
    if(!_shopDetailAddButton) {
        _shopDetailAddButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_shopDetailAddButton setImage:[UIImage imageNamed:@"image"] forState:UIControlStateNormal];
        [_shopDetailAddButton addTarget:self action:@selector(handleFoodAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _shopDetailAddButton;
}

    - (void)handleFoodAction:(id)sender {
        NSString *url = @"Selfish://push/SFShopCustomeFoodVC";
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url] options:@{} completionHandler:nil];
    }
    
    - (void)handleShopAction:(id)sender {
        NSString *url = @"Selfish://push/SFShopCustomeDecorationVC";
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url] options:@{} completionHandler:nil];
    }
    

@end
