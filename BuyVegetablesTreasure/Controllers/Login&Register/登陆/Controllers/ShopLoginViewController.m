//
//  ShopLoginViewController.m
//  BaoqianliShop
//
//  Created by ky on 15/8/17.
//  Copyright (c) 2015年 ky. All rights reserved.
//

#import "ShopLoginViewController.h"

#import "LoginView.h"

@implementation ShopLoginViewController

- (void)viewWillAppear:(BOOL)animated {
    self.tabBarController.tabBar.hidden = YES;
}

- (void)viewDidLoad {
    
    [self setNav];
    [self initLoginView];
}

#pragma mark 设置导航条
- (void)setNav {
    
    self.view.backgroundColor=[UIColor colorWithHexString:@"0xf8f8f8"];
    self.navigationItem.titleView = [Utillity customNavToTitle:@"登 录"];
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithHexString:@"0xf5f6f8"];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:nil];

    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, 30, 15);
    btn.titleLabel.font = [UIFont systemFontOfSize:14];
    btn.titleLabel.textAlignment = NSTextAlignmentRight;
    [btn setTitle:@"取消" forState:UIControlStateNormal];
    [btn setTitleColor:Color forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
}

#pragma mark 登录界面
- (void)initLoginView {

    LoginView *loginView = [[LoginView alloc] initWithFrame:self.view.frame];
    [self.view addSubview:loginView];
    
    WS(weakSelf);
    loginView.goViewController = ^(UIViewController *viewController) {
        [weakSelf goViewController:viewController];
    };
    
    loginView.loginBlock = ^(NSString *userName, NSString *password) {
        [weakSelf loginWithUserName:userName passsword:password];
    };
}

#pragma mark 返回
- (void)back {
    
    if (_isCart) {
    
        self.tabBarController.selectedIndex = 0;
        [[NSNotificationCenter defaultCenter] postNotificationName:@"change" object:@"0"];
    }
    else if ([_type isEqualToString:@"1"]) {
        
        self.tabBarController.selectedIndex = 0;
        [[NSNotificationCenter defaultCenter] postNotificationName:@"change" object:@"0"];
    }
    else {
        
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark 前往控制器
- (void)goViewController:(UIViewController *)viewController {
    
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:viewController animated:YES];
}

#pragma mark 登录
- (void)loginWithUserName:(NSString *)nameString passsword:(NSString *)passsword {
    
    [self.view endEditing:YES];
    
    if ([Tools isBlankString:nameString]) {
        return [Tools myHud:@"请输入账号" inView:self.view];
    }
    else if ([Tools isBlankString:passsword]) {
        return [Tools myHud:@"请输入密码" inView:self.view];
    }
    
    nameString = [nameString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    passsword = [passsword md5String];
    
    NSString *urlString = [NSString stringWithFormat:ZLLOGIN, nameString, passsword, 1];
    NSLog(@"%@",urlString);
    
    [MMProgressHUD showWithStatus:@"正在登录..."];
    [HttpRequest sendRequest:urlString param:nil requestStyle:Get setSerializer:Json success:^(id data)
    {
        if ([data[@"issuccess"] boolValue]) {
            
            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
            NSArray *userDefaultsNumbers = @[@"amount",@"exp",@"point",@"group_id"];
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
        else [MMProgressHUD dismissWithSuccess:data[@"context"]];
        
    } failure:^(NSError *error) {
        [MMProgressHUD dismissWithSuccess:@"登录失败!"];
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

@end
