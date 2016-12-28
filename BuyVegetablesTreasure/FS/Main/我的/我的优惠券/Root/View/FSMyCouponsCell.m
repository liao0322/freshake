//
//  FSMyCouponsCell.m
//  BuyVegetablesTreasure
//
//  Created by 江玉元 on 2016/12/21.
//  Copyright © 2016年 c521xiong. All rights reserved.
//

#import "FSMyCouponsCell.h"

@interface FSMyCouponsCell ()

@property (nonatomic, strong) UIImageView *bgImgView;
@property (nonatomic, strong) UIImageView *selectImgView;
@property (nonatomic, strong) UIImageView *discountImgView;
@property (nonatomic, strong) UILabel *priceLabel;
@property (nonatomic, strong) UILabel *couponNameLabel;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UILabel *guiZeLabel;
@end

@implementation FSMyCouponsCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createUI];
    }
    
    return self;
}

- (void)createUI {
    self.bgImgView = [UIImageView new];
    self.bgImgView.frame = CGRectMake(SCREEN_WIDTH == 320 ? 15 : 20, 0, SCREEN_WIDTH - 2 * (SCREEN_WIDTH == 320 ? 15 : 20), 120);
    [self.contentView addSubview:self.bgImgView];
    
//    self.bgImgView.sd_layout
//    .leftSpaceToView(self.contentView, 15)
//    .topEqualToView(self.contentView)
//    .widthIs(ScreenWidth - 30)
//    .heightIs(120);
    
    // 优惠券图标
    UIImage *discountImg = IMAGE(@"优惠券图标");
    self.discountImgView = [[UIImageView alloc] initWithImage:discountImg];
    [self.bgImgView addSubview:self.discountImgView];
    
    self.discountImgView.sd_layout
    .leftSpaceToView(self.bgImgView, 15)
    .centerYEqualToView(self.bgImgView)
    .widthIs(discountImg.size.width)
    .heightIs(discountImg.size.height);
    
    // 价格
    self.priceLabel = [UILabel new];
    self.priceLabel.textAlignment = NSTextAlignmentCenter;
    self.priceLabel.font = [UIFont boldSystemFontOfSize:SCREEN_WIDTH == 320 ? 17 : 19];
    [self.bgImgView addSubview:self.priceLabel];
    
    self.priceLabel.sd_layout
    .leftEqualToView(self.bgImgView)
    .centerYEqualToView(self.bgImgView)
    .widthIs(SCREEN_WIDTH == 320 ? 100 : 125)
    .heightIs(self.bgImgView.height);
    
    // 优惠券名称
    self.couponNameLabel = [UILabel new];
    self.couponNameLabel.frame = CGRectMake(self.bgImgView.width / 2 - 30, 35, self.bgImgView.width - CGRectGetWidth(_priceLabel.frame), 16);
    self.couponNameLabel.font = [UIFont boldSystemFontOfSize:SCREEN_WIDTH == 320 ? 13 : 15];
    [self.bgImgView addSubview:self.couponNameLabel];
    

    
    // 时间标题
    UILabel *timeTitleLabel = [UILabel new];
    timeTitleLabel.text = @"有效期:\n至:";
    timeTitleLabel.font = [UIFont systemFontOfSize:10];
    timeTitleLabel.textColor = [UIColor colorWithHexString:@"0xb2b2b2"];
    timeTitleLabel.textAlignment = NSTextAlignmentRight;
    [timeTitleLabel setSingleLineAutoResizeWithMaxWidth:100];
    [self.bgImgView addSubview:timeTitleLabel];
    
    timeTitleLabel.sd_layout
    .leftSpaceToView(self.bgImgView, self.bgImgView.width/2 - 20)
    .topSpaceToView(self.couponNameLabel, 10)
    .autoHeightRatio(0);
    
    // 有效时间
    self.timeLabel = [UILabel new];
    self.timeLabel.numberOfLines = 0;
    self.timeLabel.font = [UIFont systemFontOfSize:10];
    self.timeLabel.textColor = [UIColor colorWithHexString:@"0xb2b2b2"];
    [self.bgImgView addSubview:self.timeLabel];
    
    self.timeLabel.sd_layout
    .leftSpaceToView(timeTitleLabel, 5)
    .rightSpaceToView(self.bgImgView, 5)
    .topSpaceToView(self.couponNameLabel, 10)
    .autoHeightRatio(0);
    
    //    self.couponNameLabel.sd_layout
//    .leftSpaceToView(self.bgImgView, self.bgImgView.width/2 - 20)
//    .rightSpaceToView(self.bgImgView, 15)
//    .bottomSpaceToView(self.timeLabel, 15)
//    .heightIs(16);
    
    // 规则说明
    self.guiZeLabel = [UILabel new];
    self.guiZeLabel.font = [UIFont boldSystemFontOfSize:14.0];
    [self.bgImgView addSubview:self.guiZeLabel];
    
    self.guiZeLabel.sd_layout
    .leftSpaceToView(self.bgImgView, self.bgImgView.width/2 - 20)
    .rightSpaceToView(self.bgImgView, 15)
    .topSpaceToView(self.timeLabel, 6)
    .heightIs(15);
    
    // 选中
    UIImage *selectImg = IMAGE(@"选中背景");
    self.selectImgView = [UIImageView new];
    self.selectImgView.image = selectImg;
    [self.bgImgView addSubview:self.selectImgView];
    
    self.selectImgView.sd_layout
    .rightSpaceToView(self.bgImgView, 15)
    .centerYEqualToView(self.bgImgView)
    .widthIs(selectImg.size.width)
    .heightIs(selectImg.size.height);
    
    [self setupAutoHeightWithBottomView:self.bgImgView bottomMargin:0];
    
}

