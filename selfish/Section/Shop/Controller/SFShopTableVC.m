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
#import "SFShopQreaViewModel.h"
#import "SFShopAreaViewModel2.h"
#import "SFShopFoodRandomVC.h"
#import "SFShopItem.h"
#import "SULocationManager.h"
#import "SFLocationItem.h"
#import "SULocationManager.h"
#import "SUAddressItem.h"
#import "UIView+Layout.h"
#import "Macros.h"

#import <CoreLocation/CoreLocation.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import <MJExtension/MJExtension.h>
#import <SVProgressHUD/SVProgressHUD.h>
#import <ReactiveCocoa/ReactiveCocoa.h>


static NSString * const reuseIdentifier = @"商家表单元";
dispatch_semaphore_t semaphore ;
static BOOL isRefresh = YES;
@interface SFShopTableVC ()<UITableViewDataSource, UITableViewDelegate>
@property(nonatomic,strong) SFShopCatagoryToolBarView *catagorySegment;
@property(nonatomic,strong) SFShopCatagoryView        *shopCatagoryView;
@property(nonatomic,strong) SFShopCatagoryViewModel   *shopCatagoryViewModel;
@property(nonatomic,strong) SFShopCatagoryViewModel2  *shopCatagoryViewModel2;
@property(nonatomic,strong) SFShopCatagoryView        *shopAreaView;
@property(nonatomic,strong) SFShopQreaViewModel       *shopAreaViewModel;
@property(nonatomic,strong) SFShopAreaViewModel2      *shopAreaViewModel2;
@property(nonatomic,strong) UITableView               *shopSortView;
@property(nonatomic,strong) SFShopCatagoryViewModel2  *shopSortViewModel2;
@property(nonatomic,strong) SFSubCatagory             *catagoryItemSelected;
@property(nonatomic,strong) SUNeigborhoodItem         *areaItemSelected;
@property(nonatomic,strong) SFSubCatagory             *sortItemSelected;
@property(nonatomic,strong) CLLocation                *userLocation;
@property(nonatomic,strong) SULocation                *detailLocation;
@property(nonatomic,copy)   NSString                  *queryCondiction;
@property(nonatomic,strong) SFLocationItem            *locationItem;

@end

@implementation SFShopTableVC


#pragma mark - Life Cycle

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
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        if(dispatch_semaphore_wait(semaphore, dispatch_time(DISPATCH_TIME_NOW, NSEC_PER_SEC * 1)) != 0) {
            [self loadShops];
        }
    });
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self setUpNavigator];
    
}

- (void)setUpNavigator {
    self.title = @"商铺";
    
    UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"定位" style:UIBarButtonItemStylePlain target:self action:@selector(handleLocationAction:)];
    self.navigationItem.leftBarButtonItem = leftBarButtonItem;
    
    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"随便" style:UIBarButtonItemStylePlain target:self action:@selector(handleRandomAction:)];
    self.navigationItem.rightBarButtonItem = rightBarButtonItem;
}

