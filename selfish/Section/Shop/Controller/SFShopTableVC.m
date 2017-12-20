//
//  SFShopTableVC.m
//  selfish
//
//  Created by He on 2017/11/25.
//  Copyright © 2017年 He. All rights reserved.
//

#import "SFShopTableVC.h"
#import "SFShopTableViewCell.h"
#import "UIView+Layout.h"
#import "SFShopDetailVC.h"
#import "Macros.h"
#import "SFShopCatagoryToolBarView.h"
#import "SFShopCatagoryView.h"
#import "SFShopCatagoryViewModel.h"
#import "SFShopCatagoryViewModel2.h"
#import "SFShopFoodRandomVC.h"

static NSString * const reuseIdentifier = @"商家表单元";

@interface SFShopTableVC ()<UITableViewDataSource, UITableViewDelegate>
@property(nonatomic,strong) SFShopCatagoryToolBarView *catagorySegment;
@property(nonatomic,strong) SFShopCatagoryView *shopCatagoryView;
@property(nonatomic,strong) SFShopCatagoryViewModel *shopCatagoryViewModel;
@property(nonatomic,strong) SFShopCatagoryViewModel2 *shopCatagoryViewModel2;

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
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setUpNavigator {
    self.title = @"商铺";
    
    UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"定位" style:UIBarButtonItemStylePlain target:self action:@selector(handleBackAction:)];
    self.navigationItem.leftBarButtonItem = leftBarButtonItem;
    
    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"随便" style:UIBarButtonItemStylePlain target:self action:@selector(handleRandomAction:)];
    self.navigationItem.rightBarButtonItem = rightBarButtonItem;
}

- (void)handleRandomAction:(id)sender {
    SFShopFoodRandomVC *vc = [SFShopFoodRandomVC new];
    UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController: vc];
    [self presentViewController:navi animated:YES completion:nil];
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

}

- (void)onLeftButtonAction:(id)sender {
    self.shopCatagoryView.hidden = !self.shopCatagoryView.hidden;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 10;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 80;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    SFShopDetailVC *vc = [SFShopDetailVC new];
    vc.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    [self.navigationController pushViewController:vc animated:YES];
}

- (SFShopCatagoryToolBarView *)catagorySegment {
    if(!_catagorySegment) {
        _catagorySegment = [[SFShopCatagoryToolBarView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 44)];
    }
    return _catagorySegment;
}

- (UITableView *)tableView {
    if(!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, self.catagorySegment.botton, SCREEN_WIDTH, self.view.size.height-88) style:UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.delegate   = self;
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


@end
