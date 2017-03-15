//
//  FSBaseRequest.h
//  BuyVegetablesTreasure
//
//  Created by DamonLiao on 2017/3/14.
//  Copyright © 2017年 c521xiong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FSBaseRequestKeys.h"

/** 请求成功的Block */
typedef void(^Success)(id responseObject, NSInteger statusCode);
typedef void(^SuccessWithArray)(NSArray *dataArray, NSInteger statusCode);

/** 请求失败的Block */
typedef void(^Failed)(NSError *error, NSInteger statusCode);


@interface FSBaseRequest : NSObject

+ (NSDictionary *)dictWithData:(NSData *)data;

+ (void)handleCode:(NSString *)code;

@end
