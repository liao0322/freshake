//
//  XFNetworking.m
//  鲜摇派3.0购物车Demo
//
//  Created by DamonLiao on 24/11/2016.
//  Copyright © 2016 DamonLiao. All rights reserved.
//

#import "XFNetworking.h"
#import <AFNetworkActivityIndicatorManager.h>
// #import "XFError.h"

#define TIME_OUT_INTERVAL 3.0f

#define KEY_NET_ERROR_REASON        @"reason"
#define KEY_NET_ERROR_MESSAGE       @"message"
#define KEY_NET_ERROR_EXCEPTION     @"exception"


@implementation XFNetworking

#pragma mark - 网络监听

static NetworkStatus _status;
static BOOL _isNetwork;

+ (void)startMonitoringNetwork {
    AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager sharedManager];
    
    [manager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        switch (status)
        {
            case AFNetworkReachabilityStatusUnknown:
                _status ? _status(XFNetworkStatusUnknown) : nil;
                _isNetwork = NO;
                NSLog(@"未知网络");
                break;
            case AFNetworkReachabilityStatusNotReachable:
                _status ? _status(XFNetworkStatusNotReachable) : nil;
                _isNetwork = NO;
                NSLog(@"无网络");
                break;
            case AFNetworkReachabilityStatusReachableViaWWAN:
                _status ? _status(XFNetworkStatusReachableViaWWAN) : nil;
                _isNetwork = YES;
                NSLog(@"手机自带网络");
                break;
            case AFNetworkReachabilityStatusReachableViaWiFi:
                _status ? _status(XFNetworkStatusReachableViaWiFi) : nil;
                _isNetwork = YES;
                NSLog(@"WIFI");
                break;
        }
    }];
    [manager startMonitoring];
}

+ (void)checkNetworkStatusWithBlock:(NetworkStatus)status {
    status ? _status = status : nil;
}

+ (BOOL)currentNetworkStatus {
    return _isNetwork;
}

#pragma mark - GET请求无缓存

+ (__kindof NSURLSessionTask *)GET:(NSString *)URL
                        parameters:(NSDictionary *)parameters
                           success:(HttpRequestSuccess)success
                           failure:(HttpRequestFailed)failure {
    
    AFHTTPSessionManager *manager = [self httpSessionManager];
    manager.requestSerializer.timeoutInterval = 15.0f;
    
    return [manager GET:URL parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSInteger statusCode = ((NSHTTPURLResponse *)task.response).statusCode;
        success ? success(responseObject, statusCode) : nil;
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSInteger statusCode = ((NSHTTPURLResponse *)task.response).statusCode;
        failure ? failure(error, statusCode) : nil;
    }];
}

#pragma mark - POST请求无缓存

+ (__kindof NSURLSessionTask *)POST:(NSString *)URL
                         parameters:(NSDictionary *)parameters
                            success:(HttpRequestSuccess)success
                            failure:(HttpRequestFailed)failure {
    
    
    AFHTTPSessionManager *manager = [self httpSessionManager];
    
    return [manager POST:URL parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSInteger statusCode = ((NSHTTPURLResponse *)task.response).statusCode;
        success ? success(responseObject, statusCode) : nil;
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSInteger statusCode = ((NSHTTPURLResponse *)task.response).statusCode;
        failure ? failure(error, statusCode) : nil;
    }];
    
}

#pragma mark - Private

+ (AFHTTPSessionManager *)httpSessionManager {
    
    // 打开状态栏的等待菊花
    [AFNetworkActivityIndicatorManager sharedManager].enabled = YES;
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    // 设置超时时间
//    [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
//    manager.requestSerializer.timeoutInterval = TIME_OUT_INTERVAL;
//    [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    
    // 设置客户端发送给服务器端的数据格式：HTTP (AFJSONRequestSerializer,AFHTTPRequestSerializer)
    manager.requestSerializer = [AFJSONRequestSerializer serializer]; // 上传JSON格式
    
    // 设置服务器返回结果的类型：JSON(AFJSONResponseSerializer,AFHTTPResponseSerializer)
    // manager.responseSerializer = [AFJSONResponseSerializer serializer]; // AFN会JSON解析返回的数据
    manager.responseSerializer = [AFHTTPResponseSerializer serializer]; // AFN不会解析,数据是data，需要自己解析
    // 个人建议还是自己解析的比较好，有时接口返回的数据不合格会报3840错误，大致是AFN无法解析返回来的数据
    
    // 设置客户端能接受的数据类型
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithArray:@[@"application/json",
                                                                              @"text/html",
                                                                              @"text/json",
                                                                              @"text/plain",
                                                                              @"text/javascript",
                                                                              @"text/xml",
                                                                              @"image/*"]];
    
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    return manager;
}

@end
