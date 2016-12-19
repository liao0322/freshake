//
//  GroupDetailModel.m
//  BuyVegetablesTreasure
//
//  Created by M on 16/4/11.
//  Copyright © 2016年 c521xiong. All rights reserved.
//

#import "GroupDetailModel.h"

@implementation GroupDetailModel

@synthesize id = _id;

- (instancetype)init
{
    self = [super init];
    if (self) {
        _listArray = [NSMutableArray array];
    }
    return self;
}

@end
