//
//  Order.m
//  BuyVegetablesTreasure
//
//  Created by ky on 15/10/28.
//  Copyright (c) 2015年 c521xiong. All rights reserved.
//

#import "Order.h"

@implementation Order
-(instancetype)init
{
    self = [super init];
    if (self)
    {
        _List = [NSMutableArray array];
    }
    return self;
}

-(void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    if ([key isEqualToString:@"id"])
    {
        self.Id = value;
    }
}

-(id)valueForUndefinedKey:(NSString *)key
{
    return nil;
}

@end
