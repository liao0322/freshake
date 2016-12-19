//
//  SelectCouponCell.m
//  BuyVegetablesTreasure
//
//  Created by M on 16/4/18.
//  Copyright © 2016年 c521xiong. All rights reserved.
//

#import "SelectCouponCell.h"

#define CellHeight 50

@implementation SelectCouponCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self initCell];
    }
    
    return self;
}

- (void)initCell {
    
    UILabel *selectCouponLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 100, CellHeight)];
    selectCouponLabel.text = @"请选择优惠券";
    selectCouponLabel.font = [UIFont systemFontOfSize:14];
    selectCouponLabel.textColor = [UIColor colorWithHexString:@"0xfe9a04"];
    [self.contentView addSubview:selectCouponLabel];
    
    _couponLabel = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth - 200, 0, 160, CellHeight)];
    _couponLabel.text = @"没有可用的优惠券";
    _couponLabel.font = [UIFont systemFontOfSize:14];
    _couponLabel.alpha = 0.5;
    _couponLabel.textColor = [UIColor colorWithHexString:@"0xfe9a04"];
    _couponLabel.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:_couponLabel];
    
    UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(0, CellHeight, ScreenWidth, 1)];
    line.backgroundColor = [UIColor colorWithHexString:@"0xDAD9D9"];
    [self.contentView addSubview:line];
}

@end
