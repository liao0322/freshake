//
//  GoodsTopCell.m
//  BuyVegetablesTreasure
//
//  Created by M on 16/12/8.
//  Copyright © 2016年 c521xiong. All rights reserved.
//

#import "GoodsTopCell.h"

@interface GoodsTopCell ()

@property (nonatomic, strong) UIImageView *topImageView;

@end

@implementation GoodsTopCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor colorWithHexString:@"0xf8f8f8"];
        
        [self setupUI];
    }
    
    return self;
}

- (void)setupUI {
    
    UIView *hotBgView = [UIView new];
    hotBgView.backgroundColor = [UIColor whiteColor];
    hotBgView.layer.borderWidth = 0.5;
    hotBgView.layer.borderColor = LineColor.CGColor;
    [self addSubview:hotBgView];
    
    hotBgView.sd_layout
    .leftEqualToView(self)
    .rightEqualToView(self)
    .topEqualToView(self)
    .heightIs(45);
    
    UIImageView *titleImgView = [UIImageView new];
    titleImgView.backgroundColor = Color;
    [hotBgView addSubview:titleImgView];
    
    titleImgView.sd_layout
    .leftSpaceToView(hotBgView, 10)
    .topSpaceToView(hotBgView, 15)
    .bottomSpaceToView(hotBgView, 15)
    .widthIs(7.5)
    .centerYEqualToView(hotBgView);
    
    UILabel *titleLabel = [UILabel new];
    titleLabel.text = @"人气推荐";
    titleLabel.font = [UIFont systemFontOfSize:14];
    titleLabel.textColor = Color;
    [hotBgView addSubview:titleLabel];
    
    titleLabel.sd_layout
    .leftSpaceToView(titleImgView, 10)
    .rightSpaceToView(hotBgView, 10)
    .centerYEqualToView(hotBgView)
    .heightIs(15);
    
    self.topImageView = [UIImageView new];
    self.topImageView.layer.borderWidth = 0.5;
    self.topImageView.layer.borderColor = LineColor.CGColor;
    self.topImageView.clipsToBounds = YES;
    self.topImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.topImageView.userInteractionEnabled = YES;
    self.topImageView.hidden = YES;
    [self addSubview:self.topImageView];
    
    self.topImageView.sd_layout
    .topSpaceToView(hotBgView, HomePageSpacing)
    .leftSpaceToView(self, HomePageSpacing)
    .rightSpaceToView(self, HomePageSpacing)
    .heightIs((ScreenWidth - HomePageSpacing * 2) / 2);
    
    // 增加图片点击事件
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(imgClick:)];
    [self.topImageView addGestureRecognizer:tap];
}

- (void)setModel:(AdvertisingModel *)model {
    
    if (model == nil) {
        
        self.topImageView.hidden = YES;
        return;
    }
    
    _model = model;
    self.topImageView.hidden = NO;
    self.topImageView.image = model.img != nil ? model.img : model.defaultImg;
}

- (void)imgClick:(UITapGestureRecognizer *)tap {    
    self.imgClick(self.model);
}

@end
