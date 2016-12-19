//
//  FSHomeActivityCVCell.m
//  BuyVegetablesTreasure
//
//  Created by DamonLiao on 2016/12/15.
//  Copyright © 2016年 c521xiong. All rights reserved.
//

#import "FSHomeActivityCVCell.h"

@interface FSHomeActivityCVCell ()

@property (nonatomic) UIView *separatorLine;

@end

@implementation FSHomeActivityCVCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self.contentView addSubview:self.imageView];
        [self.contentView addSubview:self.separatorLine];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.imageView.frame = self.bounds;
    
    self.separatorLine.width = self.width;
    self.separatorLine.height = 0.5;
    self.separatorLine.x = 0;
    self.separatorLine.y = self.height - self.separatorLine.height;
}

- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc] init];
        //_imageView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _imageView;
}

- (UIView *)separatorLine {
    if (!_separatorLine) {
        _separatorLine = [[UIView alloc] init];
        _separatorLine.backgroundColor = [UIColor colorViewBG];
    }
    return _separatorLine;
}
@end
