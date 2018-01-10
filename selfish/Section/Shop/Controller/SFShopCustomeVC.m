//
//  SFShopCustomeVC.m
//  selfish
//
//  Created by He on 2017/12/1.
//  Copyright © 2017年 He. All rights reserved.
//

#import "SFShopCustomeVC.h"
#import "UIView+Layout.h"
#import "SFShopEditTextView.h"
#import <HCSStarRatingView/HCSStarRatingView.h>
#import <SVProgressHUD/SVProgressHUD.h>
#import "SFShopItem.h"
#import <MJExtension/MJExtension.h>
#import "SFAddressItem.h"


@interface SFShopCustomeVC ()<UIPickerViewDataSource, UIPickerViewDelegate>
@property(nonatomic,strong) UILabel  *menuLabel;
@property(nonatomic,strong) UIButton *menuAddButton;

@property(nonatomic,strong) UILabel  *shopDetailLabel;
@property(nonatomic,strong) UIButton *shopDetailAddButton;

@property(nonatomic,strong) UILabel    *shopMottoLabel;
@property(nonatomic,strong) UITextView *shopMottoTextView;

@property(nonatomic,strong) SFShopEditTextView *shopName;
@property(nonatomic,strong) SFShopEditTextView *shopAddress;
@property(nonatomic,strong) SFShopEditTextView *shopAnnouncment;
@property(nonatomic,strong) SFShopEditTextView *shopTags;
@property(nonatomic,strong) SFShopEditTextView *shopTypes;
@property(nonatomic,strong) SFShopEditTextView *shopAvgCost;
@property(nonatomic,strong) SFShopEditTextView *shopStarLevel;
@property(nonatomic,strong) HCSStarRatingView  *startRatingView;
@property(nonatomic,strong) UIPickerView       *addressPickerView;
@property(nonatomic,strong) NSMutableArray     *cities;
@property(nonatomic,strong) SFDistrictItem     *district;
@property(nonatomic,strong) SFCityItem         *city;
@property(nonatomic,strong) SFProvinceItem     *province;
@property(nonatomic,strong) SFCountryItem      *country;
@end

static  CGFloat padding = 15;

@implementation SFShopCustomeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.shopStarLevel addSubview:self.startRatingView];
    
    [self.view addSubview:self.shopName];
    [self.view addSubview:self.shopAddress];
    [self.view addSubview:self.shopAnnouncment];
    [self.view addSubview:self.shopTypes];
    [self.view addSubview:self.shopAvgCost];
    [self.view addSubview:self.shopStarLevel];
    [self.view addSubview:self.shopTags];
    [self.view addSubview:self.menuLabel];
    [self.view addSubview:self.menuAddButton];
    [self.view addSubview:self.shopDetailLabel];
    [self.view addSubview:self.shopDetailAddButton];
    
    // Do any additional setup after loading the view.
    [self setUpNavigatorBar];
    [self loadShopData];
    [self setUpBinding];
}

- (void)setUpNavigatorBar {
    self.title = @"商铺信息";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"修改" style:UIBarButtonItemStylePlain target:self action:@selector(updateShop:)];
}

- (void)setUpBinding {
    self.addressPickerView.delegate = self;
    self.shopAddress.textField.inputView = self.addressPickerView;
    
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"address" ofType:@".json"];
    NSData *data = [NSData dataWithContentsOfFile:filePath];
    NSError *error = nil;
    NSDictionary *addresses = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
    SFCountryItem *coutry = [SFCountryItem mj_objectWithKeyValues:addresses];
    self.country = coutry;
    if(coutry && coutry.subAddress && coutry.subAddress.count>0) {
        self.province = [SFProvinceItem mj_objectWithKeyValues:coutry.subAddress[0]];
    }
    self.city = self.province.subAddress[0];
    NSLog(@"%@ %@", addresses, self.province);
}

