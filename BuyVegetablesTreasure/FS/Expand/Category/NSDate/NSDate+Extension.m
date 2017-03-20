//
//  NSDate+Extension.m
//  百思不得姐-01
//
//  Created by 廖晓飞 on 16/4/8.
//  Copyright © 2016年 廖晓飞. All rights reserved.
//

#import "NSDate+Extension.h"

@implementation NSDate (Extension)
- (NSDateComponents *)deltaFrom:(NSDate *)from {
    // 日历
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSCalendarUnit unit = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    return [calendar components:unit fromDate:from toDate:self options:0];
}

- (BOOL)isToday {
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.dateFormat = @"yyyy-MM-dd";
    NSString *nowString = [fmt stringFromDate:[NSDate date]];
    NSString *selfString = [fmt stringFromDate:self];
    return [nowString isEqualToString:selfString];
}

- (BOOL)isYesterday {
    // 2014-12-31 23:59:59 -> 2014-12-31
    // 2015-01-01 00:00:01 -> 2015-01-01
    
    // 日期格式化类
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.dateFormat = @"yyyy-MM-dd";
    
    NSDate *nowDate = [fmt dateFromString:[fmt stringFromDate:[NSDate date]]];
    NSDate *selfDate = [fmt dateFromString:[fmt stringFromDate:self]];
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *cmps = [calendar components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:selfDate toDate:nowDate options:0];
    
    return cmps.year == 0
    && cmps.month == 0
    && cmps.day == 1;
}

- (BOOL)isThisYear {
    // 日历
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSInteger nowYear = [calendar component:NSCalendarUnitYear fromDate:[NSDate date]];
    NSInteger selfYear = [calendar component:NSCalendarUnitYear fromDate:self];
    return nowYear == selfYear;
}

/**
 *  将字符串转为日期
 *
 *  @param strDate 字符串日期
 *
 *  @return 日期
 */
+ (NSDate*)convertDateFromString:(NSString*)strDate
{
    if ([strDate length] == 0) return nil;
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *date = [formatter dateFromString:strDate];
    return date;
}

/**
 *  格式化默认时间戳
 *
 *  @return 格式化字符串
 */
- (NSString *)defaultDateFormat
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    NSString *day = @"";
    if ([self isToday]) {
        [formatter setDateFormat:@"HH:mm"];
    } else if ([self isYesterday]) {
        day = NSLocalizedStringFromTable(@"Yesterday", @"DateFormat", nil);
        [formatter setDateFormat:@" HH:mm"];
    } else {
        [formatter setDateFormat:@"yyyy-MM-dd"];
    }
    return [day stringByAppendingString:[formatter stringFromDate:self]];
}

+ (NSDate *)now {
    NSDate *now = [NSDate date];
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    NSInteger interval = [zone secondsFromGMTForDate:now];
    NSDate *localeDate = [now dateByAddingTimeInterval:interval];
    return localeDate;
}

+ (NSDate *)dateFromTimestamp:(NSInteger)timestamp {
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:timestamp/1000];
    
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    
    NSInteger interval = [zone secondsFromGMTForDate:date];
    NSDate *localeDate = [date dateByAddingTimeInterval:interval];
    return localeDate;
}

+ (NSString *)stringDateWithDate:(NSDate *)date formatString:(NSString *)formatString {
    NSDateFormatter *formatter = [NSDateFormatter new];
    formatter.dateFormat = formatString ? formatString : @"yyyy-MM-dd HH:mm:ss";
    return [formatter stringFromDate:date];
}

+ (NSDate *)dateWithStringDate:(NSString *)stringDate formatString:(NSString *)formatString {
    NSDateFormatter *formatter = [NSDateFormatter new];
    formatter.dateFormat = formatString ? formatString : @"yyyy-MM-dd HH:mm:ss";
    return [formatter dateFromString:stringDate];
}

- (NSDateComponents *)intervalWithDate:(NSDate *)date {
    NSCalendar *calender = [NSCalendar currentCalendar];
    // 获得一个时间元素
    NSCalendarUnit  unit =  NSCalendarUnitYear | NSCalendarUnitMonth
    | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute |NSCalendarUnitSecond;
    return [calender components:unit fromDate:self toDate:date options:kNilOptions];
}

- (NSDateComponents *)intervalWithNow {
    return [self intervalWithDate:[NSDate date]];
}
@end
