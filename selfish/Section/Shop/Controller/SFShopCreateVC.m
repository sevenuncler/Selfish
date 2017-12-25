//
//  SFShopCreateVC.m
//  selfish
//
//  Created by He on 2017/11/28.
//  Copyright © 2017年 He. All rights reserved.
//

#import "SFShopCreateVC.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "UIView+Layout.h"
#import "SUSQLManager.h"
#import "SFShopItem.h"
#import <SVProgressHUD/SVProgressHUD.h>

@interface SFShopCreateVC ()
@property(nonatomic,strong) UILabel *shopNameLabel;
@property(nonatomic,strong) UITextField *shopNameTF;
@property(nonatomic,strong) UILabel *shopLocationLabel;
@property(nonatomic,strong) UITextField *shopLocationTF;
@property(nonatomic,strong) UILabel *shopTypeLabel;
@property(nonatomic,strong) UITextField *shopTypeTF;
@property(nonatomic,strong) UIButton *submitButton;
@end

@implementation SFShopCreateVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpNavigator];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.shopNameLabel];
    [self.view addSubview:self.shopNameTF];
    [self.view addSubview:self.shopLocationLabel];
    [self.view addSubview:self.shopLocationTF];
    [self.view addSubview:self.shopTypeLabel];
    [self.view addSubview:self.shopTypeTF];
    [self.view addSubview:self.submitButton];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
    
- (void)setUpNavigator {
        self.title = @"创建商店";
        
        UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(backHandler:)];
    self.navigationController.navigationBar.backgroundColor = [UIColor redColor];
        self.navigationItem.leftBarButtonItem = leftBarButtonItem;

        self.navigationItem.rightBarButtonItem = nil;
}

- (void)backHandler:(id)sender {
    if(self.navigationController) {
        [self.navigationController popViewControllerAnimated:YES];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}
    
-(void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    CGFloat padding = 15;
    self.shopNameLabel.left = padding;
    self.shopNameLabel.top  = 0;
    
    self.shopNameTF.size = CGSizeMake(self.view.size.width-3*padding - self.shopNameLabel.right, self.shopNameLabel.size.height);
    self.shopNameTF.left = self.shopNameLabel.right + padding;
    self.shopNameTF.top  = self.shopNameLabel.top;
    
    self.shopLocationLabel.left = padding;
    self.shopLocationLabel.top  = self.shopNameLabel.botton;
    
    self.shopLocationTF.size = CGSizeMake(self.view.size.width-3*padding - self.shopNameLabel.right, self.shopLocationLabel.size.height);
    self.shopLocationTF.left = self.shopLocationLabel.right + padding;
    self.shopLocationTF.top  = self.shopLocationLabel.top;
    
    //类型
    self.shopTypeLabel.left = padding;
    self.shopTypeLabel.top  = self.shopLocationLabel.botton;
    
    self.shopTypeTF.size = CGSizeMake(self.view.size.width-3*padding - self.shopNameLabel.right, self.shopTypeLabel.size.height);
    self.shopTypeTF.left = self.shopTypeLabel.right + padding;
    self.shopTypeTF.top  = self.shopTypeLabel.top;
    
    self.submitButton.top = self.shopTypeTF.botton;
    self.submitButton.left = 0;
    self.submitButton.backgroundColor = [UIColor redColor];
}
    
#pragma makr - Private

- (void)handleCreateAction:(id)sender {
    NSURLSession *session = [NSURLSession sharedSession];
    NSString *path = [NSString stringWithFormat:@"%@/shop", SELFISH_HOST];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:path]];
    [request setValue:@"application/json;charset=utf-8" forHTTPHeaderField:@"content-type"];
    request.HTTPMethod = @"post";
    id aid = [[NSUserDefaults standardUserDefaults] stringForKey:@"aid"];
    NSDictionary *json = @{
                           @"name"  : self.shopNameTF.text,
                           @"pics"  : @"",
                           @"tags"  : @"",
                           @"locationName" : self.shopLocationTF.text,
                           @"account_aid" : aid
                           };
    request.HTTPBody = [NSJSONSerialization dataWithJSONObject:json options:NSJSONWritingPrettyPrinted error:nil];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"%@", json);
        [[NSUserDefaults standardUserDefaults] setObject:json[@"sid"] forKey:@"sid"];
        NSString *path =  @"Selfish://push/SFShopCustomeVC";
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:path] options:@{} completionHandler:nil];
    }];
    [dataTask resume];
}

- (BOOL)validateFormData {
    if(self.shopNameTF.text == nil) {
        return NO;
    }
    return YES;
}

- (UILabel *)shopNameLabel {
    if(!_shopNameLabel) {
        _shopNameLabel = [[UILabel alloc] init];
        _shopNameLabel.text = @"店铺名称";
        _shopNameLabel.frame = CGRectMake(0, 104, 70, 44);
    }
    return _shopNameLabel;
}

- (UITextField *)shopNameTF {
    if(!_shopNameTF) {
        _shopNameTF = [[UITextField alloc] init];
        _shopNameTF.placeholder = @"如 无印良铺";
        _shopNameTF.frame = CGRectMake(0, 0, self.view.size.width, 44);
    }
    return _shopNameTF;
}

- (UILabel *)shopLocationLabel {
    if(!_shopLocationLabel) {
        _shopLocationLabel = [[UILabel alloc] init];
        _shopLocationLabel.text = @"地址";
        _shopLocationLabel.frame = CGRectMake(0, 104, 70, 44);
    }
    return _shopLocationLabel;
}

- (UITextField *)shopLocationTF {
    if(!_shopLocationTF) {
        _shopLocationTF = [[UITextField alloc] init];
        _shopLocationTF.placeholder = @"如 浙江省，杭州市，滨江区 网商路999号";
        _shopLocationTF.frame = CGRectMake(0, 0, self.view.size.width, 44);
    }
    return _shopLocationTF;
}

- (UILabel *)shopTypeLabel {
    if(!_shopTypeLabel) {
        _shopTypeLabel = [[UILabel alloc] init];
        _shopTypeLabel.text = @"类型";
        _shopTypeLabel.frame = CGRectMake(0, 104, 70, 44);
    }
    return _shopTypeLabel;
}

- (UITextField *)shopTypeTF {
    if(!_shopTypeTF) {
        _shopTypeTF = [[UITextField alloc] init];
        _shopTypeTF.placeholder = @"如 一人火锅";
        _shopTypeTF.frame = CGRectMake(0, 0, self.view.size.width, 44);
    }
    return _shopTypeTF;
}

- (UIButton *)submitButton {
    if(!_submitButton) {
        _submitButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_submitButton setTitle:@"创建" forState:UIControlStateNormal];
        _submitButton.size = CGSizeMake(self.view.size.width, 44);
        [_submitButton addTarget:self action:@selector(handleCreateAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _submitButton;
}

@end
