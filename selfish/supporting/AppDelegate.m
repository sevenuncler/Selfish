//
//  AppDelegate.m
//  selfish
//
//  Created by He on 2017/11/22.
//  Copyright © 2017年 He. All rights reserved.
//

#import "AppDelegate.h"
#import "HomeVC.h"
#import "Macros.h"
#import "SFShopTableVC.h"
#import "SFShopDetailVC.h"
#import "SFTabBarController.h"
#import "SFNavigationController.h"
#import "SFShopCreateVC.h"
#import "SFShopCustomeVC.h"
#import "SFShopCustomeDecorationVC.h"
#import "SFShopCustomeFoodVC.h"
//#import <MagicalRecord/MagicalRecord.h>
#import <JLRoutes/JLRoutes.h>
#import "RoutesConfig.h"
#import <AMapFoundationKit/AMapFoundationKit.h>
#import <AMapLocationKit/AMapLocationKit.h>
#import "SFAddressVC.h"
#import "SFMapVC.h"
#import "SUImageBrowserVC.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [AMapServices sharedServices].apiKey =@"1406a9037028798d4f810fd69062d175";

    UIWindow *window = [[UIWindow alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    UIViewController *vc = [SFTabBarController new];
    window.rootViewController = vc;
    self.window = window;
    [self.window makeKeyAndVisible];
    [RoutesConfig setUpRoutes:@"Selfish"];
    window.tintColor = SELFISH_MAJRO_COLOR;
    return YES;
}
    
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    return [JLRoutes routeURL:url];
}
    
- (BOOL)application:(UIApplication*)application openURL:(NSURL*)url sourceApplication:(NSString*)sourceApplication annotation:(id)annotation {
    return[JLRoutes routeURL:url];
}
    
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString *,id> *)options{
        return [[JLRoutes routesForScheme:@"Selfish"]routeURL:url];
}



- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
//    [MagicalRecord cleanUp];
}


@end
