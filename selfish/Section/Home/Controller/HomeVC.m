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
#import "ViewController.h"
#import "HomeAnimator.h"

@interface HomeVC () <UIViewControllerTransitioningDelegate>
@property(nonatomic,strong) UITableView *tableView;
@property(nonatomic,strong) HomeViewModel *homeViewModel;
@property(nonatomic,strong) HomeAnimator  *homeAnimator;
@end

@implementation HomeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.homeAnimator = [HomeAnimator new];
    
//    [self.view addSubview:self.tableView];
    [self setUpBind];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    ViewController *vc = [ViewController new];
    vc.view.backgroundColor = [UIColor redColor];
    vc.modalPresentationStyle = UIModalPresentationCustom;
    vc.transitioningDelegate  = self;
    [self presentViewController:vc animated:YES completion:nil];
}

- (void)setUpBind {
    self.tableView.dataSource = self.homeViewModel;
    self.tableView.delegate   = self.homeViewModel;
}

- (id <UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source {
    return self.homeAnimator;
}

- (nullable id <UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
    return self.homeAnimator;
}








#pragma mark - Getter & Setter

- (UITableView *)tableView {
    if(!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.size.width, self.view.size.height) style:UITableViewStyleGrouped];
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
