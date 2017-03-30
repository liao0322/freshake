//
//  FSPhoneLoginViewController.m
//  BuyVegetablesTreasure
//
//  Created by DamonLiao on 2016/12/12.
//  Copyright © 2016年 c521xiong. All rights reserved.
//

#import "FSPhoneLoginViewController.h"
#import "XFLimitedTextField.h"
#import "AppDelegate.h"

#define CAPTCHA_INTERVAL_TIME 59

@interface FSPhoneLoginViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *bgImageView;

// 手机号
@property (weak, nonatomic) IBOutlet UIImageView *accountIconImageView;
@property (weak, nonatomic) IBOutlet XFLimitedTextField *accountTextField;
@property (weak, nonatomic) IBOutlet UIView *firstSeparatorLine;

// 验证码
@property (weak, nonatomic) IBOutlet UIImageView *captchaIconImageView;
@property (weak, nonatomic) IBOutlet XFLimitedTextField *captchaTextField;
@property (weak, nonatomic) IBOutlet UIView *secondSeparatorLine;
@property (weak, nonatomic) IBOutlet UIButton *requestCaptchaButton;

@property (weak, nonatomic) IBOutlet UIButton *loginButton;


@end

@implementation FSPhoneLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];

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
    self.captchaTextField.maxCount = 6;
    self.secondSeparatorLine.backgroundColor = [UIColor colorSeparatorLine];
    
    [self.requestCaptchaButton setBackgroundImage:[UIImage imageWithColor:[UIColor colorDomina]] forState:UIControlStateNormal];
    [self.requestCaptchaButton setBackgroundImage:[UIImage imageWithColor:[UIColor colorButtonHighlighted]] forState:UIControlStateHighlighted];
    self.requestCaptchaButton.layer.cornerRadius = 5.0f;
    self.requestCaptchaButton.layer.masksToBounds = YES;
    
    // 登录按钮
    [self.loginButton setBackgroundImage:[UIImage imageWithColor:[UIColor colorDomina]] forState:UIControlStateNormal];
    [self.loginButton setBackgroundImage:[UIImage imageWithColor:[UIColor colorButtonHighlighted]] forState:UIControlStateHighlighted];
    [self.loginButton setBackgroundImage:[UIImage imageWithColor:[UIColor colorButtonDisabled]] forState:UIControlStateDisabled];
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

// 登录
- (IBAction)loginButtonTouchUpInside:(UIButton *)sender {
    
    // 获取用户输入的手机号
    NSString *accountStr = self.accountTextField.text;
    
    // 获取用户输入的验证码
    NSString *captcha = self.captchaTextField.text;
    
    if ([Tools isBlankString:accountStr]) {
        return [SVProgressHUD showInfoWithStatus:@"请输入您的手机号"];
    }
    else if (![Tools isMobileNum:accountStr]) {
        return [SVProgressHUD showInfoWithStatus:@"请输入正确的手机号!"];
    }
    else if ([Tools isBlankString:captcha]) {
        return [SVProgressHUD showInfoWithStatus:@"请输入验证码"];

    }
    [self.view endEditing:YES];
    [self loginWithMoblie:accountStr verification:captcha];
    
}

// 获取验证码
- (IBAction)requestCaptchaButtonTouchUpInside:(UIButton *)sender {
    
    // 获取用户输入的手机号
    NSString *accountStr = self.accountTextField.text;
    
    // 检查是否合格
    if ([Tools isBlankString:accountStr]) {
        return [SVProgressHUD showInfoWithStatus:@"请输入手机号"];
    }
    if (![Tools isMobileNum:accountStr]) {
        return [SVProgressHUD showInfoWithStatus:@"请输入正确的手机号!"];
    }
    [self startCountDown];
    [self sendVerificationWithMoblie:accountStr];
    
}

- (IBAction)textFieldChanged:(UITextField *)sender {
    self.loginButton.enabled = self.accountTextField.text.length >= 11 && self.captchaTextField.text.length;
}

#pragma mark - Custom

- (void)startCountDown {
    __block int timeout = CAPTCHA_INTERVAL_TIME; // 倒计时时间
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

#pragma mark - 发送验证码
- (void)sendVerificationWithMoblie:(NSString *)moblie {
    
    NSString *urlString = [NSString stringWithFormat:GETCODE, moblie, @"1"];
    
    [XFNetworking GET:urlString parameters:nil success:^(id responseObject, NSInteger statusCode) {
        NSDictionary *data = [self dictWithData:responseObject];
        
        if ([data[@"issuccess"] boolValue]) {

        }
        [SVProgressHUD showInfoWithStatus:data[@"context"]];
    } failure:^(NSError *error, NSInteger statusCode) {
        [self showInfoWidthError:error];
    }];
}

#pragma mark - 登录
- (void)loginWithMoblie:(NSString *)moblie verification:(NSString *)verification {
    
    NSString *urlString = [NSString stringWithFormat:ZLLOGIN, moblie, verification, 0];
    
    [SVProgressHUD showWithStatus:@"正在登录..."];
    [XFNetworking GET:urlString parameters:nil success:^(id responseObject, NSInteger statusCode) {
        [SVProgressHUD dismiss];
        NSDictionary *data = [self dictWithData:responseObject];
        
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
            
            [userDefaults setObject:data[@"ISshare"] forKey:@"isShare"];
            [userDefaults setObject:data[@"shareUrl"] forKey:@"shareUrl"];
            
            // 重新注册极光推送
            [[NSNotificationCenter defaultCenter] postNotificationName:@"userChangeTuisong" object:nil];
            
            // 改变用户中心的用户状态
            [[NSNotificationCenter defaultCenter] postNotificationName:@"UserChange" object:nil];
            
            // 删除购物车商品
            [self delStoreGoods];
            
            //[self.navigationController popToRootViewControllerAnimated:NO];
            [self.navigationController dismissViewControllerAnimated:YES completion:nil];
            
        } else {
            [SVProgressHUD showInfoWithStatus:data[@"context"]];
        }
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
