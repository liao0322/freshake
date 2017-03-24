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
#import "WXApi.h"

@interface FSLoginViewController ()

@property (weak, nonatomic) IBOutlet XFLimitedTextField *phoneNumberInputTextField;

@property (weak, nonatomic) IBOutlet UITextField *passwordInputTextField;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (weak, nonatomic) IBOutlet UIButton *registerButton;
@property (weak, nonatomic) IBOutlet UIButton *forgetPasswordButton;
@property (weak, nonatomic) IBOutlet UIButton *phoneLoginButton;
@property (weak, nonatomic) IBOutlet UIButton *weiChatLoginButton;

@property (weak, nonatomic) IBOutlet UIImageView *bgImageView;

@property (weak, nonatomic) IBOutlet UIView *firstSeparatorLine;

@property (weak, nonatomic) IBOutlet UIView *secondSeparatorLine;

@property (weak, nonatomic) IBOutlet UIView *thirdSeparatorLine;

@property (weak, nonatomic) IBOutlet UIImageView *accountIconImageView;
@property (weak, nonatomic) IBOutlet UIImageView *passwordIconImageView;
@property (weak, nonatomic) IBOutlet UIImageView *otherLoginIconImageView;
@property (weak, nonatomic) IBOutlet UIImageView *weiChatIconImageView;

@property (weak, nonatomic) IBOutlet UILabel *otherLoginLabel;
@property (weak, nonatomic) IBOutlet UILabel *weiChatLabel;


@end

@implementation FSLoginViewController

#pragma mark - LifeCycle

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if ([WXApi isWXAppInstalled]) {
        self.weiChatLoginButton.enabled = YES;
        self.weiChatIconImageView.hidden = NO;
        self.weiChatLabel.hidden = NO;
    }else {
        self.weiChatLoginButton.enabled = NO;
        self.weiChatIconImageView.hidden = YES;
        self.weiChatLabel.hidden = YES;
    }
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
    
    self.thirdSeparatorLine.backgroundColor = [UIColor colorSeparatorLine];
    
    self.otherLoginLabel.textColor = [UIColor colorTextAssistant];
    self.weiChatLabel.textColor = [UIColor colorTextDomina];
    
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
    
    self.thirdSeparatorLine.x = spacing;
    self.thirdSeparatorLine.y = self.phoneLoginButton.bottom + spacing;
    self.thirdSeparatorLine.width = self.loginButton.width;
    self.thirdSeparatorLine.height = 0.5;
    
    self.otherLoginIconImageView.centerX = self.thirdSeparatorLine.centerX;
    self.otherLoginIconImageView.centerY = self.thirdSeparatorLine.centerY;
    
    self.otherLoginLabel.centerX = self.otherLoginIconImageView.centerX;
    self.otherLoginLabel.y = self.otherLoginIconImageView.bottom + 5;
    
    self.weiChatIconImageView.centerX = self.otherLoginIconImageView.centerX;
    self.weiChatIconImageView.y = self.otherLoginLabel.bottom + 10;
    
    self.weiChatLabel.centerX = self.weiChatIconImageView.centerX;
    self.weiChatLabel.y = self.weiChatIconImageView.bottom + 5;
    
    self.weiChatLoginButton.centerX = self.weiChatIconImageView.centerX;
    self.weiChatLoginButton.y = self.weiChatIconImageView.y;
    self.weiChatLoginButton.bottom = self.weiChatLabel.bottom;
    
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
        
        [userDefaults setObject:dataDict[@"ISshare"] forKey:@"isShare"];
        [userDefaults setObject:dataDict[@"shareUrl"] forKey:@"shareUrl"];
        
         [[NSNotificationCenter defaultCenter] postNotificationName:@"UserChange" object:nil];
        // 发出通知
        [[NSNotificationCenter defaultCenter] postNotificationName:@"UserIsLogined" object:nil];
        
        // 删除购物车商品
        [self delStoreGoods];
        
        [self dismissViewControllerAnimated:YES completion:nil];
    } failure:^(NSError *error, NSInteger statusCode) { // 登录失败
        [self showInfoWidthError:error];
    }];
}

#pragma 删除购物车商品
- (void)delStoreGoods {
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *mid = [userDefaults objectForKey:@"MID"];
    NSString *uid = [userDefaults objectForKey:@"UID"];
    
    NSString *urlString = [NSString stringWithFormat:DelStoreCartUrl,UUID,mid,uid];
    NSLog(@"%@",urlString);
    [HttpRequest sendRequest:urlString param:nil requestStyle:Get setSerializer:Json success:^(id data)
     {
         NSLog(@"%@",data[@"context"]);
         
     } failure:nil];
}

#pragma mark - 微信登录

// 微信登录按钮事件
- (IBAction)weiChatLoginButtonAction:(UIButton *)sender {
   
    NSLog(@"*********你点的是微信登录哦！");
//    NSString *platformName = [UMSocialSnsPlatformManager getSnsPlatformString:UMSocialSnsTypeWechatSession];
    UMSocialSnsPlatform *snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToWechatSession];
    
    snsPlatform.loginClickHandler(self,[UMSocialControllerService defaultControllerService],YES,^(UMSocialResponseEntity *response){
       
        NSLog(@"%@", response);
        if (response.responseCode == UMSResponseCodeSuccess) {
            
            UMSocialAccountEntity *snsAccount = [[UMSocialAccountManager socialAccountDictionary]valueForKey:UMShareToWechatSession];
            NSLog(@"username is %@, uid is %@,  token is %@ url is %@, unionId is %@, openId is %@",snsAccount.userName,snsAccount.usid,snsAccount.accessToken,snsAccount.iconURL,snsAccount.unionId,snsAccount.openId);
        }
    
    });
  

}



@end
