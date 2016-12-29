//
//  FSRegisterViewController.m
//  BuyVegetablesTreasure
//
//  Created by DamonLiao on 2016/12/12.
//  Copyright © 2016年 c521xiong. All rights reserved.
//

#import "FSRegisterViewController.h"
#import "XFLimitedTextField.h"
#import "UserAgreementViewController.h"
#import "SucceedViewController.h"

@interface FSRegisterViewController ()

/// 背景图片
@property (weak, nonatomic) IBOutlet UIImageView *bgImageView;

/// 手机号输入
@property (weak, nonatomic) IBOutlet UIImageView *accountIconImageView;
@property (weak, nonatomic) IBOutlet XFLimitedTextField *phoneNumberInputTextField;
@property (weak, nonatomic) IBOutlet UIView *firstSeparatorLine;

/// 请求验证码
@property (weak, nonatomic) IBOutlet UIImageView *captchaImageView;
@property (weak, nonatomic) IBOutlet XFLimitedTextField *captchaInputTextField;
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
    self.captchaInputTextField.maxCount = 6;
    
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

- (IBAction)requestCaptchaButtonTouchUpInside:(UIButton *)sender {
    
    [self.view endEditing:YES];
    
    NSString *phoneNumberStr = self.phoneNumberInputTextField.text;
    if ([Tools isBlankString:phoneNumberStr]) {
        return [SVProgressHUD showInfoWithStatus:@"请输入您的手机号"];
    }
    if (![Tools isMobileNum:phoneNumberStr]) {
        return [SVProgressHUD showInfoWithStatus:@"请输入正确的手机号!"];
    }

    [self startCountDown];
    [self sendVerification:phoneNumberStr];
}

- (IBAction)agreementButtonTouchUpInside:(UIButton *)sender {
    [self.navigationController pushViewController:[NSClassFromString(@"UserAgreementViewController") new] animated:YES];
}

- (IBAction)registerButtonTouchUpInside:(UIButton *)sender {
    
    [self.view endEditing:YES];
    
    NSString *phoneNumberStr = self.phoneNumberInputTextField.text;
    NSString *captcha = self.captchaInputTextField.text;
    NSString *password = self.passwordInputTextField.text;
    NSString *confirmPassword = self.confirmTextField.text;
    
    if ([Tools isBlankString:phoneNumberStr]) {
        return [SVProgressHUD showInfoWithStatus:@"请输入您的手机号"];
    } else if ([Tools isBlankString:captcha]) {
        return [SVProgressHUD showInfoWithStatus:@"请输入验证码"];
    } else if ([Tools isBlankString:password]) {
        return [SVProgressHUD showInfoWithStatus:@"请输入密码"];
    } else if ([Tools isBlankString:confirmPassword]) {
        return [SVProgressHUD showInfoWithStatus:@"请再次输入密码"];
    } else if (![password isEqualToString:confirmPassword]) {
        return [SVProgressHUD showInfoWithStatus:@"两次密码不一致"];
    }


    NSString *urlString = [NSString stringWithFormat:REGISTER,phoneNumberStr, [password md5String], captcha];
    
    [XFNetworking GET:urlString parameters:nil success:^(id responseObject, NSInteger statusCode) {
        NSDictionary *data = [self dictWithData:responseObject];
        
        if ([data[@"issuccess"] boolValue]) {
            
            NSString *urlString = [NSString stringWithFormat:ZLLOGIN, phoneNumberStr, [password md5String], 1];
            
            [HttpRequest sendRequest:urlString param:nil requestStyle:Get setSerializer:Json success:^(id data)
             {
                 if ([data[@"issuccess"] boolValue]) {
                     
                     NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
                     NSArray *userDefaultsNumbers = @[@"amount",@"exp",@"point"];
                     NSArray *userDefaultsStrings = @[@"telphone",@"mobile",@"CouponNum",@"FolderNum",@"address",@"avatar",@"nick_name",@"user_name",@"sex"];
                     for (int i = 0; i < userDefaultsStrings.count; i++) {
                         
                         [userDefaults setObject:data[userDefaultsStrings[i]] forKey:userDefaultsStrings[i]];
                         
                         if (userDefaultsNumbers.count > i) {
                             [userDefaults setObject:[data[userDefaultsNumbers[i]] stringValue] forKey:userDefaultsNumbers[i]];
                         }
                     }
                     
                     if (data[@"birthday"]) [userDefaults setObject:data[@"birthday"] forKey:@"birthday"];
                     
                     [userDefaults setBool:YES forKey:@"isMobLogin"];
                     [userDefaults setObject:[NSString stringWithFormat:@"%@",data[@"id"]] forKey:@"UID"];
                     [userDefaults setObject:[NSString stringWithFormat:@"%@",data[@"agentId"]] forKey:@"ZID"];
                     
                     [[NSNotificationCenter defaultCenter] postNotificationName:@"userChangeTuisong" object:nil];
                     [[NSNotificationCenter defaultCenter] postNotificationName:@"UserChange" object:nil];
                     
                     [self.navigationController dismissViewControllerAnimated:YES completion:nil];
                     //[self.navigationController pushViewController:[SucceedViewController new] animated:YES];
                     
                     [self delStoreGoods];
                 }
                 
             } failure:^(NSError *error) {
                 [self showInfoWidthError:error];
             }];
        } else {
            [SVProgressHUD showInfoWithStatus:data[@"context"]];
        }
    } failure:^(NSError *error, NSInteger statusCode) {
        [self showInfoWidthError:error];
    }];
    
    

    
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


- (void)sendVerification:(NSString *)phoneString {
    
    NSString *urlString = [NSString stringWithFormat:GETCODER,phoneString,@"0"];
    NSLog(@"%@",urlString);
    
    [XFNetworking GET:urlString parameters:nil success:^(id responseObject, NSInteger statusCode) {
        NSDictionary *data = [self dictWithData:responseObject];
        if ([data[@"issuccess"] boolValue]) {
            [Single sharedInstance].coder = data[@"context"];
        }
        [SVProgressHUD showInfoWithStatus:data[@"context"]];
    } failure:^(NSError *error, NSInteger statusCode) {
        [self showInfoWidthError:error];
    }];
}

#pragma 删除购物车商品
- (void)delStoreGoods{
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *mid = [userDefaults objectForKey:@"MID"];
    NSString *uid = [userDefaults objectForKey:@"UID"];
    
    NSString *urlString = [NSString stringWithFormat:DelStoreCartUrl,UUID,mid,uid];
    [HttpRequest sendGetOrPostRequest:urlString param:nil requestStyle:Get setSerializer:Date isShowLoading:YES success:^(id data)
     {
         NSLog(@"删除成功");
         
     } failure:nil];
}


 
@end
