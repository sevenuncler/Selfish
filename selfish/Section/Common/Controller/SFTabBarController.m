//
//  SFTabBarController.m
//  selfish
//
//  Created by He on 2017/11/26.
//  Copyright © 2017年 He. All rights reserved.
//

#import "SFTabBarController.h"
#import "SFShopTableVC.h"
#import "HomeVC.h"
#import "UIImage+Size.h"
#import "AccountVC.h"
#import "SFNavigationController.h"

@interface SFTabBarController ()

@end

@implementation SFTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor grayColor];
    [self setUpChildVCs];
    // Do any additional setup after loading the view.
}

- (void)setUpChildVCs {
    NSMutableArray *VCs = [NSMutableArray array];
    {
        UIViewController *vc = [HomeVC new];
        UITabBarItem *barButtonItem = [[UITabBarItem alloc] init];
        barButtonItem.image = [[UIImage imageNamed:@"image"] imageWithSize:CGSizeMake(25, 25)];
        barButtonItem.selectedImage = [[UIImage imageNamed:@"image"] imageWithSize:CGSizeMake(25, 25)];
        barButtonItem.title = @"首页";
        vc.tabBarItem = barButtonItem;
        UINavigationController *naviVC = [[SFNavigationController alloc] initWithRootViewController:vc];
        [VCs addObject:naviVC];
    }
    {
        UIViewController *vc = [SFShopTableVC new];
        UITabBarItem *barButtonItem = [[UITabBarItem alloc] init];
        barButtonItem.image = [[UIImage imageNamed:@"image"] imageWithSize:CGSizeMake(25, 25)];
        barButtonItem.selectedImage = [[UIImage imageNamed:@"image"] imageWithSize:CGSizeMake(25, 25)];
        barButtonItem.title = @"商铺";
        vc.tabBarItem = barButtonItem;
        UINavigationController *naviVC = [[UINavigationController alloc] initWithRootViewController:vc];
        [VCs addObject:naviVC];
    }
    {
        UIViewController *vc = [AccountVC new];
        UITabBarItem *barButtonItem = [[UITabBarItem alloc] init];
        barButtonItem.image = [[UIImage imageNamed:@"image"] imageWithSize:CGSizeMake(25, 25)];
        barButtonItem.selectedImage = [[UIImage imageNamed:@"image"] imageWithSize:CGSizeMake(25, 25)];
        barButtonItem.title = @"个人";
        vc.tabBarItem = barButtonItem;
        UINavigationController *naviVC = [[UINavigationController alloc] initWithRootViewController:vc];
        [VCs addObject:naviVC];
    }
    self.viewControllers = VCs.copy;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
