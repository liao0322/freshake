//
//  Address.m
//  BuyVegetablesTreasure
//
//  Created by ky on 15/10/30.
//  Copyright (c) 2015年 c521xiong. All rights reserved.
//

#import "Address.h"

@implementation Address


-(void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    if ([key isEqualToString:@"id"])
    {
        self.ID = value;
    }
}

-(id)valueForUndefinedKey:(NSString *)key
{
    return nil;
}


@end
