//
//  HomeVC.m
//  selfish
//
//  Created by He on 2017/11/22.
//  Copyright © 2017年 He. All rights reserved.
//

#import "HomeVC.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "Macros.h"
#import "UIView+Layout.h"
#import "ViewController.h"
#import "HomeAnimator.h"
#import "HomeViewModel.h"
#import "DetailVC.h"


@interface HomeVC () <UIViewControllerTransitioningDelegate>
@property(nonatomic,strong) HomeViewModel *homeViewModel;
@property(nonatomic,strong) HomeAnimator  *homeAnimator;
@end

@implementation HomeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.homeAnimator = [HomeAnimator new];
    self.homeAnimator.homeAnimatorType = HomeAnimatorTypeMagicMove;
    
    [self.view addSubview:self.tableView];
    [self setUpBind];
}

- (void)dealloc {
    NSLog(@"我被销毁了");
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
}

- (void)setUpBind {
    @weakify(self);
    [self.homeViewModel.selectedIndexSignal subscribeNext:^(id x) {
        @strongify(self);
        self.currentIndexPath = x;
        [self presentVCAction:nil];
    }];
    
    self.tableView.dataSource = self.homeViewModel;
    self.tableView.delegate   = self.homeViewModel;
    
    
}

- (void)presentVCAction:(id)sender {
    UIViewController *vc = [DetailVC new];
    vc.view.backgroundColor = [UIColor whiteColor];
    vc.modalPresentationStyle = UIModalPresentationCustom;
    vc.transitioningDelegate  = self;
    [self presentViewController:vc animated:YES completion:nil];
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
