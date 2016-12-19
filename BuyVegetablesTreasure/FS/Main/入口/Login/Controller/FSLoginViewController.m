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

@end

@implementation FSLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.phoneNumberInputTextField.maxCount = 11;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
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

#pragma mark - Custom

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
        }
        
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
        
    } failure:^(NSError *error, NSInteger statusCode) { // 登录失败
        [SVProgressHUD dismiss];
        [SVProgressHUD showErrorWithStatus:@"登录失败"];
    }];
    
    
    /*
    

    [HttpRequest sendRequest:urlString param:nil requestStyle:Get setSerializer:Json success:^(id data)
     {
         if ([data[@"issuccess"] boolValue]) {
             
     
             
             if (_isCart) {
                 
                 self.tabBarController.tabBar.hidden = NO;
                 self.tabBarController.selectedIndex = 0;
                 [[NSNotificationCenter defaultCenter] postNotificationName:@"change" object:@"0"];
             }
             else if (self.tabBarController.selectedIndex != 3) {
                 
                 UINavigationController *nav = self.tabBarController.viewControllers[3];
                 [nav popToRootViewControllerAnimated:YES];
             }
             else self.tabBarController.tabBar.hidden = NO;
             
             [self.navigationController popViewControllerAnimated:YES];
             
             // 重新注册极光推送
             [[NSNotificationCenter defaultCenter] postNotificationName:@"userChangeTuisong" object:nil];
             
             // 改变用户中心的用户状态
             [[NSNotificationCenter defaultCenter] postNotificationName:@"UserChange" object:nil];
             
             // 删除购物车商品
             [self delStoreGoods];
             
             [MMProgressHUD dismissWithSuccess:@"登录成功!"];
         }
         else {
             [MMProgressHUD dismissWithSuccess:data[@"context"]];
         }
         
     } failure:^(NSError *error) {
         [MMProgressHUD dismissWithSuccess:@"登录失败!"];
     }];
     */
}



@end
