//
//  MyCouponsCell.m
//  BuyVegetablesTreasure
//
//  Created by M on 16/12/6.
//  Copyright © 2016年 c521xiong. All rights reserved.
//

#import "MyCouponsCell.h"

@interface MyCouponsCell ()

@property (nonatomic, strong) UIImageView *leftImgView;
@property (nonatomic, strong) UIImageView *rightImgView;
@property (nonatomic, strong) UIImageView *discountImgView;
@property (nonatomic, strong) UIImageView *selectImgView;
@property (nonatomic, strong) UILabel *priceLabel;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UILabel *couponNameLabel;

@end

@implementation MyCouponsCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {

    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self setupUI];
    }
    
    return self;
}

- (void)setupUI {

    // 左边图片
    UIImage *leftImg = IMAGE(@"优惠券-左");
    self.leftImgView = [[UIImageView alloc] initWithImage:leftImg];
    [self.contentView addSubview:self.leftImgView];
    
    self.leftImgView.sd_layout
    .leftSpaceToView(self.contentView, 15)
    .topEqualToView(self.contentView)
    .widthIs(leftImg.size.width)
    .heightIs(leftImg.size.height);

    // 优惠券图标
    UIImage *discountImg = IMAGE(@"优惠券图标");
    self.discountImgView = [[UIImageView alloc] initWithImage:discountImg];
    [self.leftImgView addSubview:self.discountImgView];
    
    self.discountImgView.sd_layout
    .centerXEqualToView(self.leftImgView)
    .centerYEqualToView(self.leftImgView)
    .widthIs(discountImg.size.width)
    .heightIs(discountImg.size.height);

    // 价格
    self.priceLabel = [UILabel new];
    self.priceLabel.textColor = Color;
    self.priceLabel.textAlignment = NSTextAlignmentCenter;
    self.priceLabel.font = [UIFont boldSystemFontOfSize:14];
    self.priceLabel.textColor = Color;
    [self.leftImgView addSubview:self.priceLabel];
    
    self.priceLabel.sd_layout
    .centerXEqualToView(self.leftImgView)
    .centerYEqualToView(self.leftImgView)
    .widthIs(leftImg.size.width)
    .heightIs(leftImg.size.height);
    
    // 右边图片
    UIImage *rightImg = IMAGE(@"优惠券-右");
    self.rightImgView = [[UIImageView alloc] initWithImage:rightImg];
    [self.contentView addSubview:self.rightImgView];
    
    self.rightImgView.sd_layout
    .leftSpaceToView(self.leftImgView, 0)
    .rightSpaceToView(self.contentView, 13)
    .topEqualToView(self.contentView)
    .heightIs(leftImg.size.height);
    
    // 标题
    UILabel *timeTitleLabel = [UILabel new];
    timeTitleLabel.text = @"开始时间:\n结束时间:";
    timeTitleLabel.font = [UIFont systemFontOfSize:11];
    timeTitleLabel.textColor = [UIColor colorWithHexString:@"0x606060"];
    timeTitleLabel.textAlignment = NSTextAlignmentRight;
    [timeTitleLabel setSingleLineAutoResizeWithMaxWidth:100];
    [self.rightImgView addSubview:timeTitleLabel];
    
    timeTitleLabel.sd_layout
    .leftSpaceToView(self.rightImgView, 15)
    .centerYEqualToView(self.rightImgView)
    .autoHeightRatio(0);
    
    // 有效时间
    self.timeLabel = [UILabel new];
    self.timeLabel.numberOfLines = 0;
    self.timeLabel.font = [UIFont systemFontOfSize:11];
    self.timeLabel.textColor = [UIColor colorWithHexString:@"0x606060"];
    [self.rightImgView addSubview:self.timeLabel];
    
    self.timeLabel.sd_layout
    .leftSpaceToView(timeTitleLabel, 5)
    .rightSpaceToView(self.rightImgView, 5)
    .centerYEqualToView(self.rightImgView)
    .autoHeightRatio(0);
    
    // 商品昵称
    self.couponNameLabel = [UILabel new];
    self.couponNameLabel.font = [UIFont boldSystemFontOfSize:14];
    self.couponNameLabel.textColor = [UIColor colorWithHexString:@"0x3c3c3c"];
    [self.rightImgView addSubview:self.couponNameLabel];
    
    self.couponNameLabel.sd_layout
    .leftSpaceToView(self.rightImgView, 15)
    .rightSpaceToView(self.rightImgView, 15)
    .bottomSpaceToView(self.timeLabel, 5)
    .heightIs(15);
    
    // 说明
    self.titleLabel = [UILabel new];
    self.titleLabel.font = [UIFont boldSystemFontOfSize:12];
    [self.rightImgView addSubview:self.titleLabel];
    
    self.titleLabel.sd_layout
    .leftSpaceToView(self.rightImgView, 15)
    .rightSpaceToView(self.rightImgView, 15)
    .topSpaceToView(self.timeLabel, 5)
    .autoHeightRatio(0);
    
    // 选中
    UIImage *selectImg = IMAGE(@"选中背景");
    self.selectImgView = [UIImageView new];
    self.selectImgView.image = selectImg;
    [self.rightImgView addSubview:self.selectImgView];
    
    self.selectImgView.sd_layout
    .rightSpaceToView(self.rightImgView, 15)
    .centerYEqualToView(self.rightImgView)
    .widthIs(selectImg.size.width)
    .heightIs(selectImg.size.height);
    
    [self setupAutoHeightWithBottomView:self.leftImgView bottomMargin:0];
}

- (void)setModel:(CouponModel *)model {
    
    if (![model.hasLingQu boolValue] &&
        ([model.IsExpileDate boolValue] || [model.IsExpileDate intValue] == 2))
    {
        self.titleLabel.text = @"未使用";
        self.titleLabel.textColor = [UIColor colorWithHexString:@"0xfb9523"];
    }
    else {
        
        self.couponNameLabel.text = model.TickName;
        self.titleLabel.text = [model.hasLingQu boolValue] ? @"已使用" : @"已过期";
        self.titleLabel.textColor = [UIColor colorWithHexString:@"0x767676"];
    }
    
    self.selectImgView.hidden = model.isSelect ? NO : YES;
    self.priceLabel.hidden = [model.typeId intValue] == 1 ? YES : NO;
    self.discountImgView.hidden = [model.typeId intValue] == 1 ? NO : YES;
    
    self.timeLabel.text = [NSString stringWithFormat:@"%@\n%@", model.beginDate, model.ExpileDate];
    self.couponNameLabel.text = [NSString stringWithFormat:@"%@ 满%@元使用",model.TickName, model.consumeMoney];
    
    [self setAttributedStringWithString:model.Price textColor:self.priceLabel.textColor];
}

- (void)setAttributedStringWithString:(NSString *)string
                            textColor:(UIColor *)color
{
    NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"￥%@元",string]];
    [attributeString setAttributes:@{NSForegroundColorAttributeName : color,
                                     NSFontAttributeName : [UIFont boldSystemFontOfSize:25]}
                             range:NSMakeRange(1, string.length)];
    self.priceLabel.attributedText = attributeString;
}

@end
