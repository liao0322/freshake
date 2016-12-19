//
//  RegisterViewController.m
//  BuyVegetablesTreasure
//
//  Created by ky on 15/10/26.
//  Copyright (c) 2015年 c521xiong. All rights reserved.
//

#import "RegisterViewController.h"
#import "NSString+MD5.h"
#import "SucceedViewController.h"
#import "RegisterView.h"

@interface RegisterViewController ()

@property (nonatomic, strong) RegisterView *registerView;

@end

@implementation RegisterViewController

- (void)viewDidLoad {

    [self setNav];
    [self initRegisterView];
}

- (void)setNav {
    self.view.backgroundColor = [UIColor colorWithHexString:@"0xf8f8f8"];
    self.navigationItem.titleView = [Utillity customNavToTitle:@"注 册"];
    self.navigationItem.leftBarButtonItem = [UIFactory createBackBBIWithTarget:self action:@selector(back)];
}

- (void)initRegisterView {
    
    _registerView = [[RegisterView alloc] initWithFrame:self.view.frame];
    [self.view addSubview:_registerView];
    
    WS(weakSelf);
    _registerView.registered = ^(NSArray *registeredArray) {
        [weakSelf userRegister:registeredArray];
    };
    
    _registerView.sendVerification = ^(NSString *phoneString) {
        [weakSelf sendVerification:phoneString];
    };
    
    [_registerView setGoViewContrller:^(UIViewController *viewController) {
        
        [weakSelf.navigationController pushViewController:viewController animated:YES];
    }];
}

- (void)back {
    [self.navigationController popViewControllerAnimated:YES];

}

#pragma mark - 数据请求
#pragma mark 用户注册
- (void)userRegister:(NSArray *)registeredInfoArray {

    if (!_registerView.agreementBtn.selected) {
        return [Tools myHud:@"请先阅读用户协议" inView:self.view];
    }
    
    NSString *urlString = [NSString stringWithFormat:REGISTER,registeredInfoArray[0], [registeredInfoArray[2] md5String], registeredInfoArray[1]];
    NSLog(@"==注册==%@",urlString);
    
    [HttpRequest sendGetOrPostRequest:urlString param:nil requestStyle:Get setSerializer:Json isShowLoading:YES success:^(id data)
    {
        if ([data[@"issuccess"] boolValue]) {
            
            NSString *urlString = [NSString stringWithFormat:ZLLOGIN, registeredInfoArray[0], [registeredInfoArray[2] md5String], 1];
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
                    
                    [self.navigationController pushViewController:[SucceedViewController new] animated:YES];
                    [self delStoreGoods];
                }
                
            } failure:^(NSError *error) {
                
            }];
        }
        else [Tools myHud:data[@"context"] inView:self.view];
        
    } failure:nil];

}

#pragma mark 发送验证码
- (void)sendVerification:(NSString *)phoneString {
    
    if (!_registerView.countdownBtn.enabled) return;
    
    NSString *urlString = [NSString stringWithFormat:GETCODER,phoneString,@"0"];
    NSLog(@"%@",urlString);
    
    [HttpRequest sendGetOrPostRequest:urlString param:nil requestStyle:Get setSerializer:Json isShowLoading:YES success:^(id data)
    {
        if (_registerView.countdownBtn.enabled) {
            
            if ([data[@"issuccess"] boolValue]) {
                
                [_registerView.countdownBtn startTiming];
                
                [Single sharedInstance].coder = data[@"context"];
            }
            
            [Tools myHud:data[@"context"] inView:self.view];
        }

    } failure:nil];
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
