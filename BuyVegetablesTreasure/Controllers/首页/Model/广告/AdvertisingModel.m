//
//  AdvertisingModel.m
//  VegetablesApp
//
//  Created by M on 16/5/27.
//  Copyright © 2016年 M. All rights reserved.
//

#import "AdvertisingModel.h"

@implementation AdvertisingModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        self.defaultImg = IMAGE(@"BannerError");
    }
    return self;
}

@end
