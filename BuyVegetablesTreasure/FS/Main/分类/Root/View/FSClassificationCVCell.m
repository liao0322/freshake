//
//  FSClassificationCVCell.m
//  BuyVegetablesTreasure
//
//  Created by DamonLiao on 2016/12/16.
//  Copyright © 2016年 c521xiong. All rights reserved.
//

#import "FSClassificationCVCell.h"

@implementation FSClassificationCVCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.imageView.centerX = self.width * 0.5;
    self.imageView.y = self.height * 0.1;
    
    [self.titleLabel sizeToFit];
    self.titleLabel.centerX = self.imageView.centerX;
    self.titleLabel.y = self.imageView.bottom + self.height * 0.1;

    
}



@end
