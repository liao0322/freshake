//
//  NSString+category.h
//  eatToLiveAround
//
//  Created by sc on 15-5-19.
//  Copyright (c) 2015年 ZG. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (category)

/**
 *  转换拼音
 *
 *  @return 拼音
 */
- (NSString *) transformToPinyin;

/**
 *  判断是否为整形
 *
 *  @return yes no
 */
- (BOOL) isPureInt;
/**
 *  判断是否为浮点形
 *
 *  @return yes no
 */
- (BOOL) isPureFloat;
/**
 *  是否为空
 *
 *  @return yes no
 */
- (BOOL) isEmpty;

/**
 *  MD5加密
 *
 *  @return MD5 String
 */
- (NSString *) md5Str;

/**
 *  哈希
 */
- (NSString*) sha1Str;

/**
 *  获取fileName的完整地址
 */
+ (NSString* ) pathInCacheDirectory:(NSString *)fileName;

/**
 *  base64加密
 */
- (NSString *) encodeBase64;

/**
 *  base64解密
 */
- (NSString *) decodeBase64;

@end
