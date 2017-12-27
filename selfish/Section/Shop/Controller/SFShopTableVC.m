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

#import <SDWebImage/UIImageView+WebCache.h>
#import <MJExtension/MJExtension.h>
#import <SVProgressHUD/SVProgressHUD.h>
#import "UIView+Layout.h"
#import "Macros.h"

static NSString * const reuseIdentifier = @"商家表单元";

@interface SFShopTableVC ()<UITableViewDataSource, UITableViewDelegate>
@property(nonatomic,strong) SFShopCatagoryToolBarView *catagorySegment;
@property(nonatomic,strong) SFShopCatagoryView        *shopCatagoryView;
@property(nonatomic,strong) SFShopCatagoryViewModel   *shopCatagoryViewModel;
@property(nonatomic,strong) SFShopCatagoryViewModel2  *shopCatagoryViewModel2;
@end

@implementation SFShopTableVC

- (void)viewDidLoad {
    [super viewDidLoad];
    //vc.view往下移动，不让其被导航栏遮挡，与automaticalAjustScrollViewInsect差不多（略微差别）
    self.edgesForExtendedLayout  = UIRectEdgeNone;
    self.navigationController.navigationBar.translucent = NO;
    [self.view addSubview:self.catagorySegment];
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.shopCatagoryView];
    
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
    
    UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"定位" style:UIBarButtonItemStylePlain target:self action:nil];
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
        [weakSelf.shopCatagoryView refresh];
        weakSelf.shopCatagoryView.hidden = YES;
    };
    self.shopCatagoryViewModel.complectionHandler = complectionHander;
    self.shopCatagoryViewModel2.complectionHandler = complectionHander;
    
    [self.catagorySegment.leftButton addTarget:self action:@selector(onLeftButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.catagorySegment.centerButton addTarget:self action:@selector(onLeftButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.catagorySegment.rightButton addTarget:self action:@selector(onLeftButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    //TableView
    self.tableView.dataSource = self;
    self.tableView.delegate   = self;

}

- (void)loadShops {
    NSURLSession *session = [NSURLSession sharedSession];
    NSString *url = [NSString stringWithFormat:@"%@/shop", SELFISH_HOST];
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

- (void)onLeftButtonAction:(id)sender {
    self.shopCatagoryView.hidden = !self.shopCatagoryView.hidden;
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

- (NSMutableArray *)items {
    if(!_items) {
        _items = [NSMutableArray array];
    }
    return _items;
}


@end
