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
    self.selectAllButton.x = 10;
    
    self.totalPriceTitleLabel.centerY = self.selectAllButton.centerY;
    
    [self.totalPriceLabel sizeToFit];
    self.totalPriceLabel.centerY = self.selectAllButton.centerY;
    
    
    
    
    
    
    
    
}



@end
