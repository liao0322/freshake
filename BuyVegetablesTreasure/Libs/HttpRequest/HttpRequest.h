//
//  HttpRequest.h
//  AFNetWork封装
//
//  Created by sc on 16/3/16.
//  Copyright © 2016年 xk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"
#import "MBProgressHUD.h"

typedef void (^RequestSuccess)(id data);
typedef void (^RequestFailure)(NSError *error);

typedef NS_ENUM(NSInteger,RequestStyle) {
    Get = 0,
    POST = 1,
};

typedef NS_ENUM(NSInteger, Serializer) {
    Json = 0,
    Xml = 1,
    Date = 2,
};

@interface HttpRequest : NSObject

/**
 *  网络请求方法
 *
 *  @param url          将要访问的链接
 *  @param param        传入的参数
 *  @param requestStyle 请求方式
 *  @param serializer   数据返回形式
 *  @param success      请求成功后调用
 *  @param failure      请求失败后调用
 */
+ (void)sendGetOrPostRequest:(NSString *)url
                       param:(NSDictionary *)param
                requestStyle:(RequestStyle)requestStyle
               setSerializer:(Serializer)serializer
               isShowLoading:(BOOL)isShowLoading
                     success:(void (^)(id data))success
                     failure:(void (^)(NSError *error))failure;

+ (void)sendRequest:(NSString *)urlString
              param:(NSDictionary *)param
       requestStyle:(RequestStyle)requestStyle
      setSerializer:(Serializer)serializer
            success:(RequestSuccess)success
            failure:(RequestFailure)failure;


@end
