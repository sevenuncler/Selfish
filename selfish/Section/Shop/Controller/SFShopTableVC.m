//
//  SFShopTableVC.m
//  selfish
//
//  Created by He on 2017/11/25.
//  Copyright © 2017年 He. All rights reserved.
//

#import "SFShopTableVC.h"
#import "SFShopTableViewCell.h"
#import "SFShopDetailVC.h"
#import "SFShopCatagoryToolBarView.h"
#import "SFShopCatagoryView.h"
#import "SFShopCatagoryViewModel.h"
#import "SFShopCatagoryViewModel2.h"
#import "SFShopFoodRandomVC.h"
#import "SFShopItem.h"
#import "SULocationManager.h"

#import <CoreLocation/CoreLocation.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import <MJExtension/MJExtension.h>
#import <SVProgressHUD/SVProgressHUD.h>
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "UIView+Layout.h"
#import "Macros.h"
#import "SULocationManager.h"

static NSString * const reuseIdentifier = @"商家表单元";
dispatch_semaphore_t semaphore ;

@interface SFShopTableVC ()<UITableViewDataSource, UITableViewDelegate>
@property(nonatomic,strong) SFShopCatagoryToolBarView *catagorySegment;
@property(nonatomic,strong) SFShopCatagoryView        *shopCatagoryView;
@property(nonatomic,strong) SFShopCatagoryViewModel   *shopCatagoryViewModel;
@property(nonatomic,strong) SFShopCatagoryViewModel2  *shopCatagoryViewModel2;
@property(nonatomic,strong) SFShopCatagoryView        *shopAreaView;
@property(nonatomic,strong) SFShopCatagoryViewModel   *shopAreaViewModel;
@property(nonatomic,strong) SFShopCatagoryViewModel2  *shopAreaViewModel2;
@property(nonatomic,strong) UITableView               *shopSortView;
@property(nonatomic,strong) SFShopCatagoryViewModel2  *shopSortViewModel2;
@property(nonatomic,strong) SFCatagoryItem            *catagoryItemSelected;
@property(nonatomic,strong) SFCatagoryItem            *areaItemSelected;
@property(nonatomic,strong) SFCatagoryItem            *sortItemSelected;
@property(nonatomic,strong) CLLocation                *userLocation;
@property(nonatomic,strong) SULocation                *detailLocation;
@property(nonatomic,copy)   NSString                  *queryCondiction;
@end

@implementation SFShopTableVC

- (void)viewDidLoad {
    [super viewDidLoad];
    semaphore = dispatch_semaphore_create(0);
    //vc.view往下移动，不让其被导航栏遮挡，与automaticalAjustScrollViewInsect差不多（略微差别）
    self.edgesForExtendedLayout  = UIRectEdgeNone;
    self.navigationController.navigationBar.translucent = NO;
    [self.view addSubview:self.catagorySegment];
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.shopCatagoryView];
    [self.view addSubview:self.shopAreaView];
    [self.view addSubview:self.shopSortView];
    
    [self.tableView registerClass:[SFShopTableViewCell class] forCellReuseIdentifier:reuseIdentifier];

    [self setUpBind];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self setUpNavigator];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        [self.items removeAllObjects];
        [self loadShops];
    });
}

- (void)setUpNavigator {
    self.title = @"商铺";
    
    UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"定位" style:UIBarButtonItemStylePlain target:self action:@selector(handleLocationAction:)];
    self.navigationItem.leftBarButtonItem = leftBarButtonItem;
    
    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"随便" style:UIBarButtonItemStylePlain target:self action:@selector(handleRandomAction:)];
    self.navigationItem.rightBarButtonItem = rightBarButtonItem;
}

