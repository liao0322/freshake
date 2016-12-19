//
//  JGPush.m
//  JGPush
//
//  Created by M on 16/4/13.
//  Copyright © 2016年 M. All rights reserved.
//

#import "JGPush.h"

@implementation JGPush

// 在应用启动的时候调用
+ (void)setupWithOptions:(NSDictionary *)launchOptions
                  appKey:(NSString *)appKey
        apsForProduction:(BOOL)isProduction
{
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0){
        
        UIUserNotificationType type = UIUserNotificationTypeBadge | UIUserNotificationTypeAlert |UIUserNotificationTypeSound;
        UIUserNotificationSettings *setting=[UIUserNotificationSettings settingsForTypes:type categories:nil];
        [[UIApplication sharedApplication] registerUserNotificationSettings:setting];
        
        [JPUSHService registerForRemoteNotificationTypes:(UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert) categories:nil];
    }
    else {
        
        // ios8之前 categories 必须为nil
        [JPUSHService registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert) categories:nil];
    }
    
    // 初始化
    [JPUSHService setupWithOption:launchOptions
                           appKey:appKey
                          channel:@"Publish channel"
                 apsForProduction:isProduction];
    
    return;
}

// 在appdelegate注册设备处调用
+ (void)registerDeviceToken:(NSData *)deviceToken {
    [JPUSHService registerDeviceToken:deviceToken];
    return;
}

// 获取推送
+ (void)handleRemoteNotification:(NSDictionary *)userInfo
                      completion:(void (^)(UIBackgroundFetchResult))completion
{
    [JPUSHService handleRemoteNotification:userInfo];
    
    if (completion) {
        completion(UIBackgroundFetchResultNewData);
    }
    return;
}

// 显示本地通知在最前面
+ (void)showLocalNotificationAtFront:(UILocalNotification *)notification {
    
    [JPUSHService showLocalNotificationAtFront:notification identifierKey:nil];
    return;
}

@end
