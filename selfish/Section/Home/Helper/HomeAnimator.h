//
//  HomeAnimator.h
//  selfish
//
//  Created by He on 2017/11/24.
//  Copyright © 2017年 He. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, HomeAnimatorType) {
        HomeAnimatorTypeDefault,
        HomeAnimatorTypeMagicMove,
        HomeAnimatorTypeSpread
};

@interface HomeAnimator : NSObject <UIViewControllerAnimatedTransitioning>
@property(nonatomic,assign) HomeAnimatorType homeAnimatorType;
@end
