//
//  AppDelegate+alicallBack.m
//  LaMALL
//
//  Created by qianfeng on 15-7-4.
//  Copyright (c) 2015年 yuanjinsong. All rights reserved.
//

#import "AppDelegate+alicallBack.h"
#import <AlipaySDK/AlipaySDK.h>
#import "WXApiManager.h"
@implementation AppDelegate (alicallBack)

// 引用跳转回来的信息
- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    
    if ([url.host isEqualToString:@"safepay"]) {
        //跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
        }];
        [[AlipaySDK defaultService] processAuth_V2Result:url
                                         standbyCallback:^(NSDictionary *resultDic) {
                                         }];
    }
    if ([url.host isEqualToString:@"platformapi"]) {
        [[AlipaySDK defaultService] processAuthResult:url standbyCallback:^(NSDictionary *resultDic) {
        }];
    }
    else
    {
        [WXApi handleOpenURL:url delegate:[WXApiManager sharedManager]];

    }
    return YES;
}


@end