- (void)setModel:(CouponModel *)model {
    if (![model.hasLingQu boolValue] && ([model.IsExpileDate boolValue] || [model.IsExpileDate intValue] == 2)) {
        UIImage *bgImage = IMAGE(@"FS优惠券");
       // self.bgImgView = [[UIImageView alloc] initWithImage:bgImage];
        self.bgImgView.image = bgImage;
        self.priceLabel.textColor = [UIColor colorOrange];
        self.guiZeLabel.textColor = [UIColor colorOrange];
        self.couponNameLabel.textColor = [UIColor colorWithHexString:@"0x404040"];

    }else {
        UIImage *bgImage = IMAGE(@"FS优惠券-已失效");
        //self.bgImgView = [[UIImageView alloc] initWithImage:bgImage];
        self.bgImgView.image = bgImage;
        self.priceLabel.textColor = [UIColor colorWithHexString:@"0xb2b2b2"];
        self.guiZeLabel.hidden = YES;
        self.couponNameLabel.textColor = [UIColor colorWithHexString:@"0xb2b2b2"];
    }
    
    self.selectImgView.hidden = model.isSelect ? NO : YES;
    self.priceLabel.hidden = [model.typeId intValue] == 1 ? YES : NO;
    self.discountImgView.hidden = [model.typeId intValue] == 1 ? NO : YES;
    
    self.timeLabel.text = [NSString stringWithFormat:@"%@\n%@", model.beginDate,model.ExpileDate];
    self.couponNameLabel.text = [NSString stringWithFormat:@"%@", model.TickName];
    self.guiZeLabel.text = [NSString stringWithFormat:@"满%@元使用",model.consumeMoney];
    [self setAttributtedStringWithString:model.Price textColor:self.priceLabel.textColor];
}

- (void)setAttributtedStringWithString:(NSString *)string textColor:(UIColor *)color {
    NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"¥%@元",string]];
    [attributeString setAttributes:@{NSForegroundColorAttributeName : color, NSFontAttributeName : [UIFont boldSystemFontOfSize:(SCREEN_WIDTH == 320 ? 36 : 40.0)]} range:NSMakeRange(1, string.length)];
    self.priceLabel.attributedText = attributeString;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
