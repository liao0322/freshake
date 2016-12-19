//
//  AppDelegate.m
//  BuyVegetablesTreasure
//
//  Created by sc on 15/10/14.
//  Copyright (c) 2015年 c521xiong. All rights reserved.
//

#import "AppDelegate.h"
// #import "TeTabBarViewController.h"


#import "FirstStarView.h"
#import "AppDelegate+alicallBack.h"

#import <AlipaySDK/AlipaySDK.h>
#import "WXApi.h"

#import "FSTabBarController.h"

// FS
#import "AppDelegate+FS.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    // 全局设置
    [self fsGlobalSetup];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    float sysVersion = [[UIDevice currentDevice] systemVersion].floatValue;
    if (sysVersion >= 9.0) {
        UIViewController *vc = [[UIViewController alloc] init];
        self.window.rootViewController = vc;
    }
    [self.window makeKeyAndVisible];

    /*
    TeTabBarViewController *rootVC = [[TeTabBarViewController alloc] init];
     */
    FSTabBarController *tabBarController = [[FSTabBarController alloc] init];
        self.window.rootViewController = tabBarController;
    
    // 友盟Key
    [UMSocialData setAppKey:@"57e87c1667e58ee0380015f8"];
    // 设置QQ分享
    [UMSocialQQHandler setQQWithAppId:@"1105606669"
                               appKey:@"k0uCtHZeQtqKe7Fo"
                                  url:@""];
    [UMSocialQQHandler setSupportWebView:YES];
    
    // 设置微信分享
    [UMSocialWechatHandler setWXAppId:WECARTAPPID
                            appSecret:@"6f8462f766e5d976d9cde4fed3c6a8d1"
                                  url:@""];
    
    self.locationManager = [[CLLocationManager alloc] init];
    
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        
        [self.locationManager requestWhenInUseAuthorization];
        
    }
    
    // 向微信注册wx685053b732d0f4bc（正式）
    [WXApi registerApp:WECARTAPPID withDescription:@"demo 2.0"];

    CLLocationManager *locationManager = [[CLLocationManager alloc] init];
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        [locationManager requestWhenInUseAuthorization];
    }
    
    // 百度地图
    [[BMKMapManager new] start:@"2nryCGYrZaSOzguBvDGLQVGPizEmFccd" generalDelegate:nil];
    
    // 高德地图
    [MAMapServices sharedServices].apiKey = @"083518ce91f78192b6be838053bdceff";
    [AMapSearchServices sharedServices].apiKey = @"083518ce91f78192b6be838053bdceff";
    
    // 用户改变时重新注册极光推送
    [[NSNotificationCenter defaultCenter]addObserver:self
                                            selector:@selector(userchangeTuisong)
                                                name:@"userChangeTuisong"
                                              object:nil];
    
    JGPush(launchOptions, @"39199d3657e3a31906dbc20b");
    [self userchangeTuisong];
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults removeObjectForKey:@"userName"];
    [userDefaults removeObjectForKey:@"userTel"];
    
    return YES;
}

- (void)userchangeTuisong {

    NSString *uidString = [[NSUserDefaults standardUserDefaults] objectForKey:@"UID"];
    if (![Tools isBlankString:uidString]) {
        
        [JPUSHService setTags:[NSSet set] callbackSelector:nil object:self];
        [JPUSHService setAlias:uidString callbackSelector:nil object:self];
        [JPUSHService setTags:[NSSet setWithObjects:@"1",nil] alias:uidString callbackSelector:nil object:self];
    }
    else {
        
        [JPUSHService setTags:[NSSet set] callbackSelector:nil object:self];
        [JPUSHService setAlias:@"" callbackSelector:nil object:self];
        [JPUSHService setTags:[NSSet set] alias:@"" callbackSelector:nil object:self];
    }
}
// 注册设备
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    [JPUSHService registerDeviceToken:deviceToken];
}
// 获取推送
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    
    [JPUSHService handleRemoteNotification:userInfo];
}
// 显示本地通知在最前面
- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification
{
    return [JGPush showLocalNotificationAtFront:notification];
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


//- (BOOL)application:(UIApplication *)app
//            openURL:(NSURL *)url
//            options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options
//{
//    return NO;
//}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    [application setApplicationIconBadgeNumber:0];
    return;
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url{
    
    return  [UMSocialSnsService handleOpenURL:url];
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation
{
    return  [UMSocialSnsService handleOpenURL:url];
}

// 设置旋转
- (UIInterfaceOrientationMask)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window
{
    if (_allowRotation == 1) {
        return UIInterfaceOrientationMaskAll;
    }
    else{
        return (UIInterfaceOrientationMaskPortrait);
    }
}

- (void)applicationWillResignActive:(UIApplication *)application {
//    [BMKMapView willBackGround];
}

@end
