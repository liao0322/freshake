//
//  CityModel.m
//  BuyVegetablesTreasure
//
//  Created by sc on 15/11/10.
//  Copyright © 2015年 c521xiong. All rights reserved.
//

#import "CityModel.h"

@implementation CityModel

@synthesize id = _id;

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        _cityArray = [NSMutableArray array];
    }
    return self;
}

@end
