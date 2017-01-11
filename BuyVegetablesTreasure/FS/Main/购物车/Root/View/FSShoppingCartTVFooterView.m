//
//  FSShoppingCartTVFooterView.m
//  BuyVegetablesTreasure
//
//  Created by DamonLiao on 2016/12/21.
//  Copyright © 2016年 c521xiong. All rights reserved.
//

#import "FSShoppingCartTVFooterView.h"

@implementation FSShoppingCartTVFooterView

- (void)awakeFromNib {
    [super awakeFromNib];
    self.backgroundColor = [UIColor whiteColor];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.firstSeparatorLine.height = 0.5;
//    self.secondSeparatorLine.height = 0.5;
    self.firstSeparatorLine.width = SCREEN_WIDTH;
    
    self.pointImageView.x = 15;
    
    self.pointLabel.x = self.pointImageView.right + 15;
    
    self.tipsLabel.x = self.pointLabel.x;
    
//    self.couponImageView.x = self.pointImageView.x;
    
//    self.couponLabel.x = self.couponImageView.right + 15;
    
    self.firstSeparatorLine.y = 40;
//    self.secondSeparatorLine.y = self.firstSeparatorLine.bottom + 40;
    
    self.tipsLabel.centerY = 40 * 0.5;
    
    self.pointImageView.centerY = 40 * 0.5 + 40;
//    self.couponImageView.centerY = 40 * 0.5 + 80;
    
    self.pointLabel.centerY = self.pointImageView.centerY;
//    self.couponLabel.centerY = self.couponImageView.centerY;
    
}

@end
