//
//  SFShopCatagoryView.h
//  selfish
//
//  Created by He on 2017/11/27.
//  Copyright © 2017年 He. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SFShopCatagoryViewDelegate

@end

@interface SFShopCatagoryView : UIView
@property(nonatomic,strong) UITableView *menuTableView;
@property(nonatomic,strong) UITableView *contentTableView;
@property(nonatomic,weak)   id<SFShopCatagoryViewDelegate> delegate;

- (void)refresh;
@end
