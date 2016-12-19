//
//  XFCarouselCell.m
//  BuyVegetablesTreasure
//
//  Created by DamonLiao on 2016/12/8.
//  Copyright © 2016年 c521xiong. All rights reserved.
//

#import "XFCarouselCell.h"
#import "UIColor+Extension.h"
#import "UIImageView+WebCache.h"

@interface XFCarouselCell ()

@property (nonatomic) UIImageView *imageView;

@end

@implementation XFCarouselCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self.contentView addSubview:self.imageView];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.imageView.frame = self.bounds;
}

- (void)setImageUrlString:(NSString *)imageUrlString {
    _imageUrlString = imageUrlString;
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:imageUrlString]];
}


#pragma mark - LazyLoad

- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc] init];
    }
    return _imageView;
}
@end