- (void)loadShopData {
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    NSString *aid = [[NSUserDefaults standardUserDefaults] objectForKey:@"aid"];
    NSURLSession *session = [NSURLSession sharedSession];
    NSString *url = [NSString stringWithFormat:@"%@/account/shops?aid=%@", SELFISH_HOST, aid];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
    [request addValue:@"application/json;charset=utf-8" forHTTPHeaderField:@"content-type"];
    request.HTTPMethod = @"GET";
    
    __weak typeof(self) weakSelf = self;
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if(error) {
            NSLog(@"请求出错: %@", error);
            return;
        }
        NSError *jsonError;
        NSDictionary *result = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&jsonError];
        if(jsonError) {
            NSLog(@"数据格式解析出错:%@", jsonError);
            return;
        }
        
        if([result[@"success"] isEqualToString:@"true"]) {
            NSLog(@"获取商铺成功%@", result);
            NSArray *content = result[@"content"];
            [content enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL * _Nonnull stop) {
                weakSelf.shopItem = [SFShopItem mj_objectWithKeyValues:obj];
                [[NSUserDefaults standardUserDefaults] setValue:weakSelf.shopItem.sid forKey:@"sid"];
                *stop = YES;
            }];
            dispatch_semaphore_signal(semaphore);
        }
    }];
    [SVProgressHUD showWithStatus:@"加载数据中..."];
    [dataTask resume];
    if(dispatch_semaphore_wait(semaphore, dispatch_time(DISPATCH_TIME_NOW, NSEC_PER_SEC * 2)) == 0) {
        [SVProgressHUD showSuccessWithStatus:@"加载成功"];
        dispatch_async(dispatch_get_main_queue(), ^{
            // 获取服务端数据并赋值
            self.shopName.textField.text    = self.shopItem.name;
            self.shopAddress.textField.text = self.shopItem.locationName;
            self.shopAvgCost.textField.text = [NSString stringWithFormat:@"%lf", self.shopItem.averageCost];
            self.shopAnnouncment.textField.text = self.shopItem.announcement;
            self.shopTags.textField.text    = [self.shopItem stringOfTag];
            self.shopTypes.textField.text   = [NSString stringWithFormat:@"%ld", self.shopItem.type];
            self.startRatingView.value      = self.shopItem.starLevel;
        });
        [SVProgressHUD dismissWithDelay:0.25];
    }else {
        [SVProgressHUD showErrorWithStatus:@"加载失败"];
        [SVProgressHUD dismissWithDelay:0.25];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if(self.navigationController) {
                [self.navigationController popViewControllerAnimated:YES];
            }else {
                [self dismissViewControllerAnimated:YES completion:nil];
            }
        });
    }
}

- (void)updateShop:(id)sender {
    [self fetchData];
    if(self.shopItem == nil) {
        return;
    }
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    NSURLSession *session = [NSURLSession sharedSession];
    NSString *url = [NSString stringWithFormat:@"%@/shop/update", SELFISH_HOST];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
    [request addValue:@"application/json;charset=utf-8" forHTTPHeaderField:@"content-type"];
    request.HTTPMethod = @"POST";
    self.shopItem.pics = @[@"image",@"image"].copy;
    [SFShopItem mj_setupIgnoredPropertyNames:^NSArray *{
        return @[@"itemFrame"];
    }];
    NSDictionary *json = [self.shopItem mj_JSONObject];
    NSError *writeError;
    
    NSData *data = [NSJSONSerialization dataWithJSONObject:json options:NSJSONWritingPrettyPrinted error:&writeError];
    if(writeError) {
        NSLog(@"%@", writeError);
        return;
    }
    request.HTTPBody = data;
    
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if(error) {
            NSLog(@"请求出错: %@", error);
            return;
        }
        NSError *jsonError;
        NSDictionary *result = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&jsonError];
        if(jsonError) {
            NSLog(@"数据格式解析出错:%@", jsonError);
            return;
        }
        
        if([result[@"success"] isEqualToString:@"true"]) {
            dispatch_semaphore_signal(semaphore);
        }
    }];
    [SVProgressHUD showWithStatus:@"加载数据中..."];
    [dataTask resume];
    if(dispatch_semaphore_wait(semaphore, dispatch_time(DISPATCH_TIME_NOW, NSEC_PER_SEC * 2)) == 0) {
        [SVProgressHUD showSuccessWithStatus:@"加载成功"];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self closeVC];
        });
        [SVProgressHUD dismissWithDelay:0.25];
    }else {
        [SVProgressHUD showErrorWithStatus:@"加载失败"];
        [SVProgressHUD dismissWithDelay:0.25];
    }
}

