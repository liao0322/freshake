//
//  FSSearchResultTVCell.m
//  BuyVegetablesTreasure
//
//  Created by DamonLiao on 2016/12/21.
//  Copyright © 2016年 c521xiong. All rights reserved.
//

#import "FSSearchResultTVCell.h"

@implementation FSSearchResultTVCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat spacing = 8.0f;
    CGFloat width = self.width;
    CGFloat height = self.height;
    
    self.iconImageView.x = spacing;
    self.iconImageView.centerY = height * 0.5;
    
    self.titleLabel.width = width - self.iconImageView.width - spacing * 3;
    self.titleLabel.x = self.iconImageView.right + spacing;
    self.titleLabel.y = self.iconImageView.y;
    
    self.descLabel.width = self.titleLabel.width;
    self.descLabel.x = self.titleLabel.x;
    self.descLabel.y = self.titleLabel.bottom + 5;
    
    [self.priceLabel sizeToFit];
    self.priceLabel.x = self.titleLabel.x;
    self.priceLabel.bottom = self.iconImageView.bottom;
    
    self.plusButton.right = width - spacing;
    self.plusButton.bottom = self.iconImageView.bottom;
    
    self.countLabel.width = 30;
    self.countLabel.right = self.plusButton.x - spacing;
    self.countLabel.centerY = self.plusButton.centerY;
    
    self.minusButton.right = self.countLabel.x - spacing;
    self.minusButton.bottom = self.plusButton.bottom;
    
}

- (void)setModel:(SearchModel *)model {
    _model = model;
    
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:_model.imgUrl] placeholderImage:[UIImage imageNamed:@"placeholderimage"]];
    
    [self.titleLabel setText:_model.productName];
    
    [self.descLabel setText:_model.shortDesc];
    [self.priceLabel setText:[NSString stringWithFormat:@"￥%.1f", [_model.salePrice floatValue]]];
    [self.countLabel setText:_model.CartNum];
    
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
    if ([self.delegate respondsToSelector:@selector(searchResultTVCell:plusButtonTouchUpInside:)]) {
        [self.delegate searchResultTVCell:self plusButtonTouchUpInside:sender];
    }
}

- (IBAction)minusButtonTouchUpInside:(UIButton *)sender {
    if ([self.model.CartNum integerValue] == 0) {
        return;
    }
    if ([self.delegate respondsToSelector:@selector(searchResultTVCell:minusButtonTouchUpInside:)]) {
        [self.delegate searchResultTVCell:self minusButtonTouchUpInside:sender];
    }
}





@end
