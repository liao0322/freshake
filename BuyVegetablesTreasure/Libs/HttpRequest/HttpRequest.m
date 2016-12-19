//
//  HttpRequest.m
//  AFNetWork封装
//
//  Created by sc on 16/3/16.
//  Copyright © 2016年 xk. All rights reserved.
//

#import "HttpRequest.h"

@implementation HttpRequest

// 网络请求方法
+ (void)sendGetOrPostRequest:(NSString *)url
                       param:(NSDictionary *)param
                requestStyle:(RequestStyle)requestStyle
               setSerializer:(Serializer)serializer
               isShowLoading:(BOOL)isShowLoading
                     success:(void (^)(id data))success
                     failure:(void (^)(NSError *error))failure
{
    MBProgressHUD *hud;
    if (isShowLoading) {
        hud = [MBProgressHUD showHUDAddedTo:[[UIApplication sharedApplication].delegate window] animated:YES];
        hud.labelText = @"加载中...";
        [hud show:YES];
    }
    
    // 创建请求 管理者
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes =  [NSSet setWithObjects:@"application/json",@"text/html",@"text/json",@"text/javascript", nil];
    
    // 设置序列化器
    switch (serializer) {
            
        case Json: {
            manager.requestSerializer = [AFJSONRequestSerializer serializer];
            [manager setResponseSerializer:[AFJSONResponseSerializer serializer]];
            break;
        }
        case Xml: {
            [manager setResponseSerializer:[AFXMLParserResponseSerializer serializer]];
            break;
        }
        case Date: {
            manager.requestSerializer = [AFHTTPRequestSerializer serializer];
            [manager setResponseSerializer:[AFHTTPResponseSerializer serializer]];
            break;
        }
    }
    
    // 发送请求
    if(requestStyle == POST) {
        
        [manager POST:url parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
             NSLog(@"请求成功");
             NSLog(@"返回的数据类型是:%@", [responseObject class]);
             success(responseObject);

            [hud hide:YES];
             
         } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             NSLog(@"请求失败 %@", error);
             
             [hud hide:YES];
         }];
        
    }
    else if(requestStyle == Get)
    {
        [manager GET:url parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
            success(responseObject);
            [hud hide:YES];
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             [hud hide:YES];
         }];
    }
    
}

+ (void)sendRequest:(NSString *)urlString param:(NSDictionary *)param requestStyle:(RequestStyle)requestStyle setSerializer:(Serializer)serializer success:(RequestSuccess)success failure:(RequestFailure)failure
{
    // 创建请求 管理者
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes =  [NSSet setWithObjects:@"application/json",@"text/html",@"text/json",@"text/javascript", nil];
    
    // 设置序列化器
    switch (serializer) {
            
        case Json: {
            manager.requestSerializer = [AFJSONRequestSerializer serializer];
            [manager setResponseSerializer:[AFJSONResponseSerializer serializer]];
            break;
        }
        case Xml: {
            [manager setResponseSerializer:[AFXMLParserResponseSerializer serializer]];
            break;
        }
        case Date: {
            manager.requestSerializer = [AFHTTPRequestSerializer serializer];
            [manager setResponseSerializer:[AFHTTPResponseSerializer serializer]];
            break;
        }
    }

    // 发送请求
    if(requestStyle == POST) {
        
        [manager POST:urlString parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"请求成功");
            NSLog(@"返回的数据类型是:%@", [responseObject class]);
            success(responseObject);
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"请求失败 %@", error);
        }];
        
    }
    else if(requestStyle == Get)
    {
        [manager GET:urlString parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            if (serializer == Date) {
                
                NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
                success(dic);
            }
            else success(responseObject);
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
            if (failure != nil) {
                failure(error);
            }
        }];
    }
    
}

@end