- (void)fetchData {
    if(self.shopItem == nil) {
        return;
    }
    self.shopItem.name = self.shopName.textField.text;
    self.shopItem.locationName = self.shopAddress.textField.text;
    self.shopItem.averageCost  = [self.shopAvgCost.textField.text floatValue];
    self.shopItem.announcement = self.shopAnnouncment.textField.text;
    self.shopItem.tags = [self.shopTags.textField.text componentsSeparatedByString:@","];
    self.shopItem.type = [self.shopTypes.textField.text intValue];
    self.shopItem.starLevel = self.startRatingView.value;
    
}

- (void)closeVC {
    if(self.navigationController) {
        [self.navigationController popViewControllerAnimated:YES];
    }else {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];

    self.shopName.left = padding;
    self.shopName.top  = padding;
    
    self.shopAddress.left = self.shopName.left;
    self.shopAddress.top  = self.shopName.botton + padding;
    
    self.shopAnnouncment.left = self.shopName.left;
    self.shopAnnouncment.top  = self.shopAddress.botton + padding;
    
    self.shopTypes.left     =   self.shopName.left;
    self.shopTypes.top      =   self.shopAnnouncment.botton + padding;
    
    self.shopAvgCost.left   = self.shopTypes.left;
    self.shopAvgCost.top    = self.shopTypes.botton + padding;
    
    self.shopTags.left   = self.shopAvgCost.left;
    self.shopTags.top    = self.shopAvgCost.botton + padding;
    
    self.shopStarLevel.left   = self.shopTags.left;
    self.shopStarLevel.top    = self.shopTags.botton + padding;
    self.shopStarLevel.textField.hidden = YES;
    self.startRatingView.left = self.shopStarLevel.label.right + padding;
    self.startRatingView.centerY = self.shopStarLevel.size.height / 2;
    
    self.menuAddButton.size    = CGSizeMake(60, 60);
    self.menuAddButton.centerX = self.view.size.width / 2;;
    self.menuAddButton.top = self.shopStarLevel.botton + padding;
    
    [self.menuLabel sizeToFit];
    self.menuLabel.left     = self.shopName.left;
    self.menuLabel.centerY  = self.menuAddButton.centerY;
    
    
    
    self.shopDetailAddButton.size    = CGSizeMake(60, 60);
    self.shopDetailAddButton.centerX = self.view.size.width / 2;;
    self.shopDetailAddButton.top     = self.menuAddButton.botton + 20;
    
    [self.shopDetailLabel sizeToFit];
    self.shopDetailLabel.left     = 15;
    self.shopDetailLabel.centerY  = self.shopDetailAddButton.centerY;
}

#pragma mark - UIPickerViewDelegate

- (nullable NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    if(component == 0) {
        return self.country.subAddress[row].name;
    }else if(1 == component) {
        
        return self.province.subAddress[row].name;
    }else if(2 == component) {
        ;
        return self.city.subAddress[row].name;
    }
    return @"xxxx";
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    return 44;
}

#pragma mark - UIPickViewDatasource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 3;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if(component == 0) {
        return self.country.subAddress.count;
    }else if(1 == component) {
        return self.province.subAddress.count;
    }else if(2 == component) {
        return self.city.subAddress.count;
    }
    return 0;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if(0 == component) {
        self.province = self.country.subAddress[row];
        [self.addressPickerView reloadComponent:1];
        [self.addressPickerView reloadComponent:2];
    }else if(1 == component) {
        self.city = self.province.subAddress[row];
        [self.addressPickerView reloadComponent:2];

    }else if(2 == component) {
        self.district = self.city.subAddress[row];
        NSLog(@"%@ %@ %@", self.province.name, self.city.name, self.district.name);
    }
}

