//
//  FSCommodityTVCell.m
//  BuyVegetablesTreasure
//
//  Created by DamonLiao on 2016/12/16.
//  Copyright © 2016年 c521xiong. All rights reserved.
//

#import "FSCommodityTVCell.h"
#import "FSCommodityModel.h"
#import "UIImage+Create.h"
#import "UIButton+EnlargeEdge.h"

@implementation FSCommodityTVCell

#pragma mark - LifeCycle

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    [self.plusButton setEnlargeEdgeWithTop:10 right:5 bottom:10 left:5];
    [self.minusButton setEnlargeEdgeWithTop:10 right:5 bottom:10 left:5];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat width = self.width;
    CGFloat height = self.height;
    CGFloat spacing = 8.0f;
    
    // 图片
    self.iconImageView.height = height - spacing * 2;
    self.iconImageView.width = self.iconImageView.height;
    self.iconImageView.x = spacing;
    self.iconImageView.centerY = height * 0.5;
    
    // 标题
    self.titleLabel.width = width - spacing * 3 - self.iconImageView.width;
    self.titleLabel.x = self.iconImageView.right + spacing;
    self.titleLabel.y = spacing;
    
    // 简介
    self.descLabel.width = self.titleLabel.width;
    self.descLabel.x = self.titleLabel.x;
    self.descLabel.y = self.titleLabel.bottom + 5;
    
    // 会员价
    [self.vipLabel sizeToFit];
    self.vipLabel.x = self.titleLabel.x;
    self.vipLabel.bottom = self.iconImageView.bottom;
    
    // 价格
    [self.priceLabel sizeToFit];
    self.priceLabel.x = self.titleLabel.x;
    self.priceLabel.bottom = self.vipLabel.y - 5;
    
    // 加号按钮
    self.plusButton.right = width - spacing;
    self.plusButton.bottom = self.iconImageView.bottom;
    
    // 数量
    self.countLabel.width = 18;
    self.countLabel.right = self.plusButton.x - 5;
    self.countLabel.centerY = self.plusButton.centerY;
    
    // 减号按钮
    self.minusButton.right = self.countLabel.x - 5;
    self.minusButton.bottom = self.plusButton.bottom;
    
    
}

#pragma mark - Custom

- (IBAction)minusButtonTouchUpInside:(UIButton *)sender {
    if ([self.model.CartNum integerValue] == 0) {
        return;
    }
    if ([self.delegate respondsToSelector:@selector(commodityTVCell:minusButtonTouchUpInside:)]) {
        [self.delegate commodityTVCell:self minusButtonTouchUpInside:sender];
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
    if ([self.delegate respondsToSelector:@selector(commodityTVCell:plusButtonTouchUpInside:)]) {
        [self.delegate commodityTVCell:self plusButtonTouchUpInside:sender];
    }
}

#pragma mark -

#pragma mark - LazyLoad

- (void)setModel:(FSCommodityModel *)model {
    _model = model;
    
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:_model.imgUrl] placeholderImage:[UIImage imageNamed:@"placeholderimage"]];
    
    [self.titleLabel setText:_model.productName];
    [self.descLabel setText:_model.shortDesc];
    
    
    CGFloat price = [_model.salePrice floatValue];
    [self.priceLabel setText:[NSString stringWithFormat:@"￥%.1f", price]];
    [self.vipLabel setText:[NSString stringWithFormat:@"(会员价)￥%@", _model.UserPrice]];
    
    [self.countLabel setText:_model.CartNum];
    
}

@end
