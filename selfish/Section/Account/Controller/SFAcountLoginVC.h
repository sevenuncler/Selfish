//
//  SFAcountLoginVC.h
//  selfish
//
//  Created by He on 2017/12/3.
//  Copyright © 2017年 He. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SFAcountLoginVC : UIViewController
@property(nonatomic, strong) UILabel     *accountLabel;
@property(nonatomic, strong) UILabel     *passwordLabel;
@property(nonatomic, strong) UITextField *accountTextField;
@property(nonatomic, strong) UITextField *passwordTextField;
@property(nonatomic, strong) UIButton    *submitButton;
@property(nonatomic, strong) UIButton    *forgetPasswordButton;
@property(nonatomic, strong) UIButton    *showPasswordButton;
@end
