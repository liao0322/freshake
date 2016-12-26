//
//  FSLoginViewController.m
//  BuyVegetablesTreasure
//
//  Created by DamonLiao on 2016/12/12.
//  Copyright © 2016年 c521xiong. All rights reserved.
//

#import "FSLoginViewController.h"
#import "FSRegisterViewController.h"
#import "FSForgetViewController.h"
#import "FSPhoneLoginViewController.h"
#import "XFLimitedTextField.h"

@interface FSLoginViewController ()
@property (weak, nonatomic) IBOutlet XFLimitedTextField *phoneNumberInputTextField;

@property (weak, nonatomic) IBOutlet UITextField *passwordInputTextField;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (weak, nonatomic) IBOutlet UIButton *registerButton;
@property (weak, nonatomic) IBOutlet UIButton *forgetPasswordButton;
@property (weak, nonatomic) IBOutlet UIButton *phoneLoginButton;

@property (weak, nonatomic) IBOutlet UIImageView *bgImageView;

@property (weak, nonatomic) IBOutlet UIView *firstSeparatorLine;

@property (weak, nonatomic) IBOutlet UIView *secondSeparatorLine;

@property (weak, nonatomic) IBOutlet UIImageView *accountIconImageView;
@property (weak, nonatomic) IBOutlet UIImageView *passwordIconImageView;

@end

@implementation FSLoginViewController

#pragma mark - LifeCycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)initialization {
    [super initialization];
    
    self.title = @"帐号密码登录";
    
    self.phoneNumberInputTextField.maxCount = 11;
    
    
    self.phoneNumberInputTextField.borderStyle = UITextBorderStyleNone;
    self.phoneNumberInputTextField.tintColor = [UIColor colorDomina];
    
    
    self.firstSeparatorLine.backgroundColor = [UIColor colorSeparatorLine];
    
    self.passwordInputTextField.borderStyle = UITextBorderStyleNone;
    self.passwordInputTextField.tintColor = [UIColor colorDomina];
    
    self.secondSeparatorLine.backgroundColor = [UIColor colorSeparatorLine];
    
    // login button
    [self.loginButton setBackgroundImage:[UIImage imageWithColor:[UIColor colorDomina]] forState:UIControlStateNormal];
    [self.loginButton setBackgroundImage:[UIImage imageWithColor:[UIColor colorButtonHighlighted]] forState:UIControlStateHighlighted];
    [self.loginButton setBackgroundImage:[UIImage imageWithColor:[UIColor colorButtonDisabled]] forState:UIControlStateDisabled];
    self.loginButton.layer.cornerRadius = 5.0f;
    self.loginButton.layer.masksToBounds = YES;
    
    [self.registerButton setBackgroundImage:[UIImage imageWithColor:[UIColor colorDomina]] forState:UIControlStateNormal];
    [self.registerButton setBackgroundImage:[UIImage imageWithColor:[UIColor colorButtonHighlighted]] forState:UIControlStateHighlighted];
    self.registerButton.layer.cornerRadius = 5.0f;
    self.registerButton.layer.masksToBounds = YES;
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    CGFloat width = self.view.width;
    CGFloat height = self.view.height;
    CGFloat spacing = 30.0f;
    CGFloat viewWidth = width - spacing * 2;
    
    CGFloat marginTop = height * 0.2;
    
    self.accountIconImageView.x = spacing;
    self.accountIconImageView.y = marginTop;
    
    self.phoneNumberInputTextField.x = self.accountIconImageView.right + 15;
    self.phoneNumberInputTextField.centerY = self.accountIconImageView.centerY;
    self.phoneNumberInputTextField.width = viewWidth - self.accountIconImageView.width - 15;
    
    self.firstSeparatorLine.height = 0.5;
    self.firstSeparatorLine.width = viewWidth;
    self.firstSeparatorLine.x = spacing;
    self.firstSeparatorLine.y = self.accountIconImageView.bottom + 5;
    
    
    self.passwordIconImageView.x = spacing;
    self.passwordIconImageView.y = self.firstSeparatorLine.bottom + 30;
    
    self.passwordInputTextField.x = self.phoneNumberInputTextField.x;
    self.passwordInputTextField.centerY = self.passwordIconImageView.centerY;
    self.passwordInputTextField.width = self.phoneNumberInputTextField.width;
    
    self.secondSeparatorLine.size = self.firstSeparatorLine.size;
    self.secondSeparatorLine.x = self.firstSeparatorLine.x;
    self.secondSeparatorLine.y = self.passwordIconImageView.bottom + 5;
    
    
    self.loginButton.x = spacing;
    self.loginButton.height = 44;
    self.loginButton.width = viewWidth;
    self.loginButton.y = self.secondSeparatorLine.bottom + height * 0.1;
    
    self.registerButton.x = self.loginButton.x;
    self.registerButton.height = self.loginButton.height;
    self.registerButton.width = self.loginButton.width;
    self.registerButton.y = self.loginButton.bottom + 15;
    
    self.phoneLoginButton.x = spacing;
    self.phoneLoginButton.y = self.registerButton.bottom + 15;
    
    self.forgetPasswordButton.y = self.phoneLoginButton.y;
    self.forgetPasswordButton.right = self.registerButton.right;
    
    self.bgImageView.x = 0;
    self.bgImageView.y = 64;
    self.bgImageView.width = width;
    self.bgImageView.height = width / (375 / 398.0f);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Override

