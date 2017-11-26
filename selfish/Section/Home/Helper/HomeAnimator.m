//
//  HomeAnimator.m
//  selfish
//
//  Created by He on 2017/11/24.
//  Copyright © 2017年 He. All rights reserved.
//

#import "HomeAnimator.h"
#import "UIView+Layout.h"
#import "HomeVC.h"
#import "HomeTableViewCell.h"
#import "DetailVC.h"
#import "SFNavigationController.h"

@implementation HomeAnimator

#pragma mark - UIViewControllerAnimatedTransitioning

- (NSTimeInterval)transitionDuration:(nullable id <UIViewControllerContextTransitioning>)transitionContext {
    return 0.4;
}

- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext {
    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    if([fromVC isMemberOfClass:[HomeVC class]] || [fromVC isKindOfClass:[UINavigationController class]] || [fromVC isKindOfClass:[UITabBarController class]]) {
        switch (self.homeAnimatorType) {
            case HomeAnimatorTypeDefault:
                [self presentAnimation:transitionContext];
                break;
            case HomeAnimatorTypeMagicMove:
                [self magicMovePresentionAnimation:transitionContext];
            default:
                break;
        }
    }else if([fromVC isMemberOfClass:[DetailVC class]]) {
        switch (self.homeAnimatorType) {
            case HomeAnimatorTypeDefault:
                [self presentAnimation:transitionContext];
                break;
            case HomeAnimatorTypeMagicMove:
                [self magicMoveDismissAnimation:transitionContext];
            default:
                break;
        }
    }else {
        [transitionContext completeTransition:NO];
    }
    
}

- (void)presentAnimation:(id <UIViewControllerContextTransitioning>)transitionContext {
    //通过viewControllerForKey取出转场前后的两个控制器，这里toVC就是vc1、fromVC就是vc2
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    //snapshotViewAfterScreenUpdates可以对某个视图截图，我们采用对这个截图做动画代替直接对vc1做动画，因为在手势过渡中直接使用vc1动画会和手势有冲突，    如果不需要实现手势的话，就可以不是用截图视图了，大家可以自行尝试一下
    UIView *tempView = [fromVC.view snapshotViewAfterScreenUpdates:YES];
    tempView.frame = fromVC.view.frame;
    //因为对截图做动画，vc1就可以隐藏了
    fromVC.view.hidden = YES;
    //这里有个重要的概念containerView，如果要对视图做转场动画，视图就必须要加入containerView中才能进行，可以理解containerView管理着所有做转场动画的视图
    UIView *containerView = [transitionContext containerView];
    //将截图视图和vc2的view都加入ContainerView中
    [containerView addSubview:tempView];
    [containerView addSubview:toVC.view];
    //设置vc2的frame，因为这里vc2present出来不是全屏，且初始的时候在底部，如果不设置frame的话默认就是整个屏幕咯，这里containerView的frame就是整个屏幕
    toVC.view.frame = CGRectMake(0, containerView.size.height, containerView.size.width, 400);
    //开始动画吧，使用产生弹簧效果的动画API
    [UIView animateWithDuration:[self transitionDuration:transitionContext] delay:0 usingSpringWithDamping:0.55 initialSpringVelocity:1.0 / 0.55 options:0 animations:^{
        //首先我们让vc2向上移动
        toVC.view.transform = CGAffineTransformMakeTranslation(0, -400);
        //然后让截图视图缩小一点即可
        tempView.transform = CGAffineTransformMakeScale(0.85, 0.85);
    } completion:^(BOOL finished) {
        //使用如下代码标记整个转场过程是否正常完成[transitionContext transitionWasCancelled]代表手势是否取消了，如果取消了就传NO表示转场失败，反之亦然，如果不用手势present的话直接传YES也是可以的，但是无论如何我们都必须标记转场的状态，系统才知道处理转场后的操作，否者认为你一直还在转场中，会出现无法交互的情况，切记！
        [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
        //转场失败后的处理
        if ([transitionContext transitionWasCancelled]) {
            //失败后，我们要把vc1显示出来
            fromVC.view.hidden = NO;
            //然后移除截图视图，因为下次触发present会重新截图
            [tempView removeFromSuperview];
        }
    }];
}

- (void)magicMovePresentionAnimation:(id <UIViewControllerContextTransitioning>)transitionContext {
    DetailVC *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    HomeVC *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];

    if([fromVC isKindOfClass:[UINavigationController class]]) {
        fromVC = (HomeVC *)((UINavigationController *)fromVC).topViewController;
        if([fromVC isKindOfClass:[UITabBarController class]]) {
            fromVC = ((UITabBarController *)fromVC).childViewControllers[0];
        }
        if([fromVC isKindOfClass:[UINavigationController class]]) {
            fromVC = (HomeVC *)((UINavigationController *)fromVC).topViewController;
        }
    }
    if([fromVC isKindOfClass:[UITabBarController class]]) {
        fromVC = ((UITabBarController *)fromVC).childViewControllers[0];
        if([fromVC isKindOfClass:[UINavigationController class]]) {
            fromVC = (HomeVC *)((UINavigationController *)fromVC).topViewController;
        }
    }
    HomeTableViewCell *cell = [fromVC.tableView cellForRowAtIndexPath:fromVC.currentIndexPath];
    UIView *containerView = transitionContext.containerView;
    __block UIView *snapShot = [cell.coverImageView snapshotViewAfterScreenUpdates:NO]; //为什么是NO？
    snapShot.frame = [cell.coverImageView convertRect:cell.coverImageView.bounds toView:containerView];
    
    toVC.view.hidden = YES;
    toVC.topImageView.hidden = YES;
    
    [containerView addSubview:toVC.view];
    [containerView addSubview:snapShot];
    [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
        snapShot.frame = [toVC.topImageView convertRect:toVC.topImageView.bounds toView:containerView];
        toVC.view.hidden = NO;
    } completion:^(BOOL finished) {
        [transitionContext completeTransition:YES];
        toVC.topImageView.hidden = NO;
        [snapShot removeFromSuperview];
    }];
}

