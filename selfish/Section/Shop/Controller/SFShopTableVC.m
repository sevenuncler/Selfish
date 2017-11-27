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

static NSString * const reuseIdentifier = @"商家表单元";

@interface SFShopTableVC ()<UITableViewDataSource, UITableViewDelegate>
@property(nonatomic,strong) SFShopCatagoryToolBarView *catagorySegment;
@end

@implementation SFShopTableVC

- (void)viewDidLoad {
    [super viewDidLoad];
    //vc.view往下移动，不让其被导航栏遮挡，与automaticalAjustScrollViewInsect差不多（略微差别）
    self.edgesForExtendedLayout  = UIRectEdgeNone;
    self.navigationController.navigationBar.translucent = NO;
    [self.view addSubview:self.catagorySegment];
    [self.view addSubview:self.tableView];
    
    [self.tableView registerClass:[SFShopTableViewCell class] forCellReuseIdentifier:reuseIdentifier];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    [self presentViewController:vc animated:YES completion:nil];
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

@end
