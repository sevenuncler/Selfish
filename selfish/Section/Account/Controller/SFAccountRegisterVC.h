//
//  SFAccountRegister.h
//  selfish
//
//  Created by He on 2017/12/3.
//  Copyright © 2017年 He. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SFAccountRegisterVC : UIViewController
@property(nonatomic, strong) UISegmentedControl *stepIndicatorSegment;
@property(nonatomic, strong) UITextField *phoneTextField;
@property(nonatomic, strong) UIButton    *nextButton;
@property(nonatomic, strong) UIButton    *checkButton;
@property(nonatomic, strong) UILabel     *aggrementLabel;
@end
