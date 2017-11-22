//
//  HomeVC.m
//  selfish
//
//  Created by He on 2017/11/22.
//  Copyright © 2017年 He. All rights reserved.
//

#import "HomeVC.h"
#import "HomeViewModel.h"
#import "Macros.h"
#import "UIView+Layout.h"

@interface HomeVC ()
@property(nonatomic,strong) UITableView *tableView;
@property(nonatomic,strong) HomeViewModel *homeViewModel;
@end

@implementation HomeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.tableView];
    [self setUpBind];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setUpBind {
    self.tableView.dataSource = self.homeViewModel;
    self.tableView.delegate   = self.homeViewModel;
}

#pragma mark - Getter & Setter

- (UITableView *)tableView {
    if(!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    }
    return _tableView;
}

- (HomeViewModel *)homeViewModel {
    if(!_homeViewModel) {
        _homeViewModel = [HomeViewModel new];
    }
    return _homeViewModel;
}



@end
