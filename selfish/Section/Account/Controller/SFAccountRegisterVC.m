//
//  SFAccountRegister.m
//  selfish
//
//  Created by He on 2017/12/3.
//  Copyright © 2017年 He. All rights reserved.
//

#import "SFAccountRegisterVC.h"

@interface SFAccountRegisterVC ()

@end

@implementation SFAccountRegisterVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"注册";
    
    [self.view addSubview:self.stepIndicatorSegment];
    [self.view addSubview: self.phoneTextField];
    [self.view addSubview:self.nextButton];
    [self.view addSubview:self.checkButton];
    [self.view addSubview:self.aggrementLabel];
}

- (void)setUpNavigator {
    self.navigationItem.rightBarButtonItem = nil;
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    CGFloat padding = 20;
    self.stepIndicatorSegment.left = 0;
    self.stepIndicatorSegment.top  = 108;
    
    self.phoneTextField.size = CGSizeMake(SCREEN_WIDTH, 44);
    self.phoneTextField.left = 0;
    self.phoneTextField.top  = self.stepIndicatorSegment.botton + padding;
    
    self.nextButton.size = CGSizeMake(SCREEN_WIDTH - padding, 44);
    self.nextButton.left = padding/2;
    self.nextButton.top  = self.phoneTextField.botton + padding;
    
    self.checkButton.left = self.nextButton.left;
    self.checkButton.top  = self.nextButton.botton;
    
    [self.aggrementLabel sizeToFit];
    self.aggrementLabel.left = self.checkButton.right + padding/2;
    self.aggrementLabel.centerY = self.checkButton.centerY;
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIButton *)nextButton {
    if(!_nextButton) {
        _nextButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_nextButton setTitle:@"获取验证码" forState:UIControlStateNormal];
        [_nextButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _nextButton.backgroundColor = [UIColor orangeColor];
    }
    return _nextButton;
}

- (UIButton *)checkButton {
    if(!_checkButton) {
        _checkButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_checkButton setImage:[UIImage imageNamed:@"image"] forState:UIControlStateNormal];
        _checkButton.size = CGSizeMake(15, 15);
    }
    return _checkButton;
}

- (UILabel *)aggrementLabel {
    if(!_aggrementLabel) {
        _aggrementLabel = [UILabel new];
        _aggrementLabel.text = @"我已阅读并同意《一人食用户协议》";
        _aggrementLabel.font = [UIFont systemFontOfSize:12];
        _aggrementLabel.textColor  = [UIColor blackColor];
    }
    return _aggrementLabel;
}

- (UISegmentedControl *)stepIndicatorSegment {
    if(!_stepIndicatorSegment) {
        _stepIndicatorSegment = [[UISegmentedControl alloc] initWithItems:@[@"1.输入手机号", @"> 2.输入验证码", @"> 3.设置密码   >"]];
        _stepIndicatorSegment.size = CGSizeMake(SCREEN_WIDTH, 44);
        _stepIndicatorSegment.userInteractionEnabled = NO;
        _stepIndicatorSegment.selectedSegmentIndex = 1;
    }
    return _stepIndicatorSegment;
}

- (UITextField *)phoneTextField {
    if(!_phoneTextField) {
        _phoneTextField = [[UITextField alloc] init];
        _phoneTextField.placeholder = @"手机号码";
    }
    return _phoneTextField;
}

@end
