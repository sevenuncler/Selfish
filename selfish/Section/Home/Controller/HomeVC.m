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
#import "HomeAnimator.h"
#import "HomeViewModel.h"
#import "DetailVC.h"
#import "HomeInteractiveAnimator.h"


@interface HomeVC () <UIViewControllerTransitioningDelegate>
@property(nonatomic,strong) HomeViewModel *homeViewModel;
@property(nonatomic,strong) HomeAnimator  *homeAnimator;
@property(nonatomic,strong) HomeInteractiveAnimator *homeInteractiveAnimator;
@end

@implementation HomeVC

- (void)viewDidLoad {
    [super viewDidLoad];
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
    self.automaticallyAdjustsScrollViewInsets = NO;
#pragma clang diagnostic pop
    self.view.backgroundColor = [UIColor redColor];
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
        dispatch_async(dispatch_get_main_queue(), ^{
            [self presentVCAction:nil];
        });
    }];
    
    self.tableView.dataSource = self.homeViewModel;
    self.tableView.delegate   = self.homeViewModel;
    
    
}

- (void)presentVCAction:(id)sender {
    UIViewController *vc = [DetailVC new];
    vc.view.backgroundColor = [UIColor whiteColor];
    vc.modalPresentationStyle = UIModalPresentationCustom;
    vc.transitioningDelegate  = self;
    self.homeInteractiveAnimator = [HomeInteractiveAnimator interactiveAnimatorWithVC:vc];
//    [self presentViewController:vc animated:YES completion:nil];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - UIViewControllerTransitioningDelegate

- (id <UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source {
    return self.homeAnimator;
}

- (id <UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
    return self.homeAnimator;
}

- (id <UIViewControllerInteractiveTransitioning>)interactionControllerForDismissal:(id <UIViewControllerAnimatedTransitioning>)animator {
    return self.homeInteractiveAnimator;
}

#pragma mark - Getter & Setter

- (UITableView *)tableView {
    if(!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, self.view.size.width, self.view.size.height) style:UITableViewStyleGrouped];
    }
    return _tableView;
}

- (HomeViewModel *)homeViewModel {
    if(!_homeViewModel) {
        _homeViewModel = [HomeViewModel new];
    }
    return _homeViewModel;
}

- (HomeInteractiveAnimator *)homeInteractiveAnimator {
    if(!_homeInteractiveAnimator) {
        _homeInteractiveAnimator = [HomeInteractiveAnimator new];
    }
    return _homeInteractiveAnimator;
}



@end
