//
//  MyOrderGoodsCell.m
//  BuyVegetablesTreasure
//
//  Created by M on 16/5/11.
//  Copyright © 2016年 c521xiong. All rights reserved.
//

#import "MyOrderGoodsCell.h"

#define TextSize 15.0

@interface MyOrderGoodsCell ()

@property (nonatomic, strong) UIImageView *goodsImageView;
@property (nonatomic, strong) UILabel *goodsNameLabel;
@property (nonatomic, strong) UILabel *goodsPriceLabel;
@property (nonatomic, strong) UILabel *line;

@end

@implementation MyOrderGoodsCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self intCell];
    }
    
    return self;
}

- (void)intCell {
    
    _goodsImageView = [[UIImageView alloc] init];
    [self.contentView addSubview:_goodsImageView];
    
    _goodsNameLabel = [[UILabel alloc] init];
    _goodsNameLabel.font = [UIFont systemFontOfSize:TextSize];
    _goodsNameLabel.textColor = [UIColor colorWithHexString:@"0x404040"];
    _goodsNameLabel.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:_goodsNameLabel];
    
    _goodsPriceLabel = [[UILabel alloc] init];
    _goodsPriceLabel.font = [UIFont systemFontOfSize:TextSize];
    _goodsPriceLabel.textColor = [UIColor colorWithHexString:@"0x404040"];;
    _goodsPriceLabel.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:_goodsPriceLabel];
    
    _line = [[UILabel alloc] init];
    _line.backgroundColor = [UIColor colorWithHexString:@"0xd9d9d9"];
    [self.contentView addSubview:_line];
}

- (void)layoutSubviews {
    
    float width = self.contentView.frame.size.width;
    float height = self.contentView.frame.size.height;
    
    _goodsImageView.frame = CGRectMake(15, 10, height - 20, height - 20);
    _goodsNameLabel.frame = CGRectMake(CGRectGetMaxX(_goodsImageView.frame) + 10, height / 2 - 20, width - CGRectGetMaxX(_goodsImageView.frame) - 30, 15);
    _goodsPriceLabel.frame = CGRectMake(CGRectGetMaxX(_goodsImageView.frame) + 10, CGRectGetMaxY(_goodsNameLabel.frame) + 15, CGRectGetWidth(_goodsNameLabel.frame), 16);
    _line.frame = CGRectMake(0, height - 0.5, width, 0.5);
}

- (void)setModel:(NSDictionary *)dic {

    _goodsNameLabel.text = [NSString stringWithFormat:@"%@ * %@",dic[@"goods_title"],dic[@"quantity"]];
    [_goodsImageView sd_setImageWithURL:[NSURL URLWithString:dic[@"thumbnailsUrll"]] placeholderImage:IMAGE(@"列表页未成功图片")];
        
    NSString *priceString = [NSString stringWithFormat:@"￥%.2f",[dic[@"goods_price"] floatValue]];
    NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@/%@",priceString,dic[@"unit"]]];
    [attributeString setAttributes:@{NSForegroundColorAttributeName : [UIColor colorOrange], NSFontAttributeName : [UIFont boldSystemFontOfSize:17]} range:NSMakeRange(0, priceString.length)];
    
    _goodsPriceLabel.attributedText = attributeString;
}

@end
