//
//  XFProgressHUD.m
//  InnerForCourier
//
//  Created by DamonLiao on 2017/2/7.
//  Copyright © 2017年 DamonLiao. All rights reserved.
//

#import "XFProgressHUD.h"
#import <MBProgressHUD.h>

#define DURING_TIME 2.0f

@implementation XFProgressHUD

static MBProgressHUD *hud = nil;

#pragma mark - Message Only

+ (void)showMessage:(NSString *)message inView:(UIView *)view {
    if (view == nil) {
        view = [self view];
    }
    MBProgressHUD *hud = [MBProgressHUD HUDForView:view];
    if (!hud) {
        hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    }
//    hud.margin = 10.0f;
    hud.mode = MBProgressHUDModeText;
    hud.label.text = message;
    
    // Move to bottm center.
    hud.offset = CGPointMake(0.f, MBProgressMaxOffset);
    
    //    hud.detailsLabelFont = [UIFont boldSystemFontOfSize:16];
    [hud hideAnimated:YES afterDelay:DURING_TIME];
    
}

+ (void)showMessage:(NSString *)message {
    return [self showMessage:message inView:nil];
}

#pragma mark - Loading
+ (void)showLoading {
    [self showLoadingInView:nil];
}

+ (void)showLoadingInView:(UIView *)view {
    if (view == nil) {
        view = [self view];
    }
    hud = [MBProgressHUD HUDForView:view];
    if (!hud) {
        hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    }
    hud.mode = MBProgressHUDModeIndeterminate;
}

+ (void)showLoadingWithMessage:(NSString *)message {
    [self showLoadingWithMessage:message inView:nil];
}

+ (void)showLoadingWithMessage:(NSString *)message inView:(UIView *)view {
    if (view == nil) {
//        view = [[UIApplication sharedApplication].windows lastObject];
        view = [self getCurrentVC].view;
    }
    hud = [MBProgressHUD HUDForView:view];
    if (!hud) {
        hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    }
    hud.mode = MBProgressHUDModeIndeterminate;
    
    // Set the label text.
    hud.label.text = message;
    // You can also adjust other label properties if needed.
    // hud.label.font = [UIFont italicSystemFontOfSize:16.f];
}

+ (void)dismiss {
    [hud hideAnimated:YES];
}

+ (void)dismissInView:(UIView *)view {
    
}

#pragma mark - Success

+ (void)showSuccess:(NSString *)message inView:(UIView *)view {
    if (view == nil) {
        view = [self view];
    }
    [self show:message icon:@"Checkmark" inView:view];
}

+ (void)showSuccess:(NSString *)message {
    [self showSuccess:message inView:nil];
}

#pragma mark - Error

+ (void)showError:(NSString *)message inView:(UIView *)view {
    if (view == nil) {
        view = [self view];
    }
    [self show:message icon:@"error" inView:view];
}

+ (void)showError:(NSString *)message {
    [self showError:message inView:nil];
}


#pragma mark - 私有方法

+ (void)show:(NSString *)text icon:(NSString *)icon inView:(UIView *)view {
    if (view == nil) {
        view = [self view];
    }
    
    MBProgressHUD *hud = [MBProgressHUD HUDForView:view];
    if (!hud) {
        hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    }

    hud.mode = MBProgressHUDModeCustomView;
    // 设置显示图片
    UIImage *image = [[UIImage imageNamed:icon] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    hud.customView = [[UIImageView alloc] initWithImage:image];
    hud.square = YES;
    // 设置显示内容
    //    hud.detailsLabelText = text;
    //    hud.detailsLabelFont = [UIFont boldSystemFontOfSize:16];
    //    hud.color = [UIColor redColor];
    hud.tintColor = [UIColor whiteColor];
    hud.label.text = text;
    // 隐藏时候从父控件中移除
    hud.removeFromSuperViewOnHide = YES;
    [hud hideAnimated:YES afterDelay:DURING_TIME];

}

+ (UIView *)view {
    return [self getCurrentVC].view;
    return [[UIApplication sharedApplication].windows lastObject];
}


@end
