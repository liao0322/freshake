
//
//  SucceedViewController.m
//  BuyVegetablesTreasure
//
//  Created by ky on 15/10/16.
//  Copyright (c) 2015年 c521xiong. All rights reserved.
//

#import "SucceedViewController.h"
#import "HomePageViewController.h"

@interface SucceedViewController ()

@end

@implementation SucceedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.titleView = [Utillity customNavToTitle:@"注册成功"];
    
    self.navigationItem.leftBarButtonItem = [UIFactory createBackBBIWithTarget:self action:@selector(back)];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *mobile = [userDefaults valueForKey:@"mobile"];
    _welCome.text = [NSString stringWithFormat:@"尊敬的：%@用户，欢迎使用“鲜摇派”，请完善您的资料。",mobile];
    if ([Tools isIphone4s])
    {
        _welCome.font = [UIFont systemFontOfSize:15];
        _ChengRuoLabel.font = [UIFont systemFontOfSize:15];
    }
}

- (void)back {
    
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (IBAction)enterMyAPP:(UIButton *)sender {
    
    [self.navigationController popToRootViewControllerAnimated:YES];
}

@end