- (void)setUpBind {
    
    // 下拉刷新
    __weak typeof(self) weakSelf = self;
    UIPanGestureRecognizer *panGR = [[UIPanGestureRecognizer alloc] init];
    panGR.delegate = self;
    [[panGR rac_gestureSignal] subscribeNext:^(UIPanGestureRecognizer *x) {
        if(x.state == UIGestureRecognizerStateEnded && weakSelf.tableView.contentOffset.y < -100) {
            [weakSelf loadShops];
        }
    }];
    [self.tableView addGestureRecognizer:panGR];
    
//    [RACObserve(self.tableView, contentOffset) subscribeNext:^(id x) {
//        NSLog(@"%@", x);
//    }];
    
    // 类别
    self.shopCatagoryView.menuTableView.dataSource = self.shopCatagoryViewModel;
    self.shopCatagoryView.menuTableView.delegate = self.shopCatagoryViewModel;
    self.shopCatagoryView.contentTableView.dataSource = self.shopCatagoryViewModel2;
    self.shopCatagoryView.contentTableView.delegate = self.shopCatagoryViewModel2;
    self.shopCatagoryViewModel.handler = ^void(NSIndexPath *indexPath, SFCatagoryItem *item) {
        weakSelf.shopCatagoryViewModel2.item = item;
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf.shopCatagoryView.contentTableView reloadData];
        });
    };
    
    ComplectionHandler complectionHander = ^void(SFCatagoryItem *item, NSInteger idx) {
        NSLog(@"%@ %ld", item, idx);
        weakSelf.shopCatagoryView.hidden = YES;
        weakSelf.catagoryItemSelected.name = item.name;
        [weakSelf.catagorySegment.leftButton setTitle:item.name forState:UIControlStateNormal];
        if(item && idx >= 0 && item.subCatagories.count>0 ) {
            SFSubCatagory *subCatagory = [item.subCatagories objectAtIndex:idx];
            weakSelf.catagoryItemSelected = subCatagory;
            [weakSelf.catagorySegment.leftButton setTitle:subCatagory.subName forState:UIControlStateNormal];
        }
        if(idx == -1) {
            weakSelf.catagoryItemSelected.subName = nil;
        }
        [weakSelf loadShops];
    };
    self.shopCatagoryViewModel.complectionHandler = complectionHander;
    self.shopCatagoryViewModel2.complectionHandler = complectionHander;
    
    // 区域位置选择
    self.shopAreaView.menuTableView.dataSource = self.shopAreaViewModel;
    self.shopAreaView.menuTableView.delegate = self.shopAreaViewModel;
    self.shopAreaView.contentTableView.dataSource = self.shopAreaViewModel2;
    self.shopAreaView.contentTableView.delegate = self.shopAreaViewModel2;
    self.shopAreaViewModel.handler = ^void(NSIndexPath *indexPath, SFDistrictItem *item) {
        weakSelf.shopAreaViewModel2.item = item;
        
        weakSelf.areaItemSelected.country = @"中国";
        weakSelf.areaItemSelected.province = @"浙江省";
        weakSelf.areaItemSelected.city     = @"杭州";
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf.shopAreaView.contentTableView reloadData];
        });
    };
    
    void(^complectionHander2)(SFDistrictItem *item, NSInteger idx)  = ^void(SFDistrictItem *item, NSInteger idx) {
        NSLog(@"%@ %ld", item, idx);
        if(idx == -1) {
            weakSelf.areaItemSelected.district = nil;
        }else {
            weakSelf.areaItemSelected.district = item.name;
        }
        weakSelf.areaItemSelected.country = @"中国";
        weakSelf.areaItemSelected.province = @"浙江省";
        weakSelf.areaItemSelected.city     = @"杭州";
        
        weakSelf.shopAreaView.hidden = YES;
        [weakSelf loadShops];
    };
    void(^complectionHander4)(SFDistrictItem *item, NSInteger idx)  = ^void(SFDistrictItem *item, NSInteger idx) {
        if(item && idx >= 0 && item.subNeigborhoods) {
            weakSelf.areaItemSelected.neigborhood = item.subNeigborhoods[idx].name;
            [weakSelf.catagorySegment.centerButton setTitle:weakSelf.areaItemSelected.neigborhood forState:UIControlStateNormal];
        }
        weakSelf.shopAreaView.hidden = YES;
        [weakSelf loadShops];
    };
    self.shopAreaViewModel.complectionHandler = complectionHander2;
    self.shopAreaViewModel2.complectionHandler = complectionHander4;
    
    // 排序

    ComplectionHandler complectionHander3 = ^void(SFCatagoryItem *item, NSInteger idx) {
        NSLog(@"%@ %ld", item, idx);
        weakSelf.sortItemSelected = item.subCatagories[idx];
        [weakSelf.catagorySegment.rightButton setTitle:weakSelf.sortItemSelected.subName forState:UIControlStateNormal];

        weakSelf.shopSortView.hidden = YES;
        [weakSelf loadShops];
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
    NSString *queryParams = self.queryCondiction;
    NSString *url = [NSString stringWithFormat:@"%@/shop%@", SELFISH_HOST, queryParams?queryParams:@""];
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
            if(isRefresh) {
                [self.items removeAllObjects];
            }
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

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    if ([otherGestureRecognizer.view isKindOfClass:[UITableView class]]) {
        return YES;
    }
    return NO;
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
        weakSelf.locationItem.reGecode = regeocode;
        
        [weakSelf loadShops];
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
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, self.catagorySegment.botton, SCREEN_WIDTH, self.view.size.height-self.catagorySegment.botton - 44 - 44 - 22) style:UITableViewStylePlain];
        _tableView.tableFooterView = [UIView new];
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

- (SFShopQreaViewModel *)shopAreaViewModel {
    if(!_shopAreaViewModel) {
        _shopAreaViewModel = [SFShopQreaViewModel new];
    }
    return _shopAreaViewModel;
}

- (SFShopAreaViewModel2 *)shopAreaViewModel2 {
    if(!_shopAreaViewModel2) {
        _shopAreaViewModel2 = [SFShopAreaViewModel2 new];
    }
    return _shopAreaViewModel2;
}

