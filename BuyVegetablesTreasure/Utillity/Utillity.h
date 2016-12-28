//
//  Utillity.h
//  BuyVegetablesTreasure
//
//  Created by sc on 15/10/14.
//  Copyright (c) 2015年 c521xiong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIDevice+IdentifierAddition.h"

@interface Utillity : UIView

// 设备宽高
#define ScreenWidth  ([[UIScreen mainScreen] bounds].size.width)
#define ScreenHeight ([[UIScreen mainScreen] bounds].size.height)
#define SYSTEM_WIDTH ([[UIScreen mainScreen] bounds].size.width)
#define SYSTEM_HEIGHT ([[UIScreen mainScreen] bounds].size.height)

#define HomePageSpacing 5

// 判断字符串是否为空
#define IsBlankString(name) [Tools isBlankString:name]
// 获取商家Id
#define kGetMID     [[NSUserDefaults standardUserDefaults] objectForKey:@"MID"]
// 获取用户userId
#define kGetUserId  [[NSUserDefaults standardUserDefaults] objectForKey:@"UID"]

// 系统版本
#define SYSTEM_VERSION [[UIDevice currentDevice] systemVersion].floatValue

#define CellIndex [self.tableView indexPathForCell:((UITableViewCell *)longPress.view)]

// 判断设备类型
#define isPad   (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad   ? YES : NO)
#define isPhone (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone ? YES : NO)
#define isRetina ([[UIScreen mainScreen] scale] > 1 ? YES : NO)

#define UUID [[UIDevice currentDevice] uniqueDeviceIdentifier]

#define Color [UIColor colorDomina]

@property ( nonatomic, copy ) UIButton *customButton;

// 显示警告框
+ (void)showAlertViewWithMessage:(NSString *)message viewController:(UIViewController *)viewController;

// 判断网络状态
+ (NSString *)getNetWorkStates;

// 导航条的名字
+ (UILabel *)customNavToTitle:(NSString *)title;

// 设置导航条左键返回按钮
+ (NSArray *)setNavleftBarButtonBackWithImage:(NSString *)imageString target:(id)tartget action:(SEL)selector;

// 计算单个文件大小
+ (float)fileSizeAtPath:(NSString *)path;

// 计算目录大小
+ (float)folderSizeAtPath:(NSString *)path;

// SDWebImage清理缓存文件
+ (void)clearCache:(NSString *)path;

// 转换Json格式
+ (NSString*)DataTOjsonString:(id)object;

// 根据文本计算高度
+ (CGFloat)getTextHeightWithText:(NSString *)text width:(CGFloat)width font:(UIFont *)font;

+ (CGFloat)getTextWidthWithText:(NSString *)text
                         height:(CGFloat)height
                           font:(UIFont *)font;

// 判断是否中文
+ (BOOL)IsChinese:(NSString *)str;

+ (NSString *)string:(NSString *)str;

+ (UIImage *)imageCompressForWidth:(UIImage *)sourceImage targetWidth:(CGFloat)defineWidth;

+ (void)deleteCache;

+ (void)back:(UIViewController *)viewController selectedIndex:(NSInteger)index;

@end
