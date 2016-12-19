//
//  NewPruduct.m
//  BuyVegetablesTreasure
//
//  Created by Song on 16/1/13.
//  Copyright © 2016年 c521xiong. All rights reserved.
//

#import "NewPruduct.h"

@implementation NewPruduct


- (instancetype)init
{
    self = [super init];
    if (self) {
        
        _attr = [NSMutableArray array];
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
