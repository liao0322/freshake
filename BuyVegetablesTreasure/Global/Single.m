//
//  Single.m
//  BuyVegetablesTreasure
//
//  Created by ky on 15/10/23.
//  Copyright (c) 2015年 c521xiong. All rights reserved.
//

#import "Single.h"

@implementation Single

static Single *single = nil;


+ (Single *)sharedInstance{
    
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        single = [[self alloc] init];
    });
    
    return single;
}

- (instancetype)init {
    
    self = [super init];
    if (self) {
        
        _isUpdateGoods = YES;
        _isLoadAdvertising = YES;
        _payMent = WeCartPay;
        _invoiceTitle = @"";
        _invoiceContent = @"";
        _userName = @"";
        _userTel = @"";
        _remark = @"";
    }
    return self;
}

- (void)setPointModel:(Map *)model {

    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:model.Fendianname forKey:@"merchantsName"];
    [defaults setObject:model.Fendianname forKey:@"Fendianname"];
    [defaults setObject:model.id forKey:@"merchantsID"];
    [defaults setObject:model.mid forKey:@"MID"];
    [defaults setObject:model.addr forKey:@"merchantsAddress"];
    [defaults setObject:model.picktime forKey:@"merchantsTime"];
    [defaults setObject:model.pickJuli forKey:@"distance"];
    [defaults setObject:model.Distance forKey:@"Distance"];
    [defaults setObject:model.DistancePrice forKey:@"DistancePrice"];
    [defaults setObject:model.xPoint forKey:@"xPoint"];
    [defaults setObject:model.yPoint forKey:@"yPoint"];
    [defaults setObject:model.fullPrice forKey:@"fullPrice"];
    [defaults setBool:[model.IsDistribution boolValue] forKey:@"IsDistribution"];
}

@end
