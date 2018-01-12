//
//  SFMapVC.h
//  selfish
//
//  Created by He on 2018/1/10.
//  Copyright © 2018年 He. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AMapFoundationKit/AMapFoundationKit.h>
#import <MAMapKit/MAMapKit.h>
#import <AMapLocationKit/AMapLocationKit.h>
#import <AMapSearchKit/AMapSearchKit.h>
#import "SFLocationItem.h"

@interface SFMapVC : UIViewController
@property(nonatomic,copy)void(^locationHandler)(SFLocationItem *item);
@end
