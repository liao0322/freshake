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
+ (void)sendGetOrPostRequest:(NSString *)urlString
                       param:(NSDictionary *)param
                requestStyle:(RequestStyle)requestStyle
               setSerializer:(Serializer)serializer
               isShowLoading:(BOOL)isShowLoading
                     success:(void (^)(id data))success
                     failure:(void (^)(NSError *error))failure
{
    if (isShowLoading) {
//        [SVProgressHUD showWithStatus:@"正在加载..."];
        [XFWaterWaveView showLoading];

//        [XFWaterWaveView showLoading];
    }
    
    [XFNetworking GET:urlString parameters:nil success:^(id responseObject, NSInteger statusCode) {
        [XFWaterWaveView dismissLoading];
//        [SVProgressHUD dismiss];
        NSError *error;
        NSDictionary *dataDict = [NSJSONSerialization JSONObjectWithData:responseObject options:kNilOptions error:&error];
        if (error) {
            [SVProgressHUD showWithStatus:@"解析错误"];
            return;
        }
        if (success) {
            success(dataDict);
        }
    } failure:^(NSError *error, NSInteger statusCode) {
//        [SVProgressHUD dismiss];
        [XFWaterWaveView dismissLoading];
        if (failure) {
            failure(error);
        }
    }];
    
    /*
    //MBProgressHUD *hud;
    if (isShowLoading) {
        //hud = [MBProgressHUD showHUDAddedTo:[[UIApplication sharedApplication].delegate window] animated:YES];
        
        [SVProgressHUD showWithStatus:@"正在加载..."];
        //hud.labelText = @"加载中...";
        //[hud show:YES];
    }
    
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    
    // 设置序列化器
    switch (serializer) {
            
        case Json: {
            session.requestSerializer = [AFJSONRequestSerializer serializer];
            [session setResponseSerializer:[AFJSONResponseSerializer serializer]];
            break;
        }
        case Xml: {
            [session setResponseSerializer:[AFXMLParserResponseSerializer serializer]];
            break;
        }
        case Date: {
            session.requestSerializer = [AFHTTPRequestSerializer serializer];
            [session setResponseSerializer:[AFHTTPResponseSerializer serializer]];
            break;
        }
    }
    
    // 发送请求
    if(requestStyle == POST) {
        
        [session POST:urlString parameters:param progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
        {
            if (success != nil) {
                
                NSLog(@"返回的数据类型是:%@", [responseObject class]);
                success(responseObject);
            }
            
            //[hud hide:YES];
            [SVProgressHUD dismiss];
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
           
            if (failure != nil) {
                failure(error);
            }
            
            //[hud hide:YES];
            [SVProgressHUD dismiss];
            
        }];
    }
    else if(requestStyle == Get)
    {
        [session GET:urlString parameters:param progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
        {
            if (success != nil) {
                
                if (serializer == Date) {
                    
                    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
                    success(dic);
                }
                else success(responseObject);
            }
            
            //[hud hide:YES];
            [SVProgressHUD dismiss];

            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
           
            if (failure != nil) {
                failure(error);
            }
            
            //[hud hide:YES];
            [SVProgressHUD dismiss];

        }];
    }
     */
    
}

+ (void)sendRequest:(NSString *)urlString param:(NSDictionary *)param requestStyle:(RequestStyle)requestStyle setSerializer:(Serializer)serializer success:(RequestSuccess)success failure:(RequestFailure)failure
{
    
    [XFNetworking GET:urlString parameters:nil success:^(id responseObject, NSInteger statusCode) {
//        [SVProgressHUD dismiss];
        NSError *error;
        NSDictionary *dataDict = [NSJSONSerialization JSONObjectWithData:responseObject options:kNilOptions error:&error];
        if (error) {
            [SVProgressHUD showWithStatus:@"解析错误"];
            return;
        }
        if (success) {
            success(dataDict);
        }
    } failure:^(NSError *error, NSInteger statusCode) {
//        [SVProgressHUD dismiss];
        if (failure) {
            failure(error);
        }
    }];
    
    /*
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    
    // 设置序列化器
    switch (serializer) {
            
        case Json: {
            session.requestSerializer = [AFJSONRequestSerializer serializer];
            [session setResponseSerializer:[AFJSONResponseSerializer serializer]];
            break;
        }
        case Xml: {
            [session setResponseSerializer:[AFXMLParserResponseSerializer serializer]];
            break;
        }
        case Date: {
            session.requestSerializer = [AFHTTPRequestSerializer serializer];
            [session setResponseSerializer:[AFHTTPResponseSerializer serializer]];
            break;
        }
    }
    
    // 发送请求
    if(requestStyle == POST) {
        
        [session POST:urlString parameters:param progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
         {
             if (success != nil) {
                 
                 NSLog(@"返回的数据类型是:%@", [responseObject class]);
                 success(responseObject);
             }
             
         } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
             
             if (failure != nil) {
                 failure(error);
             }
             
         }];
    }
    else if(requestStyle == Get)
    {
        [session GET:urlString parameters:param progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
         {
             if (success != nil) {
                 
                 if (serializer == Date) {
                     
                     NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
                     success(dic);
                 }
                 else success(responseObject);
             }
             
         } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
             
             if (failure != nil) {
                 failure(error);
             }
         }];
    }
     */
}

@end
