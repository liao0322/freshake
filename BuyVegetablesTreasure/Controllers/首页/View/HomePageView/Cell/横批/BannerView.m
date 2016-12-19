//
//  BannerView.m
//  BuyVegetablesTreasure
//
//  Created by M on 16/12/8.
//  Copyright © 2016年 c521xiong. All rights reserved.
//

#import "BannerView.h"

@interface BannerView ()<SDCycleScrollViewDelegate>

@property (nonatomic, strong) SDCycleScrollView *bannerScrollView;

@end

@implementation BannerView

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        
        [self initBannerView];
        [self initIconImage];
    }
    return self;
}

// 横批
- (void)initBannerView {

    self.bannerScrollView = [[SDCycleScrollView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenWidth / 2)];
    self.bannerScrollView.hidden = YES;
    self.bannerScrollView.delegate = self;
    self.bannerScrollView.dotColor = Color;
    self.bannerScrollView.placeholderImage = IMAGE(@"ErrorBackImage");
    self.bannerScrollView.localizationImagesGroup = @[IMAGE(@"ErrorBackImage")];
    [self addSubview:self.bannerScrollView];
}

- (void)initIconImage {
    
    NSArray *images = @[@"拼团Icon",@"充值Icon",@"新品Icon",@"促销Icon"];
    NSArray *titles = @[@"拼团",@"充值",@"新品",@"促销"];
    
    UIView *bgView = [UIView new];
    bgView.backgroundColor = [UIColor whiteColor];
    bgView.layer.borderWidth = 0.5;
    bgView.layer.borderColor = [LineColor CGColor];
    [self addSubview:bgView];
    
    bgView.sd_layout
    .leftEqualToView(self)
    .rightEqualToView(self)
    .topSpaceToView(self.bannerScrollView, 0)
    .heightIs(90);
    
    for (int i = 0; i < images.count; i++) {
        
        UIButton *iconBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        iconBtn.tag = i + 10;
        iconBtn.backgroundColor = [UIColor whiteColor];
        [iconBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [bgView addSubview:iconBtn];
        
        iconBtn.sd_layout
        .topSpaceToView(bgView, 0)
        .bottomEqualToView(bgView)
        .leftSpaceToView(bgView, ScreenWidth / 4 * i)
        .widthIs(ScreenWidth / 4);
        
        UIImage *img = IMAGE(images[i]);
        UIImageView *iconImgView = [UIImageView new];
        iconImgView.image = img;
        iconImgView.size = img.size;
        iconImgView.contentMode = UIViewContentModeCenter;
        [iconBtn addSubview:iconImgView];
        
        iconImgView.sd_layout
        .centerYIs(35)
        .centerXEqualToView(iconBtn);
        
        UILabel *titleLabel = [UILabel new];
        titleLabel.text = titles[i];
        titleLabel.font = TextFontSize;
        titleLabel.textColor = TextColor;
        titleLabel.textAlignment = NSTextAlignmentCenter;
        [iconBtn addSubview:titleLabel];
        
        titleLabel.sd_layout
        .topSpaceToView(iconImgView, 5)
        .leftEqualToView(iconBtn)
        .rightEqualToView(iconBtn)
        .heightIs(15);
        
        UIView *lineView = [UIView new];
        lineView.backgroundColor = LineColor;
        [iconBtn addSubview:lineView];
        
        lineView.sd_layout
        .leftEqualToView(iconBtn)
        .rightEqualToView(iconBtn)
        .topEqualToView(iconBtn)
        .heightIs(0.5);
    }
}

- (void)btnClick:(UIButton *)iconBtn {
    self.iconBtnClick(iconBtn.tag - 10);
}

- (void)setBannerArray:(NSArray *)bannerArray {
    
    if (bannerArray.count == 0) {
        
        self.bannerScrollView.hidden = YES;
        return;
    }
    else {
        
        self.bannerScrollView.hidden = NO;
    }
    
    NSMutableArray *urlImgArray = [NSMutableArray array];
    for (int i = 0; i < bannerArray.count; i++) {
        
        AdvertisingModel *model = bannerArray[i];
        [urlImgArray addObject:model.ImgUrl];
    }
    
    _bannerArray = bannerArray;
    self.bannerScrollView.imageURLStringsGroup = urlImgArray;
}

// 点击Banner条
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index {
    self.bannerClick(self.bannerArray[index]);
}

@end
