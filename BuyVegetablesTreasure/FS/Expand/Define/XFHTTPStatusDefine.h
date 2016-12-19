//
//  XFHTTPStatusDefine.h
//  XFiOSKitDemo
//
//  Created by DamonLiao on 03/12/2016.
//  Copyright © 2016 DamonLiao. All rights reserved.
//

#ifndef XFHTTPStatusDefine_h
#define XFHTTPStatusDefine_h

/// HTTP 状态码
typedef NS_ENUM(NSInteger, XFHTTPStatus) {
    
    // 网络错误
    XFHTTPStatusNetworkError = 0,
    
    // 2xx Successful
    
    XFHTTPStatusSuccessful = 200,
    
    // 资源创建请求，请求成功，请求创建的资源成功创建。 一般用于列表的 POST 和资源的 PUT 方法的正常返回。
    XFHTTPStatusCreated = 201,
    
    // 资源删除请求，请求成功。 一般用于资源的 DELETE 方法。
    XFHTTPStatusNoContent = 204,
    
    // 4xx Client Error
    
    // 请求格式错误。客户端未按照接口规定的请求格式发送请求。在测试环境下会返回具体的错误信息：
    XFHTTPStatusBadRequest = 400,
    
    // 请求缺少认证信息或认证信息无效。
    XFHTTPStatusUnauthorized = 401,
    
    // 所请求的内容不被授权。如未认证用户尝试获取其他用户详细信息。
    XFHTTPStatusForbidden = 403,
    
    // 所请求的资源不存在。
    XFHTTPStatusNotFound = 404,
    
    // 请求所使用的HTTP方法不存在。
    XFHTTPStatusMethodNotAllowed = 405,
    XFHTTPStatusDeny = 409,
    
    // 请求超过频率限制。
    XFHTTPStatusTooManyRequests = 429,
    
    // 5xx Server Error
    
    // 服务器错误可能会携带提示信息，当存在提示信息时，应使用响应中的提示信息提示用户。如：
    // 服务器内部错误。客户端应提示用户发生 服务器错误 或使用提示信息。
    XFHTTPStatusInternalServerError = 500,
    
    // 服务器路由失败。客户端应提示用户发生 网络错误 或使用提示信息。
    XFHTTPStatusBadGateway = 502,
    
    // 服务器繁忙或正在维护。客户端应提示用户 服务器忙 或使用提示信息。
    XFHTTPStatusServiceUnavailable = 503
    
};

#endif /* XFHTTPStatusDefine_h */
