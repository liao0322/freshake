//
//  ParentViewController.h
//  BuyVegetablesTreasure
//
//  Created by M on 16/8/16.
//
//

#import <UIKit/UIKit.h>

#define GetUserId [[NSUserDefaults standardUserDefaults] objectForKey:@"UID"]

@interface ParentViewController : UIViewController <UIAlertViewDelegate>

/// 订单号
@property (nonatomic, strong) NSString *orderNoString;

/**
 *  跳转到其他控制器
 *
 *  @param viewController 控制器
 *  @param isHidden       返回是否隐藏Tabbar
 */
- (void)pushViewControlle:(UIViewController *)viewController
       backIsHiddenTabbar:(BOOL)isHidden;


#pragma mark - 请求
/**
 *  是否有密码
 */
- (void)isPayPwd;

/**
 *  Json请求网络
 *
 *  @param urlString 链接
 *  @param isLoading 是否加载
 *  @param success   请求成功
 *  @param failure   请求失败
 */
- (void)requestJsonWithUrlString:(NSString *)urlString
                       isLoading:(BOOL)isLoading
                         success:(void (^)(id data))success
                         failure:(void (^)(NSError *error))failure;

/**
 *  Date请求网络
 *
 *  @param urlString 链接
 *  @param isLoading 是否加载
 *  @param success   请求成功
 *  @param failure   请求失败
 */
- (void)requestDateWithUrlString:(NSString *)urlString
                       isLoading:(BOOL)isLoading
                         success:(void (^)(id data))success
                         failure:(void (^)(NSError *error))failure;

@end
