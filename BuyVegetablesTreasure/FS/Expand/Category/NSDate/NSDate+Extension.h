//
//  NSDate+Extension.h
//  百思不得姐-01
//
//  Created by 廖晓飞 on 16/4/8.
//  Copyright © 2016年 廖晓飞. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (Extension)

/**
 *  比较self和from的时间差值
 */
- (NSDateComponents *)deltaFrom:(NSDate *)from;

/// 判断是否为今天
- (BOOL)isToday;

/// 判断是否为昨天
- (BOOL)isYesterday;

/// 判断是否为今年
- (BOOL)isThisYear;

/// 将字符串转为日期
+ (NSDate *)convertDateFromString:(NSString*)strDate;

/// 格式化默认时间戳
- (NSString *)defaultDateFormat;

+ (NSDate *)now;

+ (NSDate *)dateFromTimestamp:(NSInteger)timestamp;

/**
 传入 NSDate 对象，按指定的格式输出格式化后的字符串日期

 @param date NSDate对象
 @param formatString 格式，如果传入nil ，默认是 yyyy-MM-dd HH:mm:ss 
 @return 格式化后的日期字符串
 */
+ (NSString *)stringDateWithDate:(NSDate *)date formatString:(NSString *)formatString;


/**
 传入日期的字符串形式，返回一个 NSDate 对象
 */
+ (NSDate *)dateWithStringDate:(NSString *)stringDate formatString:(NSString *)formatString;

// 两个Date之间的比较
- (NSDateComponents *)intervalWithDate:(NSDate *)date;

// 与当前时间比较
- (NSDateComponents *)intervalWithNow;

@end
