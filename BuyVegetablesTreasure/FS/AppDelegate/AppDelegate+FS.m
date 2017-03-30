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




#define JPushAppKey @"b347d922d918772bed05afb6"


@implementation AppDelegate (FS)

- (void)fsGlobalSetup {
    // 开始监听网络
    [XFNetworking startMonitoringNetwork];
    
    // 设置 SVProgressHUD
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
    [SVProgressHUD setMaximumDismissTimeInterval:2];
    
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
            FSNavigationController *navController = [[FSNavigationController alloc] initWithRootViewController:loginVC];
            [tabBarController presentViewController:navController animated:YES completion:nil];
            return NO;
        }
        return YES;
    }
    return YES;
}

- (void)setupJPushWithOptions:(NSDictionary *)launchOptions {
    // init apns
    JPUSHRegisterEntity * entity = [[JPUSHRegisterEntity alloc] init];
    entity.types = JPAuthorizationOptionAlert|JPAuthorizationOptionBadge|JPAuthorizationOptionSound;
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        // 可以添加自定义categories
        // NSSet<UNNotificationCategory *> *categories for iOS10 or later
        // NSSet<UIUserNotificationCategory *> *categories for iOS8 and iOS9
    }
    [JPUSHService registerForRemoteNotificationConfig:entity delegate:self];
    BOOL isProduction = YES;
    NSString *channel = @"AppStore";
#ifdef DEBUG
    isProduction = NO;
    channel = @"DEBUG";
#endif
    
    // init jpush
    [JPUSHService setupWithOption:launchOptions appKey:JPushAppKey
                          channel:channel
                 apsForProduction:isProduction
            advertisingIdentifier:nil];
    
    // 监听 自定义消息
    NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
    [defaultCenter addObserver:self selector:@selector(networkDidReceiveMessage:) name:kJPFNetworkDidReceiveMessageNotification object:nil];
    
}

// 注册设备
- (void)application:(UIApplication *)application
didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    
    /// 注册 DeviceToken
    [JPUSHService registerDeviceToken:deviceToken];
}

// 注册失败
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    //Optional
    NSLog(@"did Fail To Register For Remote Notifications With Error: %@", error);
}


- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    
    // Required,For systems with less than or equal to iOS6
    [JPUSHService handleRemoteNotification:userInfo];
}



// 接收到推送消息
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler
{
    
    [JPUSHService handleRemoteNotification:userInfo];
    
    application.applicationIconBadgeNumber = 0;
    
    if (completionHandler) {
        completionHandler(UIBackgroundFetchResultNewData);
    }
    
    // 收到推送消息
    if (application.applicationState == UIApplicationStateActive) {
        IFPLog(@"%@",userInfo);
        
        // 应用正处理前台状态下，不会收到推送消息，因此在此处需要额外处理一下
        if (application.applicationState == UIApplicationStateActive) {
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"收到推送消息" message:userInfo[@"aps"][@"alert"] delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil ,nil];
            [alert show];
        }
    }
    return;
}

// 接受到自定义消息
- (void)networkDidReceiveMessage:(NSNotification *)notification {
    NSLog(@"接收到自定义消息的推送");
    NSDictionary * userInfo = [notification userInfo];
    NSString *content = [userInfo valueForKey:@"content"]; // 推送的内容
    NSLog(@"内容：%@", content);
    
    NSDictionary *extras = [userInfo valueForKey:@"extras"]; // 用户自定义参数
    
    NSLog(@"%@", extras);
    
    
    NSString *customizeField1 = [extras valueForKey:@"customizeField1"]; //服务端传递的Extras附加字段，key是自己定义的
    
}

#pragma mark - JPUSHRegisterDelegate

// iOS 10 Support
// 在前后收到信息
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(NSInteger))completionHandler {
    // Required
    NSDictionary * userInfo = notification.request.content.userInfo;
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
    }
    completionHandler(UNNotificationPresentationOptionAlert); // 需要执行这个方法，选择是否提醒用户，有Badge、Sound、Alert三种类型可以选择设置
}

// iOS 10 Support
// 在后台收到信息
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler {
    // Required
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
    }
    
    UITabBarController *tbvc = self.window.rootViewController;
    tbvc.selectedIndex = 0;
    
    completionHandler();  // 系统要求执行这个方法
}

- (void)setupUMSocial {
    /* 打开调试日志 */
    [[UMSocialManager defaultManager] openLog:YES];
    
    /* 设置友盟appkey */
    [[UMSocialManager defaultManager] setUmSocialAppkey:@"58cfa98f45297d11330006e3"];
    
    [self configUSharePlatforms];
    
    [self confitUShareSettings];
}

- (void)confitUShareSettings
{
    /*
     * 打开图片水印
     */
    //[UMSocialGlobal shareInstance].isUsingWaterMark = YES;
    
    /*
     * 关闭强制验证https，可允许http图片分享，但需要在info.plist设置安全域名
     <key>NSAppTransportSecurity</key>
     <dict>
     <key>NSAllowsArbitraryLoads</key>
     <true/>
     </dict>
     */
    //[UMSocialGlobal shareInstance].isUsingHttpsWhenShareContent = NO;
    
}

- (void)configUSharePlatforms
{
    /* 设置微信的appKey和appSecret */
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_WechatSession appKey:WECARTAPPID appSecret:WECARTSECRET redirectURL:@"http://mobile.umeng.com/social"];
    /*
     * 移除相应平台的分享，如微信收藏
     */
    //[[UMSocialManager defaultManager] removePlatformProviderWithPlatformTypes:@[@(UMSocialPlatformType_WechatFavorite)]];
    
    /* 设置分享到QQ互联的appID
     * U-Share SDK为了兼容大部分平台命名，统一用appKey和appSecret进行参数设置，而QQ平台仅需将appID作为U-Share的appKey参数传进即可。
     */
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_QQ appKey:@"1105606669"/*设置QQ平台的appID*/  appSecret:nil redirectURL:@"http://mobile.umeng.com/social"];
    
    /* 设置新浪的appKey和appSecret */
    /*
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_Sina appKey:@"3921700954"  appSecret:@"04b48b094faeb16683c32669824ebdad" redirectURL:@"https://sns.whalecloud.com/sina2/callback"];
     */
    
}



@end
