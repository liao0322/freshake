//
//  AppDelegate+FS.m
//  BuyVegetablesTreasure
//
//  Created by DamonLiao on 2016/12/19.
//  Copyright © 2016年 c521xiong. All rights reserved.
//

#import "AppDelegate+FS.h"

@implementation AppDelegate (FS)

- (void)fsGlobalSetup {
    // 开始监听网络
    [XFNetworking startMonitoringNetwork];
    
    // 设置 SVProgressHUD
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
    
    // 设置 状态栏
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
}

@end