- (void)setUpBind {
    self.shopCatagoryView.menuTableView.dataSource = self.shopCatagoryViewModel;
    self.shopCatagoryView.menuTableView.delegate = self.shopCatagoryViewModel;
    self.shopCatagoryView.contentTableView.dataSource = self.shopCatagoryViewModel2;
    self.shopCatagoryView.contentTableView.delegate = self.shopCatagoryViewModel2;
    __weak typeof(self) weakSelf = self;
    self.shopCatagoryViewModel.handler = ^void(NSIndexPath *indexPath, SFCatagoryItem *item) {
        weakSelf.shopCatagoryViewModel2.item = item;
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf.shopCatagoryView.contentTableView reloadData];
        });
    };
    ComplectionHandler complectionHander = ^void(SFCatagoryItem *item, NSInteger idx) {
        NSLog(@"%@ %ld", item, idx);
        weakSelf.shopCatagoryView.hidden = YES;
        self.catagoryItemSelected = item;
    };
    self.shopCatagoryViewModel.complectionHandler = complectionHander;
    self.shopCatagoryViewModel2.complectionHandler = complectionHander;
    
    //区域位置选择
    self.shopAreaView.menuTableView.dataSource = self.shopAreaViewModel;
    self.shopAreaView.menuTableView.delegate = self.shopAreaViewModel;
    self.shopAreaView.contentTableView.dataSource = self.shopAreaViewModel2;
    self.shopAreaView.contentTableView.delegate = self.shopAreaViewModel2;
    self.shopAreaViewModel.handler = ^void(NSIndexPath *indexPath, SFCatagoryItem *item) {
        weakSelf.shopAreaViewModel2.item = item;
        weakSelf.shopSortViewModel2.item = item;
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf.shopAreaView.contentTableView reloadData];
            [weakSelf.shopSortView reloadData];
        });
    };
    ComplectionHandler complectionHander2 = ^void(SFCatagoryItem *item, NSInteger idx) {
        NSLog(@"%@ %ld", item, idx);
        weakSelf.areaItemSelected = item;
        weakSelf.shopAreaView.hidden = YES;
    };
    self.shopAreaViewModel.complectionHandler = complectionHander2;
    self.shopAreaViewModel2.complectionHandler = complectionHander2;
    
    ComplectionHandler complectionHander3 = ^void(SFCatagoryItem *item, NSInteger idx) {
        NSLog(@"%@ %ld", item, idx);
        weakSelf.sortItemSelected = item;
        weakSelf.shopSortView.hidden = YES;
    };
    self.shopSortView.delegate   = self.shopSortViewModel2;
    self.shopSortView.dataSource = self.shopSortViewModel2;
    self.shopSortViewModel2.complectionHandler = complectionHander3;
    
    //按钮绑定
    [self.catagorySegment.leftButton addTarget:self action:@selector(onLeftButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.catagorySegment.centerButton addTarget:self action:@selector(onCenterButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.catagorySegment.rightButton addTarget:self action:@selector(onRightButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    //TableView
    self.tableView.dataSource = self;
    self.tableView.delegate   = self;
}


- (void)loadShops {
    NSURLSession *session = [NSURLSession sharedSession];
    NSString *url = [NSString stringWithFormat:@"%@/shop%@", SELFISH_HOST, self.queryCondiction?self.queryCondiction:@""];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
    [request addValue:@"application/json;charset=utf-8" forHTTPHeaderField:@"content-type"];
    request.HTTPMethod = @"GET";

    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if(error) {
            NSLog(@"请求出错: %@", error);
            [SVProgressHUD showErrorWithStatus:@"加载失败"];
            [SVProgressHUD dismissWithDelay:0.25];
            return;
        }
        NSError *jsonError;
        NSDictionary *result = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&jsonError];
        if(jsonError) {
            NSLog(@"结果解析错误:%@", jsonError);
            [SVProgressHUD showErrorWithStatus:@"加载失败"];
            [SVProgressHUD dismissWithDelay:0.25];
            return;
        }
        
        if([result[@"success"] isEqualToString:@"true"]) {
            NSLog(@"菜单获取成功%@", result);
            NSArray *content = result[@"content"];
            [content enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL * _Nonnull stop) {
                SFShopItem *item = [SFShopItem mj_objectWithKeyValues:obj];
                [self.items addObject:item];
                
            }];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView reloadData];
            });
        }
        [SVProgressHUD showSuccessWithStatus:@"加载成功"];
        [SVProgressHUD dismissWithDelay:0.25];
    }];
    [SVProgressHUD showWithStatus:@"加载数据中..."];
    [dataTask resume];
}

