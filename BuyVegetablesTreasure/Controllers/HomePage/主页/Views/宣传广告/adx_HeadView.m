//
//  adx_HeadView.m
//  BuyVegetablesTreasure
//
//  Created by sc on 16/3/17.
//  Copyright © 2016年 c521xiong. All rights reserved.
//

#import "adx_HeadView.h"

@implementation adx_HeadView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self initBannerView];
        [self initIconImage];
    }
    return self;
}

- (void)initBannerView {
    
    _bannerScrollView = [[SDCycleScrollView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenWidth / 2)];
    _bannerScrollView.delegate = self;
    _bannerScrollView.dotColor = Color;
    _bannerScrollView.placeholderImage = IMAGE(@"ErrorBackImage");
    _bannerScrollView.localizationImagesGroup = @[IMAGE(@"ErrorBackImage")];
    [self addSubview:_bannerScrollView];

}

- (void)initIconImage {
    
    NSArray *images = @[@"拼团Icon",@"充值Icon",@"新品Icon",@"促销Icon"];
    NSArray *titles = @[@"拼团",@"充值",@"新品",@"促销"];
    float iconBtnWidth = ScreenWidth / 4;
    
    for (int i = 0; i < images.count; i++) {
        
        UIImage *img = IMAGE(images[i]);
        UIButton *iconBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        iconBtn.tag = i + 70;
        iconBtn.backgroundColor = [UIColor whiteColor];
        [iconBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:iconBtn];
        
        iconBtn.sd_layout
        .leftSpaceToView(self, iconBtnWidth * i)
        .bottomEqualToView(self)
        .widthIs(iconBtnWidth)
        .heightIs(90);
        
        UIImageView *iconImgView = [[UIImageView alloc] initWithImage:img];
        iconImgView.frame = CGRectMake(iconBtnWidth / 2 - img.size.width / 2, 10, img.size.width, img.size.height);
        [iconBtn addSubview:iconImgView];
        
        UILabel *iconNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(iconImgView.frame) + 5, iconBtnWidth, 15)];
        iconNameLabel.text = titles[i];
        iconNameLabel.font = [UIFont systemFontOfSize:14];
        iconNameLabel.textColor = [UIColor colorWithHexString:@"0x606060"];
        iconNameLabel.textAlignment = NSTextAlignmentCenter;
        [iconBtn addSubview:iconNameLabel];
    }
}

- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index {
    _picBlock(index);
}

- (void)btnClick:(UIButton *)button {
    _picBlock(button.tag);
}

@end
