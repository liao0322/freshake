//
//  HelpModel.m
//  BuyVegetablesTreasure
//
//  Created by Song on 15/12/19.
//  Copyright © 2015年 c521xiong. All rights reserved.
//

#import "HelpModel.h"

@implementation HelpModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        _HelpList = [NSMutableArray array];
    }
    return self;
}
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