- (void)setupNavigationBar {
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(dismiss)];
}

#pragma mark - Custom

// 登录按钮事件
- (IBAction)loginButtonTouchUpInside:(UIButton *)sender {
    
    // 获取用户输入帐号和密码
    NSString *phoneNumberStr = [self.phoneNumberInputTextField.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *passwordStr = [self.passwordInputTextField.text md5String];
    
    // 登录
    [self loginWithPhoneNumber:phoneNumberStr password:passwordStr];
    
    
}

// 注册按钮事件
- (IBAction)registerButtonTouchUpInside:(UIButton *)sender {
    FSRegisterViewController *registerVC = [[FSRegisterViewController alloc] init];
    [self.navigationController pushViewController:registerVC animated:YES];
}

// 忘记密码按钮事件
- (IBAction)forgetPasswordButtonTouchUpInside:(UIButton *)sender {
    FSForgetViewController *forgetVC = [[FSForgetViewController alloc] init];
    [self.navigationController pushViewController:forgetVC animated:YES];
}

// 快速登录按钮事件
- (IBAction)phoneLoginButtonTouchUpInside:(UIButton *)sender {
    FSPhoneLoginViewController *phoneLoginVC = [[FSPhoneLoginViewController alloc] init];
    [self.navigationController pushViewController:phoneLoginVC animated:YES];
}

- (IBAction)textFieldChanged:(UITextField *)sender {
    self.loginButton.enabled = self.phoneNumberInputTextField.text.length >= 11 && self.passwordInputTextField.text.length;
}

- (void)dismiss {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark 登录

- (void)loginWithPhoneNumber:(NSString *)phoneNumber password:(NSString *)password {
    [self.view endEditing:YES];
    
    // 显示指示器
    [SVProgressHUD showWithStatus:@"正在登录..."];
    
    NSString *urlString = [NSString stringWithFormat:ZLLOGIN, phoneNumber, password, 1];
    NSLog(@"%@", urlString);

    [XFNetworking GET:urlString parameters:nil success:^(id responseObject, NSInteger statusCode) {
        [SVProgressHUD dismiss];
        NSDictionary *dataDict = [self dictWithData:responseObject];
        
        // 登录失败
        if (![dataDict[@"issuccess"] boolValue]) {
            [SVProgressHUD showInfoWithStatus:dataDict[@"context"]];
            return;
        }
        [SVProgressHUD showSuccessWithStatus:@"登录成功"];
        // 登录成功
        // 持久化相关信息
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        NSArray *userDefaultsNumbers = @[@"amount",
                                         @"exp",
                                         @"point",
                                         @"group_id"];
        NSArray *userDefaultsStrings = @[@"telphone",
                                        @"mobile",
                                         @"CouponNum",
                                         @"FolderNum",
                                         @"address",
                                         @"avatar",
                                         @"nick_name",
                                         @"user_name",
                                         @"sex"];
        for (int i = 0; i < userDefaultsStrings.count; i++) {
            [userDefaults setObject:dataDict[userDefaultsStrings[i]] forKey:userDefaultsStrings[i]];
            if (userDefaultsNumbers.count > i) {
                [userDefaults setObject:[dataDict[userDefaultsNumbers[i]] stringValue] forKey:userDefaultsNumbers[i]];
            }
        }
        if (dataDict[@"birthday"]) {
            [userDefaults setObject:dataDict[@"birthday"] forKey:@"birthday"];
        }
        [userDefaults setBool:YES forKey:@"isMobLogin"];
        [userDefaults setObject:[NSString stringWithFormat:@"%@",dataDict[@"id"]] forKey:@"UID"];
        [userDefaults setObject:[NSString stringWithFormat:@"%@",dataDict[@"agentId"]] forKey:@"ZID"];
        
                     [[NSNotificationCenter defaultCenter] postNotificationName:@"UserChange" object:nil];
        // 发出通知
        [[NSNotificationCenter defaultCenter] postNotificationName:@"UserIsLogined" object:nil];
        
        [self dismissViewControllerAnimated:YES completion:nil];
    } failure:^(NSError *error, NSInteger statusCode) { // 登录失败
        [self showInfoWidthError:error];
    }];
}



@end
