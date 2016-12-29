//
//  FSGroupBuyTVCell.m
//  BuyVegetablesTreasure
//
//  Created by DamonLiao on 2016/12/27.
//  Copyright © 2016年 c521xiong. All rights reserved.
//

#import "FSGroupBuyTVCell.h"

@implementation FSGroupBuyTVCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    [self.groupBuyButton setBackgroundImage:[UIImage imageWithColor:[UIColor colorDomina]] forState:UIControlStateNormal];
    [self.groupBuyButton setBackgroundImage:[UIImage imageWithColor:[UIColor colorButtonHighlighted]] forState:UIControlStateHighlighted];
    [self.groupBuyButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.groupBuyButton.layer.cornerRadius = 5.0f;
    self.groupBuyButton.layer.masksToBounds = YES;
    
    self.bgView.layer.shadowColor = [UIColor blackColor].CGColor;
    self.bgView.layer.shadowOpacity = .1f;
    self.bgView.layer.shadowOffset = CGSizeMake(0, 0);
    self.bgView.layer.shadowRadius = 3;
    self.bgView.layer.shouldGroupAccessibilityChildren = NO;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGFloat width = self.width;
    CGFloat height = self.height;
    CGFloat spacing = 8.0f;
    
    CGFloat imageScale = SCREEN_WIDTH / 375.0f;
    
    self.bgView.x = spacing;
    self.bgView.y = 0;
    self.bgView.width = width - spacing * 2;
    if (SCREEN_WIDTH == 320) {
        self.bgView.height = height - height * 0.06;
    } else if (SCREEN_WIDTH == 375) {
        self.bgView.height = height - height * 0.09;

    } else if (SCREEN_WIDTH == 414) {
        self.bgView.height = height - height * 0.11;
    }
    
    self.iconImageView.width = self.bgView.width;
    self.iconImageView.height = 180 * imageScale;
    self.iconImageView.x = 0;
    self.iconImageView.y = 0;
    
    self.titleLabel.width = self.bgView.width - spacing * 2;
    self.titleLabel.x = spacing;
    self.titleLabel.y = self.iconImageView.bottom + 5;
    
    self.descLabel.width = self.titleLabel.width;
    self.descLabel.x = self.titleLabel.x;
    self.descLabel.y = self.titleLabel.bottom + 5;
    
    self.groupPriceTitleLabel.x = self.titleLabel.x;
    self.groupPriceTitleLabel.y = self.descLabel.bottom + 5;
    
    [self.groupPriceLabel sizeToFit];
    self.groupPriceLabel.centerY = self.groupPriceTitleLabel.centerY;
    self.groupPriceLabel.x = self.groupPriceTitleLabel.right;
    
    [self.salePriceLabel sizeToFit];
    self.salePriceLabel.centerY = self.groupPriceTitleLabel.centerY;
    self.salePriceLabel.x = self.groupPriceLabel.right + 5;
    
    self.groupBuyButton.height = 24;
    self.groupBuyButton.width = 100;
    self.groupBuyButton.right = self.bgView.width - spacing;
    self.groupBuyButton.bottom = self.groupPriceTitleLabel.bottom;
    
}

- (void)setModel:(GroupModel *)model {
    _model = model;
    
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:_model.thumbnailsUrll] placeholderImage:[UIImage imageWithColor:[UIColor colorViewBG]]];
    
    [self.titleLabel setText:_model.ProductName];
    [self.descLabel setText:_model.shortDesc];
    [self.groupPriceLabel setText:_model.ActivityPrice];
    [self.salePriceLabel setText:[NSString stringWithFormat:@"￥%@", _model.salePrice]];
    
    [self.groupBuyButton setTitle:[NSString stringWithFormat:@"%@人团 | 去开团", _model.ActivityUserNum] forState:UIControlStateNormal];
    

    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
