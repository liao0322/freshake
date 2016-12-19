//
//  LocationCell.m
//  BuyVegetablesTreasure
//
//  Created by sc on 15/10/14.
//  Copyright (c) 2015年 c521xiong. All rights reserved.
//

#import "LocationCell.h"

@implementation LocationCell

- (void)setStoreInfo {
    
    if (_l == nil) {
        
        _l = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SYSTEM_WIDTH, 1)];
        _l.backgroundColor = [UIColor colorWithHexString:@"0xDAD9D9"];
        [self.contentView addSubview:_l];
    }
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    _merchantsAddresLabel.text = [NSString stringWithFormat:@"地址:%@",[defaults objectForKey:@"merchantsAddress"]];
    _merchantsLabel.text = [defaults objectForKey:@"merchantsName"];
    _timeLabel.text = [NSString stringWithFormat:@"自提时间:  %@",[defaults objectForKey:@"merchantsTime"]];

    _distance.text = [NSString stringWithFormat:@"%.2f km",[[defaults objectForKey:@"distance"] floatValue] / 1000];
    
    if (_l1 == nil) {
        
        _l1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 170, SYSTEM_WIDTH, 1)];
        _l1.backgroundColor = [UIColor colorWithHexString:@"0xDAD9D9"];
        [self.contentView addSubview:_l1];
    }
}

@end
