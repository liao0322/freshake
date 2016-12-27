//
//  MoreViewController.m
//  BuyVegetablesTreasure
//
//  Created by sc on 15/10/14.
//  Copyright (c) 2015年 c521xiong. All rights reserved.
//

#import "MoreViewController.h"
#import "SettingView.h"

@implementation MoreViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
//    _defaults = [NSUserDefaults standardUserDefaults];
//    Switch.on = YES;
//    
//    // 初始化数组数据
//    settingListArray = @[@"帮助中心",@"消息通知",@"版本信息",@"关于我们",@"特别说明"];
//    
//    [self initTableView];
    
    [self setNav];
    [self initSettingView];
}

- (void)setNav {
    
    self.view.backgroundColor = [UIColor colorWithHexString:@"0xf2f2f2"];
    self.navigationItem.titleView = [Utillity customNavToTitle:@"设置"];
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithHexString:@"0xf5f6f8"];
    self.navigationItem.leftBarButtonItem = [UIFactory createBackBBIWithTarget:self action:@selector(back)];
}

- (void)initSettingView {
    
    SettingView *settingView = [[SettingView alloc] initWithFrame:self.view.frame];
    [self.view addSubview:settingView];
    
    WS(weakSelf);
    settingView.goViewController = ^(UIViewController *viewController) {
        [weakSelf goViewController:viewController];
    };
    
    settingView.LogOut = ^{
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"userChangeTuisong" object:nil];
        
        self.tabBarController.selectedIndex = 0;
        [[NSNotificationCenter defaultCenter] postNotificationName:@"change" object:@"0"];
        [self.navigationController popToRootViewControllerAnimated:YES];
    };
}

- (void)back{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark 前往控制器
- (void)goViewController:(UIViewController *)viewController {
    
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:viewController animated:YES];
}

@end
