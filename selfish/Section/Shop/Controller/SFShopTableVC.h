//
//  SFShopTableVC.h
//  selfish
//
//  Created by He on 2017/11/25.
//  Copyright © 2017年 He. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SFShopTableVC : UIViewController <UIGestureRecognizerDelegate>
@property(nonatomic,strong) UITableView    *tableView;
@property(nonatomic,strong) NSMutableArray *items;
@end
