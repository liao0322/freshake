//
//  RechardModel.m
//  BuyVegetablesTreasure
//
//  Created by Song on 16/3/14.
//  Copyright © 2016年 c521xiong. All rights reserved.
//

#import "RechardModel.h"

@implementation RechardModel

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
