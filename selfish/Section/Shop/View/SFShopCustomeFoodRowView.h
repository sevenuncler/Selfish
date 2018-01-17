//
//  SFShopCustomeFoodRowView.h
//  selfish
//
//  Created by He on 2017/12/2.
//  Copyright © 2017年 He. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SFShopCustomeFoodRowView : UIView
@property(nonatomic,strong) UILabel  *namelabel;
@property(nonatomic,strong) UITextField *contentView;
@property(nonatomic,strong) UIButton *rightButton;
@property(nonatomic,copy) void(^buttonHandler)(id sender);
@end
