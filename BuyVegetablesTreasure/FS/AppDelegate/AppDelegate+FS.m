//
//  AppDelegate+FS.m
//  BuyVegetablesTreasure
//
//  Created by DamonLiao on 2016/12/19.
//  Copyright © 2016年 c521xiong. All rights reserved.
//

#import "AppDelegate+FS.h"
#import "FSNavigationController.h"
#import "FSShoppingCartViewController.h"
#import "FSLoginViewController.h"

@implementation AppDelegate (FS)

- (void)fsGlobalSetup {
    // 开始监听网络
    [XFNetworking startMonitoringNetwork];
    
    // 设置 SVProgressHUD
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
    [SVProgressHUD setMaximumDismissTimeInterval:3];
    
    // 设置 状态栏
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
}

#pragma mark - UITabBarControllerDelegate

- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController {
    FSNavigationController *nav = (FSNavigationController *)viewController;
    
    if ([[nav.viewControllers firstObject] isKindOfClass:[FSShoppingCartViewController class]]) {
        NSString *uid = [[NSUserDefaults standardUserDefaults] objectForKey:@"UID"];
        if ([Tools isBlankString:uid]) {
            
            FSLoginViewController *loginVC = [[FSLoginViewController alloc] init];
            loginVC.title = @"帐号密码登录";
            
            FSNavigationController *navController = [[FSNavigationController alloc] initWithRootViewController:loginVC];
            
            
            [tabBarController presentViewController:navController animated:YES completion:nil];
            return NO;
            
        }
        return YES;
    }
    return YES;
}
@end
