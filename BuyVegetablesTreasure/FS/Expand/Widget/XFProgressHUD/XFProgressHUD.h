//
//  XFProgressHUD.h
//  InnerForCourier
//
//  Created by DamonLiao on 2017/2/7.
//  Copyright © 2017年 DamonLiao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSObject+Ext.h"

@interface XFProgressHUD : NSObject

+ (void)showMessage:(NSString *)message inView:(UIView *)view;
+ (void)showMessage:(NSString *)message;

+ (void)showLoading;
+ (void)showLoadingInView:(UIView *)view;

+ (void)showLoadingWithMessage:(NSString *)message;
+ (void)showLoadingWithMessage:(NSString *)message inView:(UIView *)view;

+ (void)dismiss;
+ (void)dismissInView:(UIView *)view;

+ (void)showSuccess:(NSString *)message inView:(UIView *)view;
+ (void)showSuccess:(NSString *)message;

+ (void)showError:(NSString *)message inView:(UIView *)view;
+ (void)showError:(NSString *)message;

@end