#pragma mark - Action Handler

- (void)handleRandomAction:(id)sender {
    SFShopFoodRandomVC *vc = [SFShopFoodRandomVC new];
    UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController: vc];
    [self presentViewController:navi animated:YES completion:nil];
}

- (void)handleLocationAction:(id)sender {
    __weak typeof(self) weakSelf = self;
    [[SULocationManager defaultManager] getLocation:^(CLLocation *location, AMapLocationReGeocode *regeocode, NSError *error) {
        if (error)
        {
            NSLog(@"locError:{%ld - %@};", (long)error.code, error.localizedDescription);
            
            if (error.code == AMapLocationErrorLocateFailed)
            {
                return;
            }
        }
        NSLog(@"location:%@", location);
        
        if (regeocode)
        {
            NSLog(@"reGeocode:%@", regeocode);
        }
        weakSelf.detailLocation.location  = location;
        weakSelf.detailLocation.reGeocode = regeocode;
    }];
}

- (void)onLeftButtonAction:(id)sender {
    self.shopSortView.hidden = YES;
    self.shopAreaView.hidden = YES;
    self.shopCatagoryView.hidden = !self.shopCatagoryView.hidden;
}

- (void)onCenterButtonAction:(id)sender {
    self.shopSortView.hidden = YES;
    self.shopAreaView.hidden = !self.shopAreaView.isHidden;
    self.shopCatagoryView.hidden = YES;
}

- (void)onRightButtonAction:(id)sender {
    self.shopSortView.hidden = !self.shopSortView.isHidden;
    self.shopAreaView.hidden = YES;
    self.shopCatagoryView.hidden = YES;
}

#pragma mark - Private

- (void)configCell:(SFShopTableViewCell *)cell withItem:(SFShopItem *)item {
    cell.shopNameLabel.text        = item.name;
    cell.shopAvergaeCostLabel.text = [NSString stringWithFormat:@"人均:￥%.2lf",item.averageCost];
    cell.shopLocationLabel.text    = item.locationName;
    switch (item.type) {
        case SFShopTypeEnternment:
            cell.shopTypeLabel.text = @"娱乐";
            break;
        case SFShopTypeFood:
        default:
            cell.shopTypeLabel.text = @"美食";
            break;
    }
    if(item.pics.count>0) {
        [cell.shopCoverImageView sd_setImageWithURL:[NSURL URLWithString:item.pics[0]]];
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.items.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SFShopTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier forIndexPath:indexPath];
    SFShopItem *shopItem = [self.items objectAtIndex:indexPath.row];
    //数据赋值
    if(shopItem) {
        [self configCell:cell withItem:shopItem];
    }
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 80;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    SFShopDetailVC *vc = [SFShopDetailVC new];
    vc.shopItem = [self.items objectAtIndex:indexPath.row];
    vc.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - Getter & Setter

- (SFShopCatagoryToolBarView *)catagorySegment {
    if(!_catagorySegment) {
        _catagorySegment = [[SFShopCatagoryToolBarView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 44)];
    }
    return _catagorySegment;
}

- (UITableView *)tableView {
    if(!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, self.catagorySegment.botton, SCREEN_WIDTH, self.view.size.height-88) style:UITableViewStylePlain];
    }
    return _tableView;
}

- (SFShopCatagoryView *)shopCatagoryView {
    if(!_shopCatagoryView) {
        _shopCatagoryView = [[SFShopCatagoryView alloc] initWithFrame:CGRectMake(0, self.catagorySegment.botton, SCREEN_WIDTH, SCREEN_WIDTH/0.85)];
        _shopCatagoryView.hidden = YES;
    }
    return _shopCatagoryView;
}

