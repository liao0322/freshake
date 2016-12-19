//
//  MobLoginViewController.m
//  BuyVegetablesTreasure
//
//  Created by ky on 15/10/16.
//  Copyright (c) 2015年 c521xiong. All rights reserved.
//

#import "MobLoginViewController.h"
#import "RegisterViewController.h"
#import "MobLoginView.h"

@interface MobLoginViewController ()

@property (nonatomic ,strong) MobLoginView *loginView;

@end

@implementation MobLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setNav];
    [self initMobLoginView];
}

- (void)setNav {
 
    self.view.backgroundColor = [UIColor colorWithHexString:@"0xf8f8f8"];
    self.navigationItem.titleView = [Utillity customNavToTitle:@"手机登录"];
    self.navigationItem.leftBarButtonItem = [UIFactory createBackBBIWithTarget:self action:@selector(back)];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, 30, 15);
    btn.titleLabel.font = [UIFont systemFontOfSize:14];
    btn.titleLabel.textAlignment = NSTextAlignmentRight;
    [btn setTitle:@"注册" forState:UIControlStateNormal];
    [btn setTitleColor:Color forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(pushRegiser) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
}

- (void)initMobLoginView {
    
    _loginView = [[MobLoginView alloc] initWithFrame:self.view.frame];
    [self.view addSubview:_loginView];
    
    WS(weakSelf);
    _loginView.sendVerification = ^(NSString *moblieString) {
        [weakSelf sendVerificationWithMoblie:moblieString];
    };
    
    _loginView.login = ^(NSString *moblieString, NSString *verification) {
        [weakSelf loginWithMoblie:moblieString verification:verification];
    };
}

- (void)back {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark 发送验证码
- (void)sendVerificationWithMoblie:(NSString *)moblie {
    
    if (!_loginView.countdownBtn.enabled) return;
    
    NSString *urlString = [NSString stringWithFormat:GETCODE, moblie, @"1"];
    NSLog(@"===智联宝手机验证码====%@",urlString);

    [HttpRequest sendGetOrPostRequest:urlString param:nil requestStyle:Get setSerializer:Json isShowLoading:YES success:^(id data)
    {
        if (_loginView.countdownBtn.enabled) {
            
            if ([data[@"issuccess"] boolValue]) {
                
                [_loginView.countdownBtn startTiming];
            }
        }
        
        [Tools myHud:data[@"context"] inView:self.view];
        
    } failure:nil];
}

#pragma mark 登录
- (void)loginWithMoblie:(NSString *)moblie verification:(NSString *)verification {
    
    NSString *urlString = [NSString stringWithFormat:ZLLOGIN, moblie, verification, 0];
    NSLog(@"===手机快捷登录====%@",urlString);
    
    [MMProgressHUD showWithStatus:@"正在登录..."];
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

             
             // 重新注册极光推送
             [[NSNotificationCenter defaultCenter] postNotificationName:@"userChangeTuisong" object:nil];
             
             // 改变用户中心的用户状态
             [[NSNotificationCenter defaultCenter] postNotificationName:@"UserChange" object:nil];
             
             // 删除购物车商品
             [self delStoreGoods];
             
             [MMProgressHUD dismissWithSuccess:@"登录成功!"];
             
             [self.navigationController popToRootViewControllerAnimated:YES];
         }
         else [MMProgressHUD dismissWithSuccess:data[@"context"]];
         
     } failure:^(NSError *error) {
         [MMProgressHUD dismissWithSuccess:@"登录失败!"];
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

#pragma mark 注册点击事件
- (void)pushRegiser {
    
    self.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:[RegisterViewController new] animated:YES];
    self.hidesBottomBarWhenPushed=NO;
}

@end