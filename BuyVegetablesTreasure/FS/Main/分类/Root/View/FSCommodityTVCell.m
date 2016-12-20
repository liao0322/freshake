//
//  FSCommodityTVCell.m
//  BuyVegetablesTreasure
//
//  Created by DamonLiao on 2016/12/16.
//  Copyright © 2016年 c521xiong. All rights reserved.
//

#import "FSCommodityTVCell.h"
#import "FSCommodityModel.h"

@implementation FSCommodityTVCell

#pragma mark - LifeCycle

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
    if ([self.delegate respondsToSelector:@selector(commodityTVCell:minusButtonTouchUpInside:)]) {
        [self.delegate commodityTVCell:self minusButtonTouchUpInside:sender];
    }
}

- (IBAction)plusButtonTouchUpInside:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(commodityTVCell:plusButtonTouchUpInside:)]) {
        [self.delegate commodityTVCell:self plusButtonTouchUpInside:sender];
    }
}

#pragma mark -

#pragma mark - LazyLoad

- (void)setModel:(FSCommodityModel *)model {
    _model = model;
    
    
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:_model.imgUrl]];
    [self.titleLabel setText:_model.productName];
    [self.descLabel setText:_model.shortDesc];
    
    [self.priceLabel setText:[NSString stringWithFormat:@"￥%@", _model.salePrice]];
    [self.vipLabel setText:[NSString stringWithFormat:@"(会员价)￥%@", _model.UserPrice]];
    
}

@end
