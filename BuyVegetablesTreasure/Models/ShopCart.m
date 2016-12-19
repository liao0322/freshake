//
//  ShopCart.m
//  BuyVegetablesTreasure
//
//  Created by ky on 15/12/16.
//  Copyright © 2015年 c521xiong. All rights reserved.
//

#import "ShopCart.h"

@implementation ShopCart

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
