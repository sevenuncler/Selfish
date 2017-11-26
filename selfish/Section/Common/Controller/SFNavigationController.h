//
//  SFNavigationController.h
//  selfish
//
//  Created by He on 2017/11/26.
//  Copyright © 2017年 He. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SFNavigationController : UINavigationController
- (UIViewController *)getCurrentVC;
- (UIViewController *)getPresentedViewController;
@end
