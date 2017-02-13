//
//  XFMeVerticalButton.m
//  BuyVegetablesTreasure
//
//  Created by DamonLiao on 2017/2/11.
//  Copyright © 2017年 c521xiong. All rights reserved.
//

#import "XFMeVerticalButton.h"

@interface XFMeVerticalButton ()



@end

@implementation XFMeVerticalButton

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (void)commonInit {
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:self.countLabel];


}


- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGPoint imageOldCenter = self.imageView.center;
    imageOldCenter.x = self.width * 0.5;
    self.imageView.center = imageOldCenter;
    self.imageView.y = 8.0f;
    // self.imageView.y = self.height * 0.15;
    
    self.titleLabel.width = self.width;
    //self.titleLabel.height = self.height - CGRectGetMaxY(self.imageView.frame);
    self.titleLabel.y = CGRectGetMaxY(self.imageView.frame) + 5;
    self.titleLabel.centerX = self.imageView.centerX;
    
    [self.countLabel sizeToFit];
    _countLabel.left = self.titleLabel.centerX + 15;
    
    CGFloat width = self.countLabel.width;
    width += 8;
    self.countLabel.width = width;
    self.countLabel.y = 5;
    self.countLabel.height = 14;
    

}

- (CGFloat)xf_height {
    return CGRectGetMaxY(self.titleLabel.frame) + 10.0f;
}

#pragma mark - LazyLoad

- (UILabel *)countLabel {
    if (!_countLabel) {
        _countLabel = [UILabel new];
        _countLabel.backgroundColor = [UIColor whiteColor];
        _countLabel.text = @"11";
        _countLabel.textColor = [UIColor colorDomina];
        _countLabel.font = [UIFont systemFontOfSize:12];
        _countLabel.textAlignment = NSTextAlignmentCenter;
        
        _countLabel.layer.borderColor = [UIColor colorDomina].CGColor;
        _countLabel.layer.borderWidth = 0.5f;
        _countLabel.layer.cornerRadius = 7.0f;
        _countLabel.layer.masksToBounds = YES;
        
    }
    return _countLabel;
}

@end
