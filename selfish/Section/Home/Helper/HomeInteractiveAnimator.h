//
//  HomeInteractiveAnimator.h
//  selfish
//
//  Created by He on 2017/11/25.
//  Copyright © 2017年 He. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface HomeInteractiveAnimator : UIPercentDrivenInteractiveTransition
+ (instancetype)interactiveAnimatorWithVC:(UIViewController *)vc;
@end
