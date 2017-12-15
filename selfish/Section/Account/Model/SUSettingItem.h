//
//  SUSettingItem.h
//  ReactiveCocoaProj
//
//  Created by He on 2017/11/7.
//  Copyright © 2017年 sevenuncle. All rights reserved.
//

#import "SUItem.h"
#import <UIKit/UIKit.h>

typedef void(^HandlerSetting)(void);

@interface SUSettingItem : SUItem
@property (nonatomic, copy) NSString *leftImage;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *subTitle;
@property (nonatomic, assign) UITableViewCellStyle style;
@property (nonatomic, copy) HandlerSetting hander;

@end
