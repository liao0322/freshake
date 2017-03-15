//
//  XFNetworking.h
//  鲜摇派3.0购物车Demo
//
//  Created by DamonLiao on 24/11/2016.
//  Copyright © 2016 DamonLiao. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, XFNetworkStatus) {
    XFNetworkStatusUnknown, // 未知网络
    XFNetworkStatusNotReachable, // 无网络
    XFNetworkStatusReachableViaWWAN, // 手机网络
    XFNetworkStatusReachableViaWiFi // WIFI网络
};

/** 请求成功的Block */
typedef void(^HttpRequestSuccess)(id responseObject, NSInteger statusCode);

/** 请求失败的Block */
typedef void(^HttpRequestFailed)(NSError *error, NSInteger statusCode);

/** 网络状态的Block*/
typedef void(^NetworkStatus)(XFNetworkStatus status);


@interface XFNetworking : NSObject

#pragma mark - 网络监听

/// 开始监听网络状态(此方法在整个项目中只需要调用一次)
+ (void)startMonitoringNetwork;

/// 通过Block回调实时获取网络状态
+ (void)checkNetworkStatusWithBlock:(NetworkStatus)status;

/// 获取当前网络状态,有网YES,无网:NO
+ (BOOL)currentNetworkStatus;

/**
 *  GET请求,无缓存
 *
 *  @param URL        请求地址
 *  @param parameters 请求参数
 *  @param success    请求成功的回调
 *  @param failure    请求失败的回调
 *
 *  @return 返回的对象可取消请求,调用cancel方法
 */
+ (__kindof NSURLSessionTask *)GET:(NSString *)URL
                        parameters:(NSDictionary *)parameters
                           success:(HttpRequestSuccess)success
                           failure:(HttpRequestFailed)failure;


/**
 *  POST请求,无缓存
 *
 *  @param URL        请求地址
 *  @param parameters 请求参数
 *  @param success    请求成功的回调
 *  @param failure    请求失败的回调
 *
 *  @return 返回的对象可取消请求,调用cancel方法
 */
+ (__kindof NSURLSessionTask *)POST:(NSString *)URL
                         parameters:(NSDictionary *)parameters
                            success:(HttpRequestSuccess)success
                            failure:(HttpRequestFailed)failure;

#pragma mark - 数据解析

+ (NSDictionary *)dictWithData:(NSData *)data;
@end
