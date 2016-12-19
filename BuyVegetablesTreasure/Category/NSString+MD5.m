//
//  NSString+MD5.m
//  PocketKitchen
//
//  Created by DancewithPeng on 15/4/30.
//  Copyright (c) 2015年 dancewithpeng@gmail.com. All rights reserved.
//

#import "NSString+MD5.h"
#import <CommonCrypto/CommonCrypto.h>

@implementation NSString (MD5)

- (NSString *)md5String
{
    const char *cStr = [self UTF8String];
    unsigned char buff[16];
    CC_MD5(cStr, (CC_LONG)strlen(cStr), buff);
    
    NSMutableString *result = [[NSMutableString alloc] init];
    for (int i=0; i<16; i++) {
        [result appendFormat:@"%02x", buff[i]];
    }
    
    return result;
}

@end
