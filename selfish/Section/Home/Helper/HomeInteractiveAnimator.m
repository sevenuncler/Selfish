//
//  HomeInteractiveAnimator.m
//  selfish
//
//  Created by He on 2017/11/25.
//  Copyright © 2017年 He. All rights reserved.
//

#import "HomeInteractiveAnimator.h"

@interface HomeInteractiveAnimator()
@property(nonatomic, weak) UIViewController *targetVC;
@property(nonatomic, assign) CGFloat        animationPercent;
@end

@implementation HomeInteractiveAnimator

+ (instancetype)interactiveAnimatorWithVC:(UIViewController *)vc {
    HomeInteractiveAnimator *animator = [[self alloc] init];
//    UIPanGestureRecognizer *panGR = [[UIPanGestureRecognizer alloc] initWithTarget:animator action:@selector(handlePanGesture:)];
//    [vc.view addGestureRecognizer:panGR];
    animator.targetVC = vc;
    return animator;
}

- (void)handlePanGesture:(UIPanGestureRecognizer *)panGesture {
    switch (panGesture.state) {
        case UIGestureRecognizerStateBegan:
            self.animationPercent   = 0;
            [self.targetVC dismissViewControllerAnimated:YES completion:nil];
            break;
        case UIGestureRecognizerStateChanged:
            self.animationPercent   += 0.02;
            [self updateInteractiveTransition:self.animationPercent];
            break;
        case UIGestureRecognizerStateEnded:
            if(self.animationPercent>0.5) {
                [self finishInteractiveTransition];
            }else {
                [self cancelInteractiveTransition];
            }
            break;
        default:
            break;
    }
}

@end
