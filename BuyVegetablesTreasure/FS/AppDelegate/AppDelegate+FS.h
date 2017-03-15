//
//  AppDelegate+FS.h
//  BuyVegetablesTreasure
//
//  Created by DamonLiao on 2016/12/19.
//  Copyright © 2016年 c521xiong. All rights reserved.
//

#import "AppDelegate.h"

// 引入JPush功能所需头文件
#import "JPUSHService.h"
// iOS10注册APNs所需头文件
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#import <UserNotifications/UserNotifications.h>
#endif

@interface AppDelegate (FS)
<
    UITabBarControllerDelegate,
    JPUSHRegisterDelegate
>

/// 全局设置
- (void)fsGlobalSetup;

- (void)setupJPushWithOptions:(NSDictionary *)launchOptions;

- (void)checkForUpdates;



@end
