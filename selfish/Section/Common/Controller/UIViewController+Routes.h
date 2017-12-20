//
//  UIViewController+Routes.h
//  selfish
//
//  Created by fanghe on 17/12/20.
//  Copyright © 2017年 He. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^VCFinishHandler)(id data);

@interface UIViewController (Routes)

@property(nonatomic, copy) VCFinishHandler handler;

@end