- (void)magicMoveDismissAnimation:(id <UIViewControllerContextTransitioning>)transitionContext {
    DetailVC *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    HomeVC *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    if([toVC isKindOfClass:[UINavigationController class]]) {
        toVC = (HomeVC *)((UINavigationController *)toVC).topViewController;
        if([toVC isKindOfClass:[UITabBarController class]]) {
            toVC = ((UITabBarController *)toVC).childViewControllers[0];
        }
        if([toVC isKindOfClass:[UINavigationController class]]) {
            toVC = (HomeVC *)((UINavigationController *)toVC).topViewController;
        }
    }
    if([toVC isKindOfClass:[UITabBarController class]]) {
        toVC = ((UITabBarController *)toVC).childViewControllers[0];
        if([toVC isKindOfClass:[UINavigationController class]]) {
            toVC = (HomeVC *)((UINavigationController *)toVC).topViewController;
        }
    }
    UIView *containerView = transitionContext.containerView;
    __block UIView *snapShotView = [fromVC.topImageView snapshotViewAfterScreenUpdates:NO];
    snapShotView.frame = [fromVC.topImageView convertRect:fromVC.topImageView.bounds toView:containerView];
    fromVC.view.hidden = YES;
    

    [containerView addSubview:snapShotView];
    toVC.view.hidden = NO;
    HomeTableViewCell *cell = [toVC.tableView cellForRowAtIndexPath:toVC.currentIndexPath];
    cell.coverImageView.alpha = 0;
    
    [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
        snapShotView.frame = [cell.coverImageView convertRect:cell.coverImageView.bounds toView:containerView];
    } completion:^(BOOL finished) {
        BOOL isCancelled = [transitionContext transitionWasCancelled];
        [transitionContext completeTransition:!isCancelled];
        if(isCancelled) {
            [snapShotView removeFromSuperview];
            fromVC.view.hidden = NO;
        }else {
            [snapShotView removeFromSuperview];
            cell.coverImageView.alpha = 1;
        }
        
    }];
}

@end
