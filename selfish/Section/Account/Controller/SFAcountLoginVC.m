//
//  SFAcountLoginVC.m
//  selfish
//
//  Created by He on 2017/12/3.
//  Copyright © 2017年 He. All rights reserved.
//

#import "SFAcountLoginVC.h"
#import "SFAccountRegisterVC.h"

@interface SFAcountLoginVC ()

@end

@implementation SFAcountLoginVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.accountLabel];
    [self.view addSubview:self.accountTextField];
    
    [self.view addSubview:self.passwordLabel];
    [self.view addSubview:self.passwordTextField];
    
    [self.view addSubview:self.showPasswordButton];
    [self.view addSubview:self.forgetPasswordButton];
    [self.view addSubview:self.submitButton];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self setUpNavigator];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    CGFloat padding = 15;
    CGFloat labelWidth = 70;
    CGFloat textFieldWidth  = SCREEN_WIDTH - 3*padding - labelWidth;
    CGFloat textFieldHeigth = 44;
    
    self.accountTextField.frame   = CGRectMake(padding*2 + labelWidth,108,textFieldWidth, textFieldHeigth);
    [self.accountLabel sizeToFit];
    self.accountLabel.left        = padding;
    self.accountLabel.centerY = self.accountTextField.centerY;
    
    self.passwordTextField.frame = CGRectMake(self.accountTextField.left, self.accountTextField.botton + 5, textFieldWidth, textFieldHeigth);
    [self.passwordLabel sizeToFit];
    self.passwordLabel.centerY   = self.passwordTextField.centerY;
    self.passwordLabel.left      = padding;
    
    self.showPasswordButton.size    = CGSizeMake(15, 15);
    self.showPasswordButton.right   = self.passwordTextField.right - padding;
    self.showPasswordButton.centerY = self.passwordTextField.centerY;
    
    self.forgetPasswordButton.size  = CGSizeMake(100, 20);
    self.forgetPasswordButton.right = self.view.size.width - padding;
    self.forgetPasswordButton.top   = self.passwordTextField.botton + padding;
    
    self.submitButton.size  = CGSizeMake(self.view.size.width - 2*padding, 44);
    self.submitButton.left  = padding;
    self.submitButton.top   = self.forgetPasswordButton.botton;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setUpNavigator {
    self.title = @"登录";
    
    UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(handleBackAction:)];
    self.navigationItem.leftBarButtonItem = leftBarButtonItem;
    
    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"注册" style:UIBarButtonItemStylePlain target:self action:@selector(handleRegisterAction:)];
    self.navigationItem.rightBarButtonItem = rightBarButtonItem;
}

- (void)handleBackAction:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)handleRegisterAction:(id)sender {
    SFAccountRegisterVC *vc = [SFAccountRegisterVC new];
    [self.navigationController pushViewController:vc animated:YES];
}

- (UILabel *)accountLabel {
    if(!_accountLabel) {
        _accountLabel = [UILabel new];
        _accountLabel.text = @"账号";
        _accountLabel.textColor = [UIColor blackColor];
    }
    return _accountLabel;
}

- (UILabel *)passwordLabel {
    if(!_passwordLabel) {
        _passwordLabel = [UILabel new];
        _passwordLabel.text = @"密码";
        _passwordLabel.textColor = [UIColor blackColor];
    }
    return _passwordLabel;
}

- (UITextField *)accountTextField {
    if(!_accountTextField) {
        _accountTextField = [[UITextField alloc] init];
        _accountTextField.placeholder = @"手机号/邮箱/用户名";
    }
    return _accountTextField;
}

- (UITextField *)passwordTextField {
    if(!_passwordTextField) {
        _passwordTextField = [[UITextField alloc] init];
        _passwordTextField.placeholder = @"请输入密码";
        _passwordTextField.secureTextEntry = YES;
    }
    return _passwordTextField;
}

- (UIButton *)submitButton {
    if(!_submitButton) {
        _submitButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_submitButton setTitle:@"登录" forState:UIControlStateNormal];
        [_submitButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }
    return _submitButton;
}

- (UIButton *)forgetPasswordButton {
    if(!_forgetPasswordButton) {
        _forgetPasswordButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_forgetPasswordButton setTitle:@"忘记密码?" forState:UIControlStateNormal];
        [_forgetPasswordButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }
    return _forgetPasswordButton;
}

- (UIButton *)showPasswordButton {
    if(!_showPasswordButton) {
        _showPasswordButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_showPasswordButton setImage:[UIImage imageNamed:@"image"] forState:UIControlStateNormal];
    }
    return _showPasswordButton;
}

@end
