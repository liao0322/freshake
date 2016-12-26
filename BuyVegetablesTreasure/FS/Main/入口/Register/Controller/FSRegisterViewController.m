//
//  FSRegisterViewController.m
//  BuyVegetablesTreasure
//
//  Created by DamonLiao on 2016/12/12.
//  Copyright © 2016年 c521xiong. All rights reserved.
//

#import "FSRegisterViewController.h"
#import "XFLimitedTextField.h"

@interface FSRegisterViewController ()

/// 背景图片
@property (weak, nonatomic) IBOutlet UIImageView *bgImageView;

/// 手机号输入
@property (weak, nonatomic) IBOutlet UIImageView *accountIconImageView;
@property (weak, nonatomic) IBOutlet XFLimitedTextField *phoneNumberInputTextField;
@property (weak, nonatomic) IBOutlet UIView *firstSeparatorLine;

/// 请求验证码
@property (weak, nonatomic) IBOutlet UIImageView *captchaImageView;
@property (weak, nonatomic) IBOutlet UITextField *captchaInputTextField;
@property (weak, nonatomic) IBOutlet UIButton *requestCaptchaButton;
@property (weak, nonatomic) IBOutlet UIView *secondSeparatorLine;


/// 密码输入
@property (weak, nonatomic) IBOutlet UIImageView *passwordIconImageView;
@property (weak, nonatomic) IBOutlet UITextField *passwordInputTextField;
@property (weak, nonatomic) IBOutlet UIView *thirdSeparatorLine;

/// 密码确认
@property (weak, nonatomic) IBOutlet UIImageView *confirmIconImageView;
@property (weak, nonatomic) IBOutlet UITextField *confirmTextField;
@property (weak, nonatomic) IBOutlet UIView *fourthlySeparatorLine;

/// 用户协议
@property (weak, nonatomic) IBOutlet UIButton *checkBoxButton;
@property (weak, nonatomic) IBOutlet UIButton *viewAgreementButton;

@property (weak, nonatomic) IBOutlet UIButton *registerButton;


@end

@implementation FSRegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    

}

- (void)initialization {
    [super initialization];
    self.title = @"注册";
    
    // 帐号
    self.phoneNumberInputTextField.maxCount = 11;
    
    self.phoneNumberInputTextField.borderStyle = UITextBorderStyleNone;
    self.phoneNumberInputTextField.tintColor = [UIColor colorDomina];
    
    self.firstSeparatorLine.backgroundColor = [UIColor colorSeparatorLine];
    
    // 验证码
    self.captchaInputTextField.borderStyle = UITextBorderStyleNone;
    self.captchaInputTextField.tintColor = [UIColor colorDomina];
    self.secondSeparatorLine.backgroundColor = [UIColor colorSeparatorLine];
    
    
    [self.requestCaptchaButton setBackgroundImage:[UIImage imageWithColor:[UIColor colorDomina]] forState:UIControlStateNormal];
    [self.requestCaptchaButton setBackgroundImage:[UIImage imageWithColor:[UIColor colorButtonHighlighted]] forState:UIControlStateHighlighted];
    self.requestCaptchaButton.layer.cornerRadius = 5.0f;
    self.requestCaptchaButton.layer.masksToBounds = YES;
    
    // 输入密码
    self.passwordInputTextField.borderStyle = UITextBorderStyleNone;
    self.passwordInputTextField.tintColor = [UIColor colorDomina];
    self.thirdSeparatorLine.backgroundColor = [UIColor colorSeparatorLine];
    
    // 确认
    self.confirmTextField.borderStyle = UITextBorderStyleNone;
    self.confirmTextField.tintColor = [UIColor colorDomina];
    self.fourthlySeparatorLine.backgroundColor = [UIColor colorSeparatorLine];
    
    // 协议
    self.checkBoxButton.titleEdgeInsets = UIEdgeInsetsMake(0, 8, 0, 0);
    
    
    
    
    // 注册按钮
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
    
    // 帐号
    self.accountIconImageView.x = spacing;
    self.accountIconImageView.y = marginTop;
    
    self.phoneNumberInputTextField.x = self.accountIconImageView.right + 15;
    self.phoneNumberInputTextField.centerY = self.accountIconImageView.centerY;
    self.phoneNumberInputTextField.width = viewWidth - self.accountIconImageView.width - 15;
    
    self.firstSeparatorLine.height = 0.5;
    self.firstSeparatorLine.width = viewWidth;
    self.firstSeparatorLine.x = spacing;
    self.firstSeparatorLine.y = self.accountIconImageView.bottom + 5;
    
    // 验证码
    self.captchaImageView.x = spacing;
    self.captchaImageView.y = self.firstSeparatorLine.bottom + 30;
    
    self.requestCaptchaButton.width = 100;
    self.requestCaptchaButton.height = 28;
    
    self.captchaInputTextField.x = self.phoneNumberInputTextField.x;
    self.captchaInputTextField.centerY = self.captchaImageView.centerY;
    self.captchaInputTextField.width = self.phoneNumberInputTextField.width - self.requestCaptchaButton.width - 15;
    
    self.requestCaptchaButton.x = self.captchaInputTextField.right + 15;
    self.requestCaptchaButton.centerY = self.captchaInputTextField.centerY;
    
    self.secondSeparatorLine.size = self.firstSeparatorLine.size;
    self.secondSeparatorLine.x = self.firstSeparatorLine.x;
    self.secondSeparatorLine.y = self.captchaImageView.bottom + 5;
    
    // 输入密码
    self.passwordIconImageView.x = spacing;
    self.passwordIconImageView.y = self.secondSeparatorLine.bottom + 30;

    self.passwordInputTextField.x = self.captchaInputTextField.x;
    self.passwordInputTextField.centerY = self.passwordIconImageView.centerY;
    self.passwordInputTextField.width = self.phoneNumberInputTextField.width;
    
    self.thirdSeparatorLine.size = self.firstSeparatorLine.size;
    self.thirdSeparatorLine.x = self.firstSeparatorLine.x;
    self.thirdSeparatorLine.y = self.passwordIconImageView.bottom + 5;
    
    // 确认
    self.confirmIconImageView.x = spacing;
    self.confirmIconImageView.y = self.thirdSeparatorLine.bottom + 30;
    
    self.confirmTextField.x = self.passwordInputTextField.x;
    self.confirmTextField.centerY = self.confirmIconImageView.centerY;
    self.confirmTextField.width = self.passwordInputTextField.width;
    
    self.fourthlySeparatorLine.size = self.firstSeparatorLine.size;
    self.fourthlySeparatorLine.x = self.firstSeparatorLine.x;
    self.fourthlySeparatorLine.y = self.confirmIconImageView.bottom + 5;


    // 协议
    [self.checkBoxButton sizeToFit];
    self.checkBoxButton.width = self.checkBoxButton.width + 8.0f;
    self.checkBoxButton.x = spacing;
    self.checkBoxButton.y = self.fourthlySeparatorLine.bottom + 15;
    
    [self.viewAgreementButton sizeToFit];
    self.viewAgreementButton.x = self.checkBoxButton.right;
    self.viewAgreementButton.centerY = self.checkBoxButton.centerY;
    
    // 注册按钮
    self.registerButton.x = spacing;
    self.registerButton.height = 44;
    self.registerButton.width = viewWidth;
    self.registerButton.y = self.checkBoxButton.bottom + 24;
    
    self.bgImageView.x = 0;
    self.bgImageView.y = 64;
    self.bgImageView.width = width;
    self.bgImageView.height = width / (375 / 398.0f);
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
