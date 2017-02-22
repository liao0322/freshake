//
//  XFMeBottomVerticalButton.m
//  BuyVegetablesTreasure
//
//  Created by DamonLiao on 2017/2/12.
//  Copyright © 2017年 c521xiong. All rights reserved.
//

#import "XFMeBottomVerticalButton.h"

@implementation XFMeBottomVerticalButton

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return self;
}


- (void)layoutSubviews {
    [super layoutSubviews];
    

    CGPoint imageOldCenter = self.imageView.center;
    imageOldCenter.x = self.width * 0.5;
    self.imageView.center = imageOldCenter;
    self.imageView.y = 15.0f;
    // self.imageView.y = self.height * 0.15;
    
    self.titleLabel.width = self.width;
    //self.titleLabel.height = self.height - CGRectGetMaxY(self.imageView.frame);
    self.titleLabel.y = CGRectGetMaxY(self.imageView.frame) + 5;
    self.titleLabel.centerX = self.imageView.centerX;
    
}

- (CGFloat)xf_height {
    return CGRectGetMaxY(self.titleLabel.frame) + 15.0f;
}

@end