- (SFShopCatagoryViewModel2 *)shopSortViewModel2 {
    if(!_shopSortViewModel2) {
        _shopSortViewModel2 = [SFShopCatagoryViewModel2 new];
        NSMutableArray *array = [NSMutableArray array];
        {
            SFSubCatagory *item = [SFSubCatagory new];
            item.subName = @"综合排序";
            [array addObject:item];
        }
        {
            SFSubCatagory *item = [SFSubCatagory new];
            item.subName = @"距离最近";
            [array addObject:item];
        }{
            SFSubCatagory *item = [SFSubCatagory new];
            item.subName = @"好评优先";
            [array addObject:item];
        }{
            SFSubCatagory *item = [SFSubCatagory new];
            item.subName = @"价格最低";
            [array addObject:item];
        }
        SFCatagoryItem *item = [SFCatagoryItem new];
        item.subCatagories = array.copy;
        _shopSortViewModel2.item = item;
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
            _detailLocation.location  = location;
            _detailLocation.reGeocode = regeocode;
            weakSelf.areaItemSelected.country  = regeocode.country;
            weakSelf.areaItemSelected.province = regeocode.province;
            weakSelf.areaItemSelected.city     = regeocode.city;
            weakSelf.areaItemSelected.district = regeocode.district;
            // TODO 街区定位
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
        _shopSortView = [[UITableView alloc] initWithFrame:CGRectMake(0, self.catagorySegment.botton, SCREEN_WIDTH, SCREEN_WIDTH/0.85) style:UITableViewStylePlain];
        _shopSortView.hidden = YES;
    }
    return _shopSortView;
}

- (NSString *)queryCondiction {
    NSMutableString *mutString = [NSMutableString string];
    [mutString appendString:@"?"];
    
    // 类目限定
    if(self.catagoryItemSelected) {
        if(self.catagoryItemSelected.name) {
            [mutString appendString:[NSString stringWithFormat:@"type='%@'&", self.catagoryItemSelected.name]];
        }
        if(self.catagoryItemSelected.subName) {
            [mutString appendString:[NSString stringWithFormat:@"subType='%@'&", self.catagoryItemSelected.subName]];
        }
    }
    
    // 区域限定
    if(self.locationItem) {
        if(self.locationItem.reGecode) {
            AMapLocationReGeocode *reGeocode = self.locationItem.reGecode;
            if(reGeocode.country) {
                [mutString appendString:[NSString stringWithFormat:@"country='%@'&", reGeocode.country]];
            }
            if(reGeocode.province) {
                [mutString appendString:[NSString stringWithFormat:@"province='%@'&", reGeocode.province]];
            }
            if(reGeocode.city) {
                [mutString appendString:[NSString stringWithFormat:@"city='%@'&", reGeocode.city]];
            }
            if(reGeocode.district) {
                [mutString appendString:[NSString stringWithFormat:@"district='%@'&", reGeocode.district]];
            }
        }
        
    }
    if(self.areaItemSelected) {
        if(self.areaItemSelected.country) {
            [mutString appendString:[NSString stringWithFormat:@"country='%@'&", self.areaItemSelected.country]];
        }
        if(self.areaItemSelected.province) {
            [mutString appendString:[NSString stringWithFormat:@"province='%@'&", self.areaItemSelected.province]];
        }
        if(self.areaItemSelected.city) {
            [mutString appendString:[NSString stringWithFormat:@"city='%@'&", self.areaItemSelected.city]];
        }
        if(self.areaItemSelected.district) {
            [mutString appendString:[NSString stringWithFormat:@"district='%@'&", self.areaItemSelected.district]];
        }
        if(self.areaItemSelected.neigborhood) {
            [mutString appendString:[NSString stringWithFormat:@"neigborhood='%@'&", self.areaItemSelected.neigborhood]];
        }
    }
    
    // 排序方式
    if(self.sortItemSelected) {
        if(self.sortItemSelected.subName) {
            [mutString appendString:[NSString stringWithFormat:@"sort='%@'&", self.sortItemSelected.subName]];
        }
    }
    NSLog(@"查询条件：%@", mutString);
    _queryCondiction = [mutString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    return _queryCondiction;
}

- (SFLocationItem *)locationItem {
    if(!_locationItem) {
        _locationItem = [SFLocationItem new];
    }
    return _locationItem;
}

- (SUNeigborhoodItem *)areaItemSelected {
    if(!_areaItemSelected) {
        _areaItemSelected = [SUNeigborhoodItem new];
    }
    return _areaItemSelected;
}

- (SFSubCatagory *)catagoryItemSelected {
    if(!_catagoryItemSelected) {
        _catagoryItemSelected = [SFSubCatagory new];
        _catagoryItemSelected.name = @"全部";
    }
    return _catagoryItemSelected;
}

- (SFSubCatagory *)sortItemSelected {
    if(!_sortItemSelected) {
        _sortItemSelected = [SFSubCatagory new];
    }
    return _sortItemSelected;
}
@end
