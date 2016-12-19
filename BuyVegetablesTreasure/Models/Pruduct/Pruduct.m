//
//  Pruduct.m
//  BuyVegetablesTreasure
//
//  Created by ky on 15/10/27.
//  Copyright (c) 2015年 c521xiong. All rights reserved.
//

#import "Pruduct.h"

@implementation Pruduct

-(instancetype)init
{
    self = [super init];
    if (self)
    {
        _albums = [NSMutableArray array];
        _descriptions = [NSMutableArray array];
        _attr = [NSMutableArray array];
    }
    return self;
}

-(void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    if ([key isEqualToString:@"id"])
    {
        self.ID = value;
    }
    if ([key isEqualToString:@"description"])
    {
        self.descriptions = value;
    }
}

-(id)valueForUndefinedKey:(NSString *)key
{
    return nil;
}

@end
