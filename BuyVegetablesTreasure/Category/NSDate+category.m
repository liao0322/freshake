//
//  NSDate+category.m
//  eatToLiveAround
//
//  Created by sc on 15-5-19.
//  Copyright (c) 2015年 ZG. All rights reserved.
//

#import "NSDate+category.h"

@implementation NSDate (category)

static NSCalendar *_calendar = nil;
static NSDateFormatter *_displayFormatter = nil;

+ (void)initializeStatics {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        @autoreleasepool {
            if (_calendar == nil) {
                _calendar = [NSCalendar currentCalendar];
            }
            if (_displayFormatter == nil) {
                _displayFormatter = [[NSDateFormatter alloc] init];
            }
        }
    });
}


- (BOOL) isSameDay:(NSDate*)anotherDate {
    NSCalendar* calendar = [NSCalendar currentCalendar];
    NSDateComponents* components1 = [calendar components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit) fromDate:self];
    NSDateComponents* components2 = [calendar components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit) fromDate:anotherDate];
    return ([components1 year] == [components2 year] && [components1 month] == [components2 month] && [components1 day] == [components2 day]);
}
- (NSInteger) secondsAgo {
    NSCalendar *calendar = [self sharedCalendar];
    NSDateComponents *components = [calendar components:(NSSecondCalendarUnit)
                                               fromDate:self
                                                 toDate:[NSDate date]
                                                options:0];
    return [components second];
}
- (NSInteger) minutesAgo {
    NSCalendar *calendar = [self sharedCalendar];
    NSDateComponents *components = [calendar components:(NSMinuteCalendarUnit)
                                               fromDate:self
                                                 toDate:[NSDate date]
                                                options:0];
    return [components minute];
}
- (NSInteger) hoursAgo {
    NSCalendar *calendar = [self sharedCalendar];
    NSDateComponents *components = [calendar components:(NSHourCalendarUnit)
                                               fromDate:self
                                                 toDate:[NSDate date]
                                                options:0];
    return [components hour];
}
- (NSInteger) monthsAgo {
    NSCalendar *calendar = [self sharedCalendar];
    NSDateComponents *components = [calendar components:(NSMonthCalendarUnit)
                                               fromDate:self
                                                 toDate:[NSDate date]
                                                options:0];
    return [components month];
}

- (NSInteger) yearsAgo {
    NSCalendar *calendar = [self sharedCalendar];
    NSDateComponents *components = [calendar components:(NSYearCalendarUnit)
                                               fromDate:self
                                                 toDate:[NSDate date]
                                                options:0];
    return [components year];
}

- (NSCalendar *) sharedCalendar {
    [[self class] initializeStatics];
    return _calendar;
}

- (NSDateFormatter *) sharedDateFormatter {
    [[self class] initializeStatics];
    return _displayFormatter;
}

- (NSUInteger) daysAgoAgainstMidnight {
    // get a midnight version of ourself:
    NSDateFormatter *mdf = [self sharedDateFormatter];
    [mdf setDateFormat:@"yyyy-MM-dd"];
    NSDate *midnight = [mdf dateFromString:[mdf stringFromDate:self]];
    return (int)[midnight timeIntervalSinceNow] / (60*60*24) *-1;
}

- (NSString *) stringTimesAgo {
    if ([self compare:[NSDate date]] == NSOrderedDescending) {
        return @"刚刚";
    }
    
    NSString *text = nil;
    
    NSInteger agoCount = [self monthsAgo];
    if (agoCount > 0) {
        text = [NSString stringWithFormat:@"%ld个月前", (long)agoCount];
    }else{
        agoCount = [self daysAgoAgainstMidnight];
        if (agoCount > 0) {
            text = [NSString stringWithFormat:@"%ld天前", (long)agoCount];
        }else{
            agoCount = [self hoursAgo];
            if (agoCount > 0) {
                text = [NSString stringWithFormat:@"%ld小时前", (long)agoCount];
            }else{
                agoCount = [self minutesAgo];
                if (agoCount > 0) {
                    text = [NSString stringWithFormat:@"%ld分钟前", (long)agoCount];
                }else{
                    agoCount = [self secondsAgo];
                    if (agoCount > 15) {
                        text = [NSString stringWithFormat:@"%ld秒前", (long)agoCount];
                    }else{
                        text = @"刚刚";
                    }
                }
            }
        }
    }
    return text;
}

@end