- (SFShopCatagoryViewModel *)shopCatagoryViewModel {
    if(!_shopCatagoryViewModel) {
        _shopCatagoryViewModel = [SFShopCatagoryViewModel new];
    }
    return _shopCatagoryViewModel;
}

- (SFShopCatagoryViewModel2 *)shopCatagoryViewModel2 {
    if(!_shopCatagoryViewModel2) {
        _shopCatagoryViewModel2 = [SFShopCatagoryViewModel2 new];
    }
    return _shopCatagoryViewModel2;
}

- (SFShopCatagoryViewModel *)shopAreaViewModel {
    if(!_shopAreaViewModel) {
        _shopAreaViewModel = [SFShopCatagoryViewModel new];
    }
    return _shopAreaViewModel;
}

- (SFShopCatagoryViewModel2 *)shopAreaViewModel2 {
    if(!_shopAreaViewModel2) {
        _shopAreaViewModel2 = [SFShopCatagoryViewModel2 new];
    }
    return _shopAreaViewModel2;
}

- (SFShopCatagoryViewModel2 *)shopSortViewModel2 {
    if(!_shopSortViewModel2) {
        _shopSortViewModel2 = [SFShopCatagoryViewModel2 new];
    }
    return _shopSortViewModel2;
}

- (NSMutableArray *)items {
    if(!_items) {
        _items = [NSMutableArray array];
    }
    return _items;
}

//TODO 这里的位置获取逻辑需要改进
- (SULocation *)detailLocation {
    if(_detailLocation == nil) {
        _detailLocation = [SULocation new];
        [[SULocationManager defaultManager] getLocation:^(CLLocation *location, AMapLocationReGeocode *regeocode, NSError *error) {
            if (error)
            {
                NSLog(@"locError:{%ld - %@};", (long)error.code, error.localizedDescription);
                
                if (error.code == AMapLocationErrorLocateFailed)
                {
                    return;
                }
            }
            NSLog(@"location:%@", location);
            
            if (regeocode)
            {
                NSLog(@"reGeocode:%@", regeocode);
            }
            _detailLocation.location  = location;
            _detailLocation.reGeocode = regeocode;
        }];
    }
    return _detailLocation;
}


- (SFShopCatagoryView *)shopAreaView {
    if(!_shopAreaView) {
        _shopAreaView = [[SFShopCatagoryView alloc] initWithFrame:CGRectMake(0, self.catagorySegment.botton, SCREEN_WIDTH, SCREEN_WIDTH/0.85)];
        _shopAreaView.hidden = YES;
    }
    return _shopAreaView;
}

- (UITableView *)shopSortView {
    if(!_shopSortView) {
        _shopSortView = [[UITableView alloc] initWithFrame:CGRectMake(0, self.catagorySegment.botton, SCREEN_WIDTH, SCREEN_WIDTH/0.85) style:UITableViewStyleGrouped];
        _shopSortView.hidden = YES;
    }
    return _shopSortView;
}

- (NSString *)queryCondiction {
    NSMutableString *mutString = [NSMutableString string];
    [mutString appendString:@"?"];
    if(self.catagoryItemSelected) {
        NSLog(@"%@",self.catagoryItemSelected.name);
        [mutString appendString:[NSString stringWithFormat:@"type=%@&", self.catagoryItemSelected.name]];
    }
    if(self.areaItemSelected) {
        NSLog(@"%@",self.areaItemSelected.name);
        [mutString appendString:[NSString stringWithFormat:@"area=%@&", self.areaItemSelected.name]];
    }
    if(self.sortItemSelected) {
        NSLog(@"%@",self.sortItemSelected.name);
        [mutString appendString:[NSString stringWithFormat:@"sort=%@&", self.sortItemSelected.name]];
    }
    _queryCondiction = mutString;
    return _queryCondiction;
}

@end
