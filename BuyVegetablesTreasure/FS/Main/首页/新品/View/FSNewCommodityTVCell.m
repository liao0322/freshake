//
//  FSNewCommodityTVCell.m
//  BuyVegetablesTreasure
//
//  Created by DamonLiao on 2016/12/28.
//  Copyright © 2016年 c521xiong. All rights reserved.
//

#import "FSNewCommodityTVCell.h"
#import "UIButton+EnlargeEdge.h"
#import "NewPruduct.h"

@implementation FSNewCommodityTVCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self.plusButton setEnlargeEdgeWithTop:10 right:5 bottom:10 left:5];
    [self.minusButton setEnlargeEdgeWithTop:10 right:5 bottom:10 left:5];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    
}

- (void)setModel:(NewPruduct *)model {
    _model = model;
    
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:_model.imgUrl] placeholderImage:[UIImage imageNamed:@"placeholderimage"]];
    [self.titleLabel setText:_model.productName];
    
//    // 当前购物车数量
//    NSInteger cartNum = [self.model.CartNum integerValue];
    
    // 当前库存
    NSInteger stock = [self.model.stock integerValue];
    
    if (stock <= 0) { // 库存不足
        self.addGoodsImage.hidden = NO;
        self.priceLabel.textColor = [UIColor colorWithHexString:@"0xBABABA"];
        if ([_model.IsSpecialOffer boolValue]) {
            [self.typeImageView setImage:[UIImage imageNamed:@"Hot促-灰"]];
        } else {
            [self.typeImageView setImage:[UIImage imageNamed:@"Hot新-灰"]];
        }
        self.plusButton.hidden = YES;
        self.plusButton.enabled = NO;
        self.countLabel.hidden = YES;
        self.minusButton.hidden = YES;
        self.minusButton.enabled = NO;
        
    } else {
        self.addGoodsImage.hidden = YES;
        self.priceLabel.textColor = [UIColor colorOrange];
        if ([_model.IsSpecialOffer boolValue]) {
            [self.typeImageView setImage:[UIImage imageNamed:@"Hot促"]];
        } else {
            [self.typeImageView setImage:[UIImage imageNamed:@"Hot新"]];
        }
        self.plusButton.hidden = NO;
        self.plusButton.enabled = YES;
        self.countLabel.hidden = NO;
        self.minusButton.hidden = NO;
        self.minusButton.enabled = YES;
    }
    
    [self.descLabel setText:_model.categoryName];
    
    CGFloat price = [_model.salePrice floatValue];
    [self.priceLabel setText:[NSString stringWithFormat:@"￥%.1f", price]];
    [self.countLabel setText:_model.CartNum];
}

- (IBAction)minusButtonTouchUpInside:(UIButton *)sender {
    if ([self.model.CartNum integerValue] == 0) {
        return;
    }
    if ([self.delegate respondsToSelector:@selector(newCommodityTVCell:minusButtonTouchUpInside:)]) {
        [self.delegate newCommodityTVCell:self minusButtonTouchUpInside:sender];
    }
}

- (IBAction)plusButtonTouchUpInside:(UIButton *)sender {
    // 当前购物车数量
    NSInteger cartNum = [self.model.CartNum integerValue];
    
    // 当前库存
    NSInteger stock = [self.model.stock integerValue];
    
    // 如果当前的购物车数量 + 1 大于 库存 就不让请求
    if ((cartNum + 1) > stock) {
        [SVProgressHUD showInfoWithStatus:@"库存不足!"];
        return;
    }
    if ([self.delegate respondsToSelector:@selector(newCommodityTVCell:plusButtonTouchUpInside:)]) {
        [self.delegate newCommodityTVCell:self plusButtonTouchUpInside:sender];
    }
}


@end
