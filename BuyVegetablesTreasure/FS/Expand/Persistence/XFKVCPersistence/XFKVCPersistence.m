//
//  XFKVCPersistence.m
//  InnerForCourier
//
//  Created by DamonLiao on 2017/2/4.
//  Copyright © 2017年 DamonLiao. All rights reserved.
//

#import "XFKVCPersistence.h"

@implementation XFKVCPersistence

+ (void)setValue:(id)value forKey:(NSString *)key {
    [[NSUserDefaults standardUserDefaults] setObject:value forKey:key];
}

+ (id)get:(NSString *)key {
    return [[NSUserDefaults standardUserDefaults] objectForKey:key];
}

+ (BOOL)contain:(NSString *)key {
    return [self get:key] != nil;
}

+ (void)remove:(NSString *)key {
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:key];
}

+ (void)clear {
    NSUserDefaults *userDefatluts = [NSUserDefaults standardUserDefaults];
    NSString *appDomainStr = [[NSBundle mainBundle] bundleIdentifier];
    [userDefatluts removePersistentDomainForName:appDomainStr];
    [userDefatluts synchronize];
}

@end
