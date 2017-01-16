//
//  XFTools.m
//  BuyVegetablesTreasure
//
//  Created by DamonLiao on 2017/1/16.
//  Copyright © 2017年 c521xiong. All rights reserved.
//

#import "XFTools.h"

@implementation XFTools

/// 字符串是否为空
+ (BOOL)isStringEmpty:(NSString *)string {
    if ([string isKindOfClass:[NSNull class]]) return YES;
    if (string == nil) return YES;
    if ([string length] < 1) return YES;
    return NO;
}

/// 数组是否为空
+ (BOOL)isArrayEmpty:(NSArray *)array {
    return (array == nil || [array isKindOfClass:[NSNull class]] || array.count == 0);
}

/// 字典是否为空
+ (BOOL)isDictionaryEmpty:(NSDictionary *)dict {
    return (dict == nil || [dict isKindOfClass:[NSNull class]] || dict.allKeys == 0);
}

/// 是否是空对象
+ (BOOL)isObjectEmpty:(NSObject *)object {
    return (object == nil \
     || [object isKindOfClass:[NSNull class]] \
     || ([object respondsToSelector:@selector(length)] && [(NSData *)object length] == 0) \
            || ([object respondsToSelector:@selector(count)] && [(NSArray *)object count] == 0));
}

@end
