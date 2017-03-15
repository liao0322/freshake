//
//  FSCouponsDetailView.m
//  BuyVegetablesTreasure
//
//  Created by 江玉元 on 2016/12/22.
//  Copyright © 2016年 c521xiong. All rights reserved.
//

#import "FSCouponsDetailView.h"

@interface FSCouponsDetailView ()

@property (nonatomic, strong) UILabel *priceLabel;

@property (nonatomic, strong) UILabel *guiZeLabel;

@property (nonatomic, strong) UILabel *timeLabel;

@property (nonatomic, strong) UILabel *explainLabel;

@property (nonatomic, strong) UILabel *conditionLabel;

@end

@implementation FSCouponsDetailView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self createView];
    }
    return self;
}

- (void)createView {
    
    self.backgroundColor = [UIColor colorWithHexString:@"0xdf3c5c"];
    
    // 顶部图片
    UIImage *headImg = [IMAGE(@"FS优惠券字") imageCompressForTargetWidth:ScreenWidth];
    UIImageView *headImgView = [[UIImageView alloc] initWithImage:headImg];
    [self addSubview:headImgView];
    
    headImgView.sd_layout
    .topEqualToView(self)
    .leftEqualToView(self)
    .widthIs(ScreenWidth)
    .heightIs(190);
    
    // 优惠券背景
    UIImage *couponImg = IMAGE(@"FS详情优惠券");
    UIImageView *couponImgView = [[UIImageView alloc] initWithImage:couponImg];
    couponImgView.frame = CGRectMake(SCREEN_WIDTH == 320 ? 15 : 20, CGRectGetMaxY(headImgView.frame) + 5, SCREEN_WIDTH - 2 * (SCREEN_WIDTH == 320 ? 15 : 20),SCREEN_WIDTH == 320 ? 100 : 120);
    [self addSubview:couponImgView];
    
//    couponImgView.sd_layout
//    .leftSpaceToView(self, SCREEN_WIDTH == 320 ? 15 : 20)
//    .rightSpaceToView(self, SCREEN_WIDTH == 320 ? 15 : 20)
//    .topSpaceToView(headImgView, 5)
//    .widthIs(couponImg.size.width)
//    .heightIs(couponImg.size.height);
    
    // 价格
    self.priceLabel = [UILabel new];
    self.priceLabel.textColor = [UIColor whiteColor];
    self.priceLabel.textAlignment = NSTextAlignmentCenter;
    self.priceLabel.font = [UIFont systemFontOfSize:14.0];
    [couponImgView addSubview:self.priceLabel];
    
    self.priceLabel.sd_layout
    .leftEqualToView(couponImgView)
    .centerYEqualToView(couponImgView)
    .widthIs(SCREEN_WIDTH == 320 ? 100 : 125)
    .heightIs(couponImgView.height);
    
    // 规则说明
    self.guiZeLabel = [UILabel new];
    self.guiZeLabel.font = [UIFont boldSystemFontOfSize:15.0];
    self.guiZeLabel.textAlignment = NSTextAlignmentCenter;
    self.guiZeLabel.textColor = [UIColor whiteColor];
    [couponImgView addSubview:self.guiZeLabel];
    
    self.guiZeLabel.sd_layout
    .leftSpaceToView(couponImgView, couponImgView.width / 2 - 25)
    .rightSpaceToView(couponImgView, 15)
    .topSpaceToView(couponImgView, couponImgView.height / 2 - 30)
    .autoHeightRatio(0);
    
    // 时间标题
    UILabel *timeTitleLabel = [UILabel new];
    timeTitleLabel.text = @"开始时间:\n结束时间:";
    timeTitleLabel.font = [UIFont systemFontOfSize:SCREEN_WIDTH == 320 ? 10.0 : 12.0];
    timeTitleLabel.textColor = [UIColor whiteColor];
    timeTitleLabel.textAlignment = NSTextAlignmentRight;
    [timeTitleLabel setSingleLineAutoResizeWithMaxWidth:100];
    [couponImgView addSubview:timeTitleLabel];
    
    timeTitleLabel.sd_layout
    .leftSpaceToView(couponImgView, couponImgView.width/2 - 25)
    .topSpaceToView(self.guiZeLabel, 10)
    .autoHeightRatio(0);
    
    // 有效时间
    self.timeLabel = [UILabel new];
    self.timeLabel.numberOfLines = 0;
    self.timeLabel.font = [UIFont systemFontOfSize:SCREEN_WIDTH == 320 ? 10.0 : 12.0];
    self.timeLabel.textColor = [UIColor whiteColor];
    [couponImgView addSubview:self.timeLabel];
    
    self.timeLabel.sd_layout
    .leftSpaceToView(timeTitleLabel, 5)
    .rightSpaceToView(couponImgView, 5)
    .topSpaceToView(self.guiZeLabel, 10)
    .autoHeightRatio(0);
    
    // 使用说明背景
    UIImage *explainImg = IMAGE(@"FS椭圆");
    UIImageView *explainBgView = [[UIImageView alloc] initWithImage:explainImg];
    explainBgView.frame = CGRectMake(SCREEN_WIDTH == 320 ? 15 : 20, CGRectGetMaxY(couponImgView.frame) + 10, SCREEN_WIDTH - 2 * (SCREEN_WIDTH == 320 ? 15 : 20), SCREEN_HEIGHT - 84 - CGRectGetHeight(headImgView.frame) - CGRectGetHeight(couponImgView.frame));
    [self addSubview:explainBgView];
    
//    explainBgView.sd_layout
//    .leftSpaceToView(self, 20)
//    .rightSpaceToView(self, 45)
//    .topSpaceToView(couponImgView, 10)
//    .widthIs(explainImg.size.width)
//    .heightIs(explainImg.size.height);
    
    // 使用说明标题
    UILabel *explainTitle = [UILabel new];
    explainTitle.text = @"使用说明";
    explainTitle.frame = CGRectMake(25, SCREEN_WIDTH == 320 ? 25 : 45, explainBgView.size.width / 2, 15);
    explainTitle.font = [UIFont systemFontOfSize:12.0];
    explainTitle.textColor = [UIColor whiteColor];
    [explainBgView addSubview:explainTitle];
    
    // 使用说明
    _explainLabel = [UILabel new];
    _explainLabel.font = [UIFont systemFontOfSize:SCREEN_WIDTH == 320 ? 10.0 : 12.0];
    _explainLabel.textColor = [UIColor whiteColor];
    [explainBgView addSubview:_explainLabel];
    
    _explainLabel.sd_layout
    .leftSpaceToView(explainBgView, 25)
    .rightSpaceToView(explainBgView, 20)
    .topSpaceToView(explainTitle, 10)
    .autoHeightRatio(0);
    
    // 使用条件标题
    UILabel *conditionTitle = [UILabel new];
    conditionTitle.text = @"使用条件";
    conditionTitle.font = [UIFont systemFontOfSize:SCREEN_WIDTH == 320 ? 10.0 : 12.0];
    conditionTitle.textColor = [UIColor whiteColor];
    [explainBgView addSubview:conditionTitle];
    
    conditionTitle.sd_layout
    .leftSpaceToView(explainBgView, 25)
    .rightSpaceToView(explainBgView, 20)
    .topSpaceToView(_explainLabel, SCREEN_WIDTH == 320 ? 10 : 15)
    .autoHeightRatio(0);
    
    // 使用条件
    _conditionLabel = [UILabel new];
    _conditionLabel.font = [UIFont systemFontOfSize:SCREEN_WIDTH == 320 ? 10.0 : 12.0];
    _conditionLabel.textColor = [UIColor whiteColor];
    [explainBgView addSubview:_conditionLabel];
    
    _conditionLabel.sd_layout
    .leftSpaceToView(explainBgView, 25)
    .rightSpaceToView(explainBgView, 20)
    .topSpaceToView(conditionTitle, 10)
    .autoHeightRatio(0);
    
    [self setupAutoHeightWithBottomView:explainBgView bottomMargin:10];
}

- (void)setCouponModel:(FSCouponModel *)couponModel {
    NSString *string;
    if ([couponModel.typeId integerValue] == 1) {
        string = [NSString stringWithFormat:@"%@件", couponModel.Price];
    } else {
        string = [NSString stringWithFormat:@"￥%@元", couponModel.Price];
    }
    
    // 价格
    NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc] initWithString:string];
    [attributeString setAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor], NSFontAttributeName : [UIFont boldSystemFontOfSize:(SCREEN_WIDTH == 320 ? 24 : 26)]} range:NSMakeRange(1, couponModel.Price.length)];
    _priceLabel.attributedText = attributeString;
    
    // 使用说明
    _explainLabel.text = couponModel.Remark;
    
    // 使用条件
    _conditionLabel.text = couponModel.XZContent;
    
    // 时间
    _timeLabel.text = [NSString stringWithFormat:@"%@\n%@", couponModel.beginDate, couponModel.ExpileDate];
    
    // 规则
    _guiZeLabel.text = [NSString stringWithFormat:@"满%@元可以使用", couponModel.consumeMoney];
}


@end
