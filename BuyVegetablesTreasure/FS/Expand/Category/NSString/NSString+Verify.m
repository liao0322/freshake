//
//  NSString+Verify.m
//  BuyVegetablesTreasure
//
//  Created by DamonLiao on 2016/12/26.
//  Copyright © 2016年 c521xiong. All rights reserved.
//

#import "NSString+Verify.h"

@implementation NSString (Verify)

- (BOOL)isPhoneNumber {
    /**
     * 移动：134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     * 联通：130,131,132,152,155,156,185,186
     * 电信：133,1349,153,180,189,181(增加)
     */
    NSString * MOBIL = @"^1(3[0-9]|5[0-35-9]|8[025-9])\\d{8}$";
    
    NSString * CM = @"^1(34[0-8]|(3[5-9]|5[017-9]|8[2378])\\d)\\d{7}$";
    
    NSString * CU = @"^1(3[0-2]|5[256]|8[56])\\d{8}$";
    
    NSString * CT = @"^1((33|53|8[019])[0-9]|349)\\d{7}$";
    
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBIL];
    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
    
    if (([regextestmobile evaluateWithObject:self]
         || [regextestcm evaluateWithObject:self]
         || [regextestct evaluateWithObject:self]
         || [regextestcu evaluateWithObject:self])) {
        return YES;
    }
    return NO;
}

- (BOOL)isEmpty {
    if (self == nil) { return YES; }
    if ([self isKindOfClass:NSNull.class]) { return YES; }
    NSCharacterSet *set = [NSCharacterSet whitespaceCharacterSet];
    NSString *result = [self stringByTrimmingCharactersInSet:set];
    if (result.length == 0) { return YES; }
    return NO;
}
@end
