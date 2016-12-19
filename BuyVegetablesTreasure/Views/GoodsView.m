//
//  GoodsView.m
//  BuyVegetablesTreasure
//
//  Created by sc on 15/11/6.
//  Copyright © 2015年 c521xiong. All rights reserved.
//

#import "GoodsView.h"

@implementation GoodsView

-(instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        
        [self initGoodsView];
    }
    
    return self;
}

- (void)initGoodsView {
    
    _goodsNameLabel = [[UILabel alloc] init];
    _goodsNumLabel = [[UILabel alloc] init];
    _goodsPriceLabel = [[UILabel alloc] init];
    
    _goodsNameLabel.frame = CGRectMake(15, 0, SCREEN_WIDTH - 45 - 100, 50);
    _goodsNameLabel.font = [UIFont systemFontOfSize:15];
    _goodsNameLabel.numberOfLines = 2;
    [self addSubview:_goodsNameLabel];
    
    _goodsPriceLabel.frame = CGRectMake(SCREEN_WIDTH-110, 0, 90, 50);
    _goodsPriceLabel.font = [UIFont systemFontOfSize:14];
    _goodsPriceLabel.textColor = [UIColor colorWithHexString:@"0xff6600"];
    _goodsPriceLabel.textAlignment = NSTextAlignmentRight;
    [self addSubview:_goodsPriceLabel];
    
    _goodsNumLabel.frame = CGRectMake(CGRectGetMinX(_goodsPriceLabel.frame) - 80, 0, 80, 50);
    _goodsNumLabel.font = [UIFont systemFontOfSize:14];
    _goodsNumLabel.textAlignment = NSTextAlignmentRight;
    [self addSubview:_goodsNumLabel];
    
    UILabel *line = [[UILabel alloc] init];
    line.frame = CGRectMake(0, 49, SCREEN_WIDTH, 1);
    line.backgroundColor = [UIColor colorWithHexString:@"0xDAD9D9"];
    [self addSubview:line];
}

@end
