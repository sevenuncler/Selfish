//
//  SFAccountRegister.m
//  selfish
//
//  Created by He on 2017/12/3.
//  Copyright © 2017年 He. All rights reserved.
//

#import "SFAccountRegisterVC.h"
#import <MBProgressHUD/MBProgressHUD.h>
#import <SVProgressHUD/SVProgressHUD.h>

@interface SFAccountRegisterVC ()
@property(nonatomic, strong) NSString *accountName;
@property(nonatomic, strong) NSString *validateCode;
@property(nonatomic, strong) NSString *accountPassword;
    @property(nonatomic, strong) MBProgressHUD *hud;
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

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Private
    
- (void)onNextAction:(UIButton *)sender {
    if(self.stepIndicatorSegment.selectedSegmentIndex == 0) {
        self.accountName = self.phoneTextField.text;
        self.stepIndicatorSegment.selectedSegmentIndex ++;
        [self.nextButton setTitle:@"输入验证码" forState:UIControlStateNormal];
    }else if (self.stepIndicatorSegment.selectedSegmentIndex == 1) {
        self.stepIndicatorSegment.selectedSegmentIndex ++;
        [self.nextButton setTitle:@"输入密码" forState:UIControlStateNormal];
    }else if (self.stepIndicatorSegment.selectedSegmentIndex == 2) {
        self.accountPassword = self.phoneTextField.text;
        [self onRegisterAction:nil];
        [self.nextButton setTitle:@"输入账号" forState:UIControlStateNormal];
        self.stepIndicatorSegment.selectedSegmentIndex = 0;
    }
}

- (void)onRegisterAction:(id)sender {
        NSString *path = [NSString stringWithFormat:@"%@http://localhost:8080/account", @""];
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:path]];
        [request setValue:@"application/json;charset=utf-8" forHTTPHeaderField:@"content-type"];
        request.HTTPMethod = @"POST";
        
        NSDictionary *json = @{
                               @"username": self.accountName,
                               @"password": self.accountPassword,
                               @"phone"   : self.accountName
                               };
        NSError *jsonError = nil;
        NSData *bodyData = [NSJSONSerialization dataWithJSONObject:json options:NSJSONWritingPrettyPrinted error:&jsonError];
        request.HTTPBody = bodyData;
        
        NSURLSession *session = [NSURLSession sharedSession];
        
        NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            if (error != nil) {
                [SVProgressHUD showWithStatus:@"注册失败"];
                NSLog(@"请求错误%@", error);
                [SVProgressHUD dismissWithDelay:2];
                return;
            }
            NSError *readError = nil;
            NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&readError];
            NSString  *success = (NSString *)json[@"success"];
            if([success isEqualToString:@"false"]) {
                [SVProgressHUD showWithStatus:@"注册失败"];
                [SVProgressHUD dismissWithDelay:2];
                return;
            }else {
                [SVProgressHUD showWithStatus:@"注册成功，返回登录"];
                NSLog(@"注册结果：\n%@", json);
                [SVProgressHUD dismiss];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.navigationController popViewControllerAnimated:YES];
                });
                return;
            }
        }];
    [SVProgressHUD showWithStatus:@"注册中"];
        [dataTask resume];
    
    }

- (void)resetToFirstStep {
    
}
    
#pragma mark - Getter & Setter

- (UIButton *)nextButton {
    if(!_nextButton) {
        _nextButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_nextButton setTitle:@"输入账号名称" forState:UIControlStateNormal];
        [_nextButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _nextButton.backgroundColor = SELFISH_MAJRO_COLOR;
        [_nextButton addTarget:self action:@selector(onNextAction:) forControlEvents:UIControlEventTouchUpInside];
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
        _stepIndicatorSegment.selectedSegmentIndex = 0;
        _stepIndicatorSegment.tintColor = SELFISH_MAJRO_COLOR;
        [UIColor colorWithRed:1 green:1 blue:1 alpha:1];
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
    
    - (MBProgressHUD *)hud {
        if(!_hud) {
            _hud = [[MBProgressHUD alloc] initWithFrame:CGRectMake(100, 100, 100, 100)];
            _hud.mode = MBProgressHUDModeText;
            [self.view addSubview:_hud];
        }
        return _hud;
    }

@end
