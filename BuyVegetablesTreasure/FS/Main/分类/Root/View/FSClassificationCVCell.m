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
    

    if (SCREEN_WIDTH == 320) {
        self.imageView.y = 10;
    } else if (SCREEN_WIDTH == 375) {
        self.imageView.y = 15;
    } else if (SCREEN_WIDTH == 414) {
        self.imageView.y = 10;
    }

    [self.titleLabel sizeToFit];
    self.titleLabel.width = self.width;
    self.titleLabel.centerX = self.imageView.centerX;
    self.titleLabel.y = self.imageView.bottom + 5;
}



@end
