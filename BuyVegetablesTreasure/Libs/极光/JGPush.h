//
//  JGPush.h
//  JGPush
//
//  Created by M on 16/4/13.
//  Copyright © 2016年 M. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JPUSHService.h"

#define JGPush(name,key) [JGPush setupWithOptions:name appKey:key apsForProduction:NO];

@interface JGPush : JPUSHService

/**
 *  初始化
 *
 *  @param launchOptions 启动参数.
 *  @param appKey        appKey
 *  @param isProduction  是否生产环境. 如果为开发状态,设置为 NO; 如果为生产状态,应改为 YES.
 */
+ (void)setupWithOptions:(NSDictionary *)launchOptions
                  appKey:(NSString *)appKey
        apsForProduction:(BOOL)isProduction;

/**
 *  在appdelegate注册设备处调用
 *
 *  @param deviceToken
 */
+ (void)registerDeviceToken:(NSData *)deviceToken;

/**
 *  获取推送通知
 *
 *  @param userInfo   用户信息
 *  @param completion
 */
+ (void)handleRemoteNotification:(NSDictionary *)userInfo
                      completion:(void (^)(UIBackgroundFetchResult))completion;

+ (void)showLocalNotificationAtFront:(UILocalNotification *)notification;

@end
