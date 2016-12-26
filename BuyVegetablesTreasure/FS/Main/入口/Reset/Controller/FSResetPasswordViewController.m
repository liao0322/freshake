//
//  FSResetPasswordViewController.m
//  BuyVegetablesTreasure
//
//  Created by DamonLiao on 2016/12/12.
//  Copyright © 2016年 c521xiong. All rights reserved.
//

#import "FSResetPasswordViewController.h"

@interface FSResetPasswordViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *bgImageView;

// tips
@property (weak, nonatomic) IBOutlet UILabel *tipsLabel;

@property (weak, nonatomic) IBOutlet UILabel *phoneNumberLabel;


// 验证码
@property (weak, nonatomic) IBOutlet UIImageView *captchaIconImageView;
@property (weak, nonatomic) IBOutlet UITextField *captchaTextField;
@property (weak, nonatomic) IBOutlet UIButton *requestCaptchaButton;
@property (weak, nonatomic) IBOutlet UIView *firstSeparatorLine;


// 输入新密码
@property (weak, nonatomic) IBOutlet UIImageView *passwordIconImageView;

@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UIView *secondSeparatorLine;

@property (weak, nonatomic) IBOutlet UIButton *changeButton;

@end

@implementation FSResetPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)initialization {
    [super initialization];
    self.title = @"重置密码";
    
    // 验证码
    self.captchaTextField.borderStyle = UITextBorderStyleNone;
    self.captchaTextField.tintColor = [UIColor colorDomina];
    
    self.firstSeparatorLine.backgroundColor = [UIColor colorSeparatorLine];
    
    [self.requestCaptchaButton setBackgroundImage:[UIImage imageWithColor:[UIColor colorDomina]] forState:UIControlStateNormal];
    [self.requestCaptchaButton setBackgroundImage:[UIImage imageWithColor:[UIColor colorButtonHighlighted]] forState:UIControlStateHighlighted];
    self.requestCaptchaButton.layer.cornerRadius = 5.0f;
    self.requestCaptchaButton.layer.masksToBounds = YES;
    
    // 输入密码
    self.passwordTextField.borderStyle = UITextBorderStyleNone;
    self.passwordTextField.tintColor = [UIColor colorDomina];
    self.secondSeparatorLine.backgroundColor = [UIColor colorSeparatorLine];
    
    
    // 重置密码按钮
    [self.changeButton setBackgroundImage:[UIImage imageWithColor:[UIColor colorDomina]] forState:UIControlStateNormal];
    [self.changeButton setBackgroundImage:[UIImage imageWithColor:[UIColor colorButtonHighlighted]] forState:UIControlStateHighlighted];
    self.changeButton.layer.cornerRadius = 5.0f;
    self.changeButton.layer.masksToBounds = YES;
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    CGFloat width = self.view.width;
    CGFloat height = self.view.height;
    CGFloat spacing = 30.0f;
    CGFloat viewWidth = width - spacing * 2;
    
    CGFloat marginTop = 64 + 30;
    
    // tips label
    [self.tipsLabel sizeToFit];
    self.tipsLabel.centerX = width * 0.5;
    self.tipsLabel.y = marginTop;
    
    [self.phoneNumberLabel sizeToFit];
    self.phoneNumberLabel.centerX = self.tipsLabel.centerX;
    self.phoneNumberLabel.y = self.tipsLabel.bottom + 15;
    
    // 验证码
    self.captchaIconImageView.x = spacing;
    self.captchaIconImageView.y = self.phoneNumberLabel.bottom + 30;
    
    self.requestCaptchaButton.width = 100;
    self.requestCaptchaButton.height = 28;
    
    self.captchaTextField.x = self.captchaIconImageView.right + 15;
    self.captchaTextField.centerY = self.captchaIconImageView.centerY;

    self.requestCaptchaButton.centerY = self.captchaTextField.centerY;
    
    self.firstSeparatorLine.height = 0.5;
    self.firstSeparatorLine.width = viewWidth;
    self.firstSeparatorLine.x = spacing;
    self.firstSeparatorLine.y = self.captchaIconImageView.bottom + 5;
    
    // 输入密码
    self.passwordIconImageView.x = spacing;
    self.passwordIconImageView.y = self.firstSeparatorLine.bottom + 30;
    
    self.passwordTextField.x = self.captchaTextField.x;
    self.passwordTextField.centerY = self.passwordIconImageView.centerY;
    self.passwordTextField.width = viewWidth - self.passwordIconImageView.width - 15;
    
    self.captchaTextField.width = self.passwordTextField.width - self.requestCaptchaButton.width - 15;
    self.requestCaptchaButton.x = self.captchaTextField.right + 15;

    self.secondSeparatorLine.size = self.firstSeparatorLine.size;
    self.secondSeparatorLine.x = self.firstSeparatorLine.x;
    self.secondSeparatorLine.y = self.passwordIconImageView.bottom + 5;
    
    // 重置密码按钮
    self.changeButton.x = spacing;
    self.changeButton.height = 44;
    self.changeButton.width = viewWidth;
    self.changeButton.y = self.secondSeparatorLine.bottom + 24;
    
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
