//
//  FSResetPasswordViewController.m
//  BuyVegetablesTreasure
//
//  Created by DamonLiao on 2016/12/12.
//  Copyright © 2016年 c521xiong. All rights reserved.
//

#import "FSResetPasswordViewController.h"
#import "XFLimitedTextField.h"

@interface FSResetPasswordViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *bgImageView;

// tips
@property (weak, nonatomic) IBOutlet UILabel *tipsLabel;

@property (weak, nonatomic) IBOutlet UILabel *phoneNumberLabel;


// 验证码
@property (weak, nonatomic) IBOutlet UIImageView *captchaIconImageView;
@property (weak, nonatomic) IBOutlet XFLimitedTextField *captchaTextField;
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
    
    self.captchaTextField.maxCount = 6;
    
    [self.phoneNumberLabel setText:[self.phoneString stringByReplacingCharactersInRange:NSMakeRange(3, 4) withString:@"****"]];
    
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
    [self.changeButton setBackgroundImage:[UIImage imageWithColor:[UIColor colorButtonDisabled]] forState:UIControlStateDisabled];
    self.changeButton.layer.cornerRadius = 5.0f;
    self.changeButton.layer.masksToBounds = YES;
    
    [self.captchaTextField becomeFirstResponder];
    
    [self startCountDown];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    CGFloat width = self.view.width;
    //CGFloat height = self.view.height;
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

#pragma mark - Custom

- (void)startCountDown {
    __block int timeout = 59; // 倒计时时间
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    dispatch_source_set_timer(_timer, dispatch_walltime(NULL, 0), 1.0*NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(_timer, ^{
        if (timeout <= 0) { // 倒计时结束，关闭
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                // 设置界面的按钮显示 根据自己需求设置
                [self.requestCaptchaButton setTitle:@"获取验证码" forState:UIControlStateNormal];
                self.requestCaptchaButton.enabled = YES;
            });
        } else {
            int seconds = timeout % 60;
            NSString *strTime = [NSString stringWithFormat:@"%.2d", seconds];
            dispatch_async(dispatch_get_main_queue(), ^{
                // 设置界面的按钮显示 根据自己需求设置
                [UIView animateWithDuration:1 animations:^{
                    [self.requestCaptchaButton setTitle:[NSString stringWithFormat:@"%@ s", strTime] forState:UIControlStateNormal];
                }];
                self.requestCaptchaButton.enabled = NO;
            });
            timeout--;
        }
    });
    dispatch_resume(_timer);
}
// dispatch_source_cancel(_timer)

- (IBAction)textFieldChanged:(UITextField *)sender {
    self.changeButton.enabled = self.captchaTextField.text.length >= 6 && self.passwordTextField.text.length;
}
- (IBAction)changePasswordButtonTouchUpInside:(UIButton *)sender {
    [self.view endEditing:YES];
    
    NSString *newPwdString = self.passwordTextField.text;
    NSString *codeString = self.captchaTextField.text;
    /*
    if ([Tools isBlankString:<#(NSString *)#>]) {
        return [SVProgressHUD showInfoWithStatus:@""];
    }
     */
    
    if ([Tools isBlankString:codeString]) {
        return [SVProgressHUD showInfoWithStatus:@"请输入验证码"];
    }
    if ([Tools isBlankString:newPwdString]) {
        return [SVProgressHUD showInfoWithStatus:@"请输入新密码"];
    }
    NSString *temp = [newPwdString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    if ([temp length] == 0) {
        return [SVProgressHUD showInfoWithStatus:@"密码不能为空格"];
    }
    if (newPwdString.length < 6) {
        return [SVProgressHUD showInfoWithStatus:@"密码不得小于6位数，请重新输入"];
    }
    if (newPwdString.length > 20) {
        return [SVProgressHUD showInfoWithStatus:@"密码不得大于20位数，请重新输入"];
    }
    NSArray  *array= [newPwdString componentsSeparatedByString:@" "];
    //中间有空格
    if (array.count > 1) {
        return [SVProgressHUD showInfoWithStatus:@"密码不能有空格符号"];
    }
    
    NSString *urlString = [NSString stringWithFormat:ResetUserPwdUrl,[newPwdString md5String],_phoneString,codeString];
    [SVProgressHUD show];
    [XFNetworking GET:urlString parameters:nil success:^(id responseObject, NSInteger statusCode) {
        NSDictionary *data = [self dictWithData:responseObject];
        
        if ([data[@"issuccess"] boolValue]) {
            
            [SVProgressHUD showSuccessWithStatus:@"修改密码成功"];
            [self.navigationController popToRootViewControllerAnimated:YES];
        } else {
            [SVProgressHUD showInfoWithStatus:data[@"context"]];
        }
    } failure:^(NSError *error, NSInteger statusCode) {
        [self showInfoWidthError:error];
    }];
}
@end
