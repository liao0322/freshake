//
//  Tools.h
//  youmai
//
//  Created by bu88 on 14-10-27.
//  Copyright (c) 2014年 lindu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


typedef enum : NSUInteger {
    Monday = 101,
    Tuesday = 102,
    Wednesday = 103,
    Thursday = 104,
    Friday = 105,
    Saturday = 106,
    Sunday = 107,
    UnKnow = 108
} ZYWeekDayEnum;

@interface Tools : NSObject

+ (BOOL) isIphone4s;

/**
 *  显示在View上的提示
 *
 *  @param str  提示内容
 *  @param view View
 */
+ (void) myHud:(NSString *)str inView:(UIView *)view;

+ (void) myHud:(NSString *)str;

/**
 *  系统的提示  无后续操作
 *
 *  @param str 提示内容
 */
+ (void) myAlert:(NSString *)str;

+ (void)myAlert:(NSString *)str target:(id)target ;

/**
 *  检测字符串是否为空
 *
 *  @param string 字符串
 *
 *  @return yes no
 */
+ (BOOL) isBlankString:(NSString *)string;

/**
 *	@brief	判断今天星期几
 *
 *	@return	返回今天星期几
 */
+ (ZYWeekDayEnum) todayIs;

/**
 *	@brief	返回是否是电话号码
 *
 *	@param 	mobileNum 	传入的电话号码
 *
 *	@return	返回判断后的布尔值
 */
+(BOOL) isMobileNum:(NSString*)mobileNum;

/**
 *	@brief	利用正则表达式验证邮箱的合法性
 *
 *	@param 	email 	邮箱NSString
 *
 *	@return	是否合法
 */
+ (BOOL) isValidateEmail:(NSString *)email;

/**
 *	@brief	 设置searchBar 背景透明
 *
 *	@param 	searchBar 	UISearchBar
 */
+ (void) searchBarToClearWithSearchBar:(UISearchBar *)searchBar;

/**
 *	@brief	判断是否为整形
 *
 *	@param 	string
 *
 *	@return	是否为整形
 */
+ (BOOL) isPureInt:(NSString*)string;

/**
 *  返回带有删除线的字符串
 *
 *  @param string 正常的字符串
 *
 *  @return 带有删除线的字符串
 */
+ (NSMutableAttributedString *) getAttributedStringWithString:(NSString *)string;

/**创建UITableView
 必填：  frame：布局大小
 style：视图类型
 delegate：代理源
 dataSource：数据源
 */
+ (UITableView *)tableViewWithFrame:(CGRect)frame style:(UITableViewStyle)style delegate:(id<UITableViewDelegate>)delegete dataSource:(id<UITableViewDataSource>)dataSource;

+ (CGSize)stringSizeWithString:(NSString *)str attributes:(NSDictionary *)attributes;

/**
 *  计算字符串的CGSize
 *   @param str 待计算的字符串,font 字符串的字体大小,size 字符串的容器大小
 *
*/
+ (CGSize)stringSizeWithSting:(NSString *)str Font:(UIFont *)stringFont boundRect:(CGSize)size;

/**
 * 友盟分享
 * @param target:分享的试图控制器,text:分享的内容,image:分享的图片(可以为空)
 */
//+ (void)umShareWithTarget:(id)target shareText:(NSString *)text shareImage:(UIImage *)image;
//选中商品调用支付宝极简支付
//
/**
 * 支付宝支付
 */
+ (void)alipayPayRequestWithTradeNO:(NSString *)tradeNO ProductName:(NSString *)productName ProductDescription:(NSString *)productDescription Amount:(NSString *)amount notify_url:(NSString *)notify_url;

/**
 * 微信支付
 */
+ (void)WeCartPayWithNoncestr:(NSString *)noncestr package:(NSString *)package partnerid:(NSString *)partnerid prepayid:(NSString *)prepayid timestamp:(NSString *)timestamp;

@end
