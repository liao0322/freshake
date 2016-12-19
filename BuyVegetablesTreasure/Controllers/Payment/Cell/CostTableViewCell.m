//
//  CostTableViewCell.m
//  BuyVegetablesTreasure
//
//  Created by sc on 15/10/15.
//  Copyright (c) 2015年 c521xiong. All rights reserved.
//

#import "CostTableViewCell.h"
#import "GoodsView.h"

@implementation CostTableViewCell

- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    
    self = [super initWithCoder:aDecoder];
    
    if (self) {
        
//        [self initCell];
    }
    
    return self;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self initCell];
    }
    
    return self;
}

- (void)initCell {
    
    // 标题图片
    UIImageView *titleImageView = [[UIImageView alloc] init];
    titleImageView.image = IMAGE(@"商品详情");
    titleImageView.frame = CGRectMake(15, 14, 22, 22);
    [self addSubview:titleImageView];
    
    // 标题文字
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.frame = CGRectMake(CGRectGetMaxX(titleImageView.frame) + 10, 0, 100, 50);
    titleLabel.font = [UIFont systemFontOfSize:15];
    titleLabel.text = @"费用明细";
    titleLabel.textColor = Color;
    [self addSubview:titleLabel];
    
    UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SYSTEM_WIDTH, 1)];
    line.backgroundColor = [UIColor colorWithHexString:@"0xDAD9D9"];
    [self addSubview:line];
    
    _line = [[UILabel alloc] init];
    _line.frame = CGRectMake(0, 50, SCREEN_WIDTH, 1);
    _line.backgroundColor = [UIColor colorWithHexString:@"0xDAD9D9"];
    [self addSubview:_line];
}

- (void)setArray:(NSArray *)arr {
    
    NSString *express_fee;
    float distancePrice = [[NSUserDefaults standardUserDefaults] doubleForKey:@"DistancePrice"];
    if ([Single sharedInstance].isDelivery) {
        express_fee = [NSString stringWithFormat:@"%.2f",distancePrice];
    }
    else {
        
        express_fee = @"0.00";
    }
    
    if (_goodsView == nil) {
        
        for (int i = 0; i < arr.count; i++) {
            
            ShopCart *model = arr[i];
            
            _goodsView = [[GoodsView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_line.frame) + 50 * i, SCREEN_WIDTH, 50)];
            _goodsView.goodsNameLabel.text = model.productName;
            _goodsView.goodsNumLabel.text = [NSString stringWithFormat:@"x%@",model.productNum];
            _goodsView.goodsPriceLabel.text = [NSString stringWithFormat:@"￥%.2f",[model.salePrice floatValue] * [model.productNum floatValue]];
            [self addSubview:_goodsView];
        }
        
        NSArray *array = @[@"运费:",@"优惠:"];
        
        if (arr.count > 0) {
            
            for (int i = 0; i < array.count; i++ ) {
                
                _serviceLabel = [[UILabel alloc] init];
                _serviceLabel.frame = CGRectMake(15, CGRectGetMaxY(_goodsView.frame) + i * 50, 100, 50);
                _serviceLabel.font = [UIFont systemFontOfSize:14];
                _serviceLabel.text = array[i];
                
                [self addSubview:_serviceLabel];
                
                _priceLabel = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-200, CGRectGetMinY(_serviceLabel.frame), 180, 50)];
                if (i == 0) {
                    _priceLabel.text = [NSString stringWithFormat:@"￥%@",express_fee];
                }
                if (i == 1) {
                    _priceLabel.text = @"￥0.00";
                }
                _priceLabel.textAlignment = NSTextAlignmentRight;
                _priceLabel.textColor = [UIColor colorWithHexString:@"0xff6600"];
                _priceLabel.font = [UIFont systemFontOfSize:14];
                _priceLabel.tag = i + 1;
                [self addSubview:_priceLabel];
            }
            
            _line = [[UILabel alloc] init];
            _line.frame = CGRectMake(0, CGRectGetMaxY(_serviceLabel.frame) - 1, SCREEN_WIDTH, 1);
            _line.backgroundColor = [UIColor colorWithHexString:@"0xDAD9D9"];
            [self addSubview:_line];
        }
    }
    else {
        
        NSString *fullPrice = [[NSUserDefaults standardUserDefaults] objectForKey:@"fullPrice"];
        
        if ([fullPrice intValue] > 1) {
            
            if ([fullPrice floatValue] <= [Single sharedInstance].totalPrice) {
                express_fee = @"0.00";
            }
        }
        
        [(UILabel *)[self viewWithTag:1] setText:[NSString stringWithFormat:@"￥%@",express_fee]];
    }
    
    if ([Single sharedInstance].isDelivery) {
        
        NSString *fullPrice = [[NSUserDefaults standardUserDefaults] objectForKey:@"fullPrice"];
        
        if ([fullPrice intValue] > 1) {
            
            if ([fullPrice floatValue] <= [Single sharedInstance].totalPrice) {
                express_fee = @"0.00";
            }
        }
        
        [(UILabel *)[self viewWithTag:1] setText:[NSString stringWithFormat:@"￥%@",express_fee]];
    }
}

- (void)awakeFromNib {
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
