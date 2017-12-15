//
//  RoutesConfig.m
//  selfish
//
//  Created by He on 2017/12/14.
//  Copyright © 2017年 He. All rights reserved.
//

#import "RoutesConfig.h"

@implementation RoutesConfig

+ (void)setUpRoutes:(NSString *)scheme {
    [[JLRoutes routesForScheme:scheme] addRoute:@"/push/:controller" handler:^BOOL(NSDictionary<NSString *,id> * _Nonnull parameters) {
        Class clz = NSClassFromString(parameters[@"controller"]);
        UIViewController *vc = [[clz alloc] init];
//        UINavigationController *navi = parameters[@"navi"];
//        if(navi) {
//            [navi pushViewController:vc animated:YES];
//        }else {
//            [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:vc animated:YES completion:nil];
//        }
        UIViewController *presentingVC = [self topViewController];
        if(presentingVC.navigationController) {
            presentingVC = presentingVC.navigationController;
        }
        
        if ([presentingVC isKindOfClass:[UINavigationController class]]) {
            UINavigationController *navi = (UINavigationController *)presentingVC;
            [navi pushViewController:vc animated:YES];
        } else {
            [presentingVC presentViewController:vc animated:YES completion:nil];
        }
        return YES;
    }];
}
    
+ (UIViewController *)currentViewController{
        UIViewController * currVC = nil;
        UIViewController * Rootvc = [UIApplication sharedApplication].keyWindow.rootViewController;
        do {
            if ([Rootvc isKindOfClass:[UINavigationController class]]) {
                UINavigationController * nav = (UINavigationController *)Rootvc;
                UIViewController * v = [nav.viewControllers lastObject];
                currVC = v;
                Rootvc = v.presentedViewController;
                continue;
            }else if([Rootvc isKindOfClass:[UITabBarController class]]){
                UITabBarController * tabVC = (UITabBarController *)Rootvc;
                currVC = tabVC;
                Rootvc = [tabVC.viewControllers objectAtIndex:tabVC.selectedIndex];
                continue;
            }
        } while (Rootvc!=nil);
        
        return currVC;
    }
    + (UIViewController *)topViewController {
        UIViewController *resultVC;
        resultVC = [self _topViewController:[[UIApplication sharedApplication].keyWindow rootViewController]];
        while (resultVC.presentedViewController) {
            resultVC = [self _topViewController:resultVC.presentedViewController];
        }
        return resultVC;
    }
    
+ (UIViewController *)_topViewController:(UIViewController *)vc {
    if ([vc isKindOfClass:[UINavigationController class]]) {
        return [self _topViewController:[(UINavigationController *)vc topViewController]];
    } else if ([vc isKindOfClass:[UITabBarController class]]) {
        return [self _topViewController:[(UITabBarController *)vc selectedViewController]];
    } else {
        return vc;
    }
    return nil;
}
@end
