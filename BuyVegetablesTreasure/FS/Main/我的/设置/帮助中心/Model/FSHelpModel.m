//
//  FSHelpModel.m
//  BuyVegetablesTreasure
//
//  Created by 江玉元 on 2016/12/20.
//  Copyright © 2016年 c521xiong. All rights reserved.
//

#import "FSHelpModel.h"

@implementation FSHelpModel

- (instancetype)init {
    self = [super init];
    if (self) {
        _HelpList = [NSMutableArray array];

    }
    return self;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    if ([key isEqualToString:@"id"]) {
        self.ID = value;
    }
}

- (id)valueForUndefinedKey:(NSString *)key {
    return nil;
}

@end
