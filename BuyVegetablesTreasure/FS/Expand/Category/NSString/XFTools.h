//
//  XFTools.h
//  BuyVegetablesTreasure
//
//  Created by DamonLiao on 2017/1/16.
//  Copyright © 2017年 c521xiong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XFTools : NSObject

/// 字符串是否为空
+ (BOOL)isStringEmpty:(NSString *)string;

/// 数组是否为空
+ (BOOL)isArrayEmpty:(NSArray *)array;

/// 字典是否为空
+ (BOOL)isDictionaryEmpty:(NSDictionary *)dict;

/// 是否是空对象
+ (BOOL)isObjectEmpty:(NSObject *)object;



@end
