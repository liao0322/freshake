//
//  XFMeModel.m
//  BuyVegetablesTreasure
//
//  Created by DamonLiao on 2017/3/23.
//  Copyright © 2017年 c521xiong. All rights reserved.
//

#import "XFMeModel.h"

@implementation XFMeModel

- (instancetype)initWithTitle:(NSString *)title imageName:(NSString *)imageName {
    self = [super init];
    if (!self) {
        return nil;
    }
    _title = title;
    _imageName = imageName;
    return self;
}

@end
