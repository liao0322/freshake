//
//  Public.h
//  InformPub
//
//  Created by Linf on 15/6/8.
//  Copyright (c) 2015年 Linf. All rights reserved.
//

#ifndef InformPub_Public_h
#define InformPub_Public_h


// 所有打印使用IFPLog,不要在程序中出现NSLog打印（部分第三方库除外）
#ifdef DEBUG
#define IFPLog(format, ...) NSLog(format, ## __VA_ARGS__)
#else
#define IFPLog(format, ...)
#endif

#ifdef DEBUG
#define SLog(format, ...) printf("class: <%p %s:(%d) > method: %s \n%s\n", self, [[[NSString stringWithUTF8String:__FILE__] lastPathComponent] UTF8String], __LINE__, __PRETTY_FUNCTION__, [[NSString stringWithFormat:(format), ##__VA_ARGS__] UTF8String] )
#else
#define SLog(format, ...)
#endif

#define IS_IPAD (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define IS_RETINA ([[UIScreen mainScreen] scale] >= 2.0)
// 屏幕宽高度
#define SCREEN_WIDTH        [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT       [UIScreen mainScreen].bounds.size.height
#define SCREEN_MAX_LENGTH   (MAX(SCREEN_WIDTH, SCREEN_HEIGHT))
#define SCREEN_MIN_LENGTH   (MIN(SCREEN_WIDTH, SCREEN_HEIGHT))

#define IS_IPHONE_4_OR_LESS (IS_IPHONE && SCREEN_MAX_LENGTH < 568.0)
#define IS_IPHONE_5 (IS_IPHONE && SCREEN_MAX_LENGTH == 568.0)
#define IS_IPHONE_6 (IS_IPHONE && SCREEN_MAX_LENGTH == 667.0)
#define IS_IPHONE_6P (IS_IPHONE && SCREEN_MAX_LENGTH == 736.0)

// RGB颜色值
#define RGB(r,g,b)          [UIColor colorWithRed:(double)r/255.0f green:(double)g/255.0f blue:(double)b/255.0f alpha:1]
#define RGBA(r,g,b,a)       [UIColor colorWithRed:(double)r/255.0f green:(double)g/255.0f blue:(double)b/255.0f alpha:(double)a]

#define kOrangeColor         [UIColor colorWithRed:235.0/255 green:97.0/255 blue:0.0/255 alpha:1.0]
#define kGrayColor           [UIColor colorWithHexString:@"333333"]

// tabbar 的高度
#define kTabbar_Height      44
#define kNavBar_Height      64


#define IOS7_OR_LATER       ([[[UIDevice currentDevice] systemVersion] compare:@"7.0"] != NSOrderedAscending)
#define IOS_VERSION         ([[[UIDevice currentDevice] systemVersion] floatValue])

// 设置已经登录
#define kSetLogin           [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"isLogin"]
// 设置退出登录
#define kSetLogout          [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"isLogin"]
// 判断是否登录
#define kIsLogin            [[NSUserDefaults standardUserDefaults] boolForKey:@"isLogin"]
// 是否第一次启动程序
#define kIsFristLaunching   [[NSUserDefaults standardUserDefaults] boolForKey:@"isFristLaunching"]
// 设置已启动
#define KSetFristLaunching  [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"isFristLaunching"]
// 默认图片
#define kDefaultImage       [UIImage imageNamed:@"default"]
// 获取图片
#define IMAGE(name)         [UIImage imageNamed:name]
// appdelegate
#define kAppDelegate        ((AppDelegate *)[UIApplication sharedApplication].delegate)
// Nav色调
#define kNavBackColor        [UIColor colorWithRed:29.0/255 green:159.0/255 blue:168.0/255 alpha:1.0]
// Nav字体颜色
#define KNavTitleColor      [UIColor colorWithHexString:@"0xFFFFFF"]
// Segment颜色
#define KSegmentTitleColor  [UIColor colorWithHexString:@"0x00A0E9"]

//block 中使用Self
#define WS(weakSelf) __weak __typeof(&*self)weakSelf = self;

// 判断是否为空
#define isBlankString(name) [Tools isBlankString:name]

#define TextFontSize [UIFont systemFontOfSize:14]
#define TextColor [UIColor colorWithHexString:@"0x606060"]
#define LineColor [UIColor colorWithHexString:@"0xDADADA"]

//本地化
#define LocalizedString(key) NSLocalizedStringFromTable(key, @"InfoPlist", nil)

#endif
