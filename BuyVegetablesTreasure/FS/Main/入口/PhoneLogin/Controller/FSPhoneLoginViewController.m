//
//  FSPhoneLoginViewController.m
//  BuyVegetablesTreasure
//
//  Created by DamonLiao on 2016/12/12.
//  Copyright © 2016年 c521xiong. All rights reserved.
//

#import "FSPhoneLoginViewController.h"
#import "XFLimitedTextField.h"

@interface FSPhoneLoginViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *bgImageView;

// 手机号
@property (weak, nonatomic) IBOutlet UIImageView *accountIconImageView;
@property (weak, nonatomic) IBOutlet XFLimitedTextField *accountTextField;
@property (weak, nonatomic) IBOutlet UIView *firstSeparatorLine;

// 验证码
@property (weak, nonatomic) IBOutlet UIImageView *captchaIconImageView;
@property (weak, nonatomic) IBOutlet UITextField *captchaTextField;
@property (weak, nonatomic) IBOutlet UIButton *requestCaptchaButton;
@property (weak, nonatomic) IBOutlet UIView *secondSeparatorLine;

@property (weak, nonatomic) IBOutlet UIButton *loginButton;


@end

@implementation FSPhoneLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)initialization {
    [super initialization];
    self.title = @"手机号登录";
    
    // 帐号
    self.accountTextField.maxCount = 11;
    
    self.accountTextField.borderStyle = UITextBorderStyleNone;
    self.accountTextField.tintColor = [UIColor colorDomina];
    
    self.firstSeparatorLine.backgroundColor = [UIColor colorSeparatorLine];
    
    // 验证码
    self.captchaTextField.borderStyle = UITextBorderStyleNone;
    self.captchaTextField.tintColor = [UIColor colorDomina];
    self.secondSeparatorLine.backgroundColor = [UIColor colorSeparatorLine];
    
    
    [self.requestCaptchaButton setBackgroundImage:[UIImage imageWithColor:[UIColor colorDomina]] forState:UIControlStateNormal];
    [self.requestCaptchaButton setBackgroundImage:[UIImage imageWithColor:[UIColor colorButtonHighlighted]] forState:UIControlStateHighlighted];
    self.requestCaptchaButton.layer.cornerRadius = 5.0f;
    self.requestCaptchaButton.layer.masksToBounds = YES;
    

    // 登录按钮
    [self.loginButton setBackgroundImage:[UIImage imageWithColor:[UIColor colorDomina]] forState:UIControlStateNormal];
    [self.loginButton setBackgroundImage:[UIImage imageWithColor:[UIColor colorButtonHighlighted]] forState:UIControlStateHighlighted];
    self.loginButton.layer.cornerRadius = 5.0f;
    self.loginButton.layer.masksToBounds = YES;
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
    
    self.accountTextField.x = self.accountIconImageView.right + 15;
    self.accountTextField.centerY = self.accountIconImageView.centerY;
    self.accountTextField.width = viewWidth - self.accountIconImageView.width - 15;
    
    self.firstSeparatorLine.height = 0.5;
    self.firstSeparatorLine.width = viewWidth;
    self.firstSeparatorLine.x = spacing;
    self.firstSeparatorLine.y = self.accountIconImageView.bottom + 5;
    
    // 验证码
    self.captchaIconImageView.x = spacing;
    self.captchaIconImageView.y = self.firstSeparatorLine.bottom + 30;
    
    self.requestCaptchaButton.width = 100;
    self.requestCaptchaButton.height = 28;
    
    self.captchaTextField.x = self.accountTextField.x;
    self.captchaTextField.centerY = self.captchaIconImageView.centerY;
    self.captchaTextField.width = self.accountTextField.width - self.requestCaptchaButton.width - 15;
    
    self.requestCaptchaButton.x = self.captchaTextField.right + 15;
    self.requestCaptchaButton.centerY = self.captchaTextField.centerY;
    
    self.secondSeparatorLine.size = self.firstSeparatorLine.size;
    self.secondSeparatorLine.x = self.firstSeparatorLine.x;
    self.secondSeparatorLine.y = self.captchaIconImageView.bottom + 5;
    
    
    // 登录按钮
    self.loginButton.x = spacing;
    self.loginButton.height = 44;
    self.loginButton.width = viewWidth;
    self.loginButton.y = self.secondSeparatorLine.bottom + height * 0.1;
    
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