#pragma mark - Action Handler

- (void)handleFoodAction:(id)sender {
    // 1. 获取有所菜单列表
    // 2. 获取制定菜品的详细信息
    // 3. 展示、修改
    
    NSString *url = @"Selfish://push/SFShopFoodListVC";
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url] options:@{} completionHandler:nil];
}

- (void)handleShopAction:(id)sender {
    NSString *url = @"Selfish://push/SFShopCustomeDecorationVC";
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url] options:@{} completionHandler:nil];
}


#pragma mark - Getter & Setter

- (SFShopEditTextView *)shopName {
    if(!_shopName) {
        _shopName = [[SFShopEditTextView alloc] initWithFrame:CGRectMake(0, 0, self.view.size.width- 2*padding, 44)];
        _shopName.label.text = @"店铺名称:";
    }
    return _shopName;
}

- (SFShopEditTextView *)shopAddress {
    if(!_shopAddress) {
        _shopAddress = [[SFShopEditTextView alloc] initWithFrame:CGRectMake(0, 0, self.view.size.width - 2*padding, 44)];
        _shopAddress.label.text = @"店铺地址:";
    }
    return _shopAddress;
}

- (SFShopEditTextView *)shopAnnouncment {
    if(!_shopAnnouncment) {
        _shopAnnouncment = [[SFShopEditTextView alloc] initWithFrame:CGRectMake(0, 0, self.view.size.width - 2*padding, 44)];
        _shopAnnouncment.label.text = @"公告:";
    }
    return _shopAnnouncment;
}

- (SFShopEditTextView *)shopTags {
    if(!_shopTags) {
        _shopTags = [[SFShopEditTextView alloc] initWithFrame:CGRectMake(0, 0, self.view.size.width - 2*padding, 44)];
        _shopTags.label.text = @"标签:";
    }
    return _shopTags;
}

- (SFShopEditTextView *)shopAvgCost {
    if(!_shopAvgCost) {
        _shopAvgCost = [[SFShopEditTextView alloc] initWithFrame:CGRectMake(0, 0, self.view.size.width - 2*padding, 44)];
        _shopAvgCost.label.text = @"人均:";
    }
    return _shopAvgCost;
}

- (SFShopEditTextView *)shopTypes {
    if(!_shopTypes) {
        _shopTypes = [[SFShopEditTextView alloc] initWithFrame:CGRectMake(0, 0, self.view.size.width - 2*padding, 44)];
        _shopTypes.label.text = @"类型:";
    }
    return _shopTypes;
}

- (SFShopEditTextView *)shopStarLevel {
    if(!_shopStarLevel) {
        _shopStarLevel = [[SFShopEditTextView alloc] initWithFrame:CGRectMake(0, 0, self.view.size.width - 2*padding, 44)];
        _shopStarLevel.label.text = @"星级:";
    }
    return _shopStarLevel;
}

- (HCSStarRatingView *)startRatingView {
    if(!_startRatingView) {
        _startRatingView = [[HCSStarRatingView alloc] initWithFrame:CGRectMake(0, 0, 200, 44)];
        _startRatingView.allowsHalfStars = YES;
        _startRatingView.maximumValue = 5;
        _startRatingView.minimumValue = 0;
        _startRatingView.value = 4.5;
        _startRatingView.enabled = NO;
    }
    return _startRatingView;
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
        [_menuAddButton addTarget:self action:@selector(handleFoodAction:) forControlEvents:UIControlEventTouchUpInside];
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
        [_shopDetailAddButton addTarget:self action:@selector(handleShopAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _shopDetailAddButton;
}

- (UIPickerView *)addressPickerView {
    if(!_addressPickerView) {
        _addressPickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH*0.618f)];
    }
    return _addressPickerView;
}

@end
