//
//  FSShoppingCartIcon.m
//  BuyVegetablesTreasure
//
//  Created by DamonLiao on 2016/12/28.
//  Copyright © 2016年 c521xiong. All rights reserved.
//

#import "FSShoppingCartIcon.h"

@implementation FSShoppingCartIcon

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)awakeFromNib {
    [super awakeFromNib];
    self.countLabel.layer.cornerRadius = 5.5f;
    self.countLabel.layer.masksToBounds = YES;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(toShoppingCart)];
    [self addGestureRecognizer:tap];
    
    
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self.countLabel sizeToFit];
    CGFloat width = self.countLabel.width;
    width += 6;
    self.countLabel.width = width;
    
    self.countLabel.centerX = self.width * 0.5;
    self.countLabel.y = 5;
    
}

- (void)toShoppingCart {
    if (self.toShoppingCartBlock) {
        self.toShoppingCartBlock();
    }
}



@end
