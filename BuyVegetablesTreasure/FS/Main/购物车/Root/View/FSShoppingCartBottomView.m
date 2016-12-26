//
//  FSShoppingCartBottomView.m
//  BuyVegetablesTreasure
//
//  Created by DamonLiao on 2016/12/21.
//  Copyright © 2016年 c521xiong. All rights reserved.
//

#import "FSShoppingCartBottomView.h"

@implementation FSShoppingCartBottomView

- (void)awakeFromNib {
    [super awakeFromNib];
        
    
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat width = self.width;
    CGFloat height = self.height;
    
    CGFloat spacing = 8.0f;
    
    self.selectAllButton.width = 60;
    self.selectAllButton.height = height - spacing * 2;
    self.selectAllButton.y = spacing;
    self.selectAllButton.x = 8;
    
    self.orderButtonBGView.width = 120;
    self.orderButtonBGView.centerY = self.selectAllButton.centerY;
    self.orderButtonBGView.height = height;
    self.orderButtonBGView.right = width;
    
    self.orderButton.width = self.orderButtonBGView.width;
    self.orderButton.height = self.orderButtonBGView.height;
    self.orderButton.centerY = self.orderButtonBGView.height * 0.5;
    self.orderButton.centerX = self.orderButtonBGView.width * 0.5;
    
    [self.totalPriceLabel sizeToFit];
    self.totalPriceLabel.right = self.orderButtonBGView.x - 5;
    self.totalPriceLabel.centerY = self.orderButtonBGView.centerY;
    
    [self.totalPriceTitleLabel sizeToFit];
    self.totalPriceTitleLabel.centerY = self.orderButtonBGView.centerY;
    self.totalPriceTitleLabel.right = self.totalPriceLabel.x;
    
    
    
}



@end
