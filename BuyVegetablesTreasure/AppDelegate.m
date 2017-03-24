//
//  AppDelegate.m
//  BuyVegetablesTreasure
//
//  Created by sc on 15/10/14.
//  Copyright (c) 2015年 c521xiong. All rights reserved.
//

#import "AppDelegate.h"


#import "FirstStarView.h"
#import "AppDelegate+alicallBack.h"

#import <AlipaySDK/AlipaySDK.h>


// FS
#import "AppDelegate+FS.h"
#import "AppDelegate+LaunchAd.h"
#import "FSSplashViewController.h"
#import "FSNavigationController.h"
#import "FSTabBarController.h"
#import "XFKVCPersistence.h"
#import "JDFile.h"
#import "NSDate+Extension.h"

#import "WXApi.h"

@interface AppDelegate ()<WXApiDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    NSLog(@"%@", NSHomeDirectory());
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    // 全局设置
    [self fsGlobalSetup];
    
    NSString *imageName = [XFKVCPersistence get:KEY_AD_IMAGE_NAME];
    NSString *filePath = [self filePathWithImageName:imageName];
    BOOL isExist = [JDFile isFileExist:filePath];
    if (isExist) { // 有图片
        
        NSDate *nowDate = [NSDate now];
        NSDate *adEndTimeDate = [NSDate dateWithStringDate:[XFKVCPersistence get:KEY_AD_END_TIME] formatString:nil];
        NSTimeInterval timeInterval = [adEndTimeDate timeIntervalSinceDate:nowDate];
        
        if (timeInterval < 0.0f) { // 已过期
            [self toMain];
        } else {
            [self restoreRootViewController:[FSSplashViewController new]];
        }
        
    } else {
        [self toMain];
    }
    [self requestLunachAd];
    
    //    [NSThread sleepForTimeInterval:5.0f];
    
    [self setupJPushWithOptions:launchOptions];
    
    
    
    

    [UMSocialData setAppKey:@"57e87c1667e58ee0380015f8"];
    //打开调试log的开关
    [UMSocialData openLog:YES];

    // 设置QQ分享
    [UMSocialQQHandler setQQWithAppId:@"1105606669"
                               appKey:@"k0uCtHZeQtqKe7Fo"
                                  url:@""];
    [UMSocialQQHandler setSupportWebView:YES];
    
    // 设置微信分享
    [UMSocialWechatHandler setWXAppId:WECARTAPPID
                            appSecret:WECARTSECRET
                                  url:@"http://www.umeng.com/social"];
    
    self.locationManager = [[CLLocationManager alloc] init];
    
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        [self.locationManager requestWhenInUseAuthorization];
    }
    
    // 向微信注册wx685053b732d0f4bc（正式）
//    [WXApi registerApp:WECARTAPPID withDescription:@"demo 2.0"];
    [WXApi registerApp:WECARTAPPID];

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
    
    //JGPush(launchOptions, @"39199d3657e3a31906dbc20b");
    [self userchangeTuisong];
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults removeObjectForKey:@"userName"];
    [userDefaults removeObjectForKey:@"userTel"];
    
    return YES;
}

- (void)userchangeTuisong {

//    NSString *uidString = [[NSUserDefaults standardUserDefaults] objectForKey:@"UID"];
    
    /*
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
     */
}


- (void)applicationDidBecomeActive:(UIApplication *)application
{
    [UMSocialSnsService applicationDidBecomeActive];
    [application setApplicationIconBadgeNumber:0];
//    return;
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url{
    
   return [UMSocialSnsService handleOpenURL:url];
    
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation
{
    
    return [UMSocialSnsService handleOpenURL:url wxApiDelegate:nil];
//    [UMSocialSnsService handleOpenURL:url];
//    [WXApi handleOpenURL:url delegate:self];
}

// 设置旋转
- (UIInterfaceOrientationMask)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window {
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

+ (AppDelegate *)appDelegate {
    return (AppDelegate *)[UIApplication sharedApplication].delegate;
}

- (void)toMain {
    FSTabBarController *tabBarController = [[FSTabBarController alloc] init];
    tabBarController.delegate = self;
//    self.window.rootViewController = tabBarController;
    [self restoreRootViewController:tabBarController];
}

- (void)restoreRootViewController:(UIViewController *)rootViewController {
    typedef void (^Animation)(void);
    UIWindow* window = [UIApplication sharedApplication].delegate.window;
    rootViewController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    Animation animation = ^{
        BOOL oldState = [UIView areAnimationsEnabled];
        [UIView setAnimationsEnabled:NO];
        window.rootViewController = rootViewController;
        [UIView setAnimationsEnabled:oldState];
    };
    [UIView transitionWithView:window
                      duration:0.4f
                       options:UIViewAnimationOptionTransitionCrossDissolve
                    animations:animation
                    completion:nil];
}



@end
