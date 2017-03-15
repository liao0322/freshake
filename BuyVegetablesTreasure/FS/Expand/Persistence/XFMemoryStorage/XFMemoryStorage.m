//
//  XFMemoryStorage.m
//  InnerForCourier
//
//  Created by DamonLiao on 2017/2/8.
//  Copyright © 2017年 DamonLiao. All rights reserved.
//

#import "XFMemoryStorage.h"

@interface XFMemoryStorage ()

@property (copy, nonatomic) NSMutableDictionary *storage;

@end

@implementation XFMemoryStorage

#pragma mark - XFKVCPersistenceDelegate

+ (void)setValue:(id)value forKey:(NSString *)key {
    if (value) {
        [[self sharedStorage] setObject:value forKey:key];
    } else {
        [self remove:key];
    }
}

+ (id)get:(NSString *)key {
    return [[self sharedStorage] objectForKey:key];
}

+ (BOOL)contain:(NSString *)key {
    return [self get:key] != nil;
}

+ (void)remove:(NSString *)key {
    [[self sharedStorage]removeObjectForKey:key];
}

+ (void)clear {
    [[self sharedStorage] removeAllObjects];
}

#pragma mark - Private

- (void)setObject:(id)value forKey:(NSString *)key {
    [self.storage setObject:value forKey:key];
}

- (id)objectForKey:(id)key {
    return [self.storage objectForKey:key];
}

- (void)removeObjectForKey:(id)key {
    [self.storage removeObjectForKey:key];
}

- (void)removeAllObjects {
    [self.storage removeAllObjects];
}

#pragma mark - 单例实现

static XFMemoryStorage *_instance = nil;

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [super allocWithZone:zone];
    });
    return _instance;
}

+ (instancetype)sharedStorage {
    return [[self alloc] init];
}

- (id)copyWithZone:(NSZone *)zone {
    return _instance;
}

- (id)mutableCopyWithZone:(NSZone *)zone {
    return _instance;
}

- (NSMutableDictionary *)storage {
    if (!_storage) {
        _storage = [[NSMutableDictionary alloc] init];
    }
    return _storage;
}

@end
