//
//  GoodsDetailCell.m
//  VegetablesApp
//
//  Created by M on 16/5/31.
//  Copyright © 2016年 M. All rights reserved.
//

#import "GoodsDetailCell.h"

@interface GoodsDetailCell ()

@property (nonatomic, strong) SDCycleScrollView *goodsImgScrollView;
@property (nonatomic, strong) UILabel *goodsNameLabel;
@property (nonatomic, strong) UILabel *goodsIntroduce;
@property (nonatomic, strong) UILabel *specialOfferContextLabel;
@property (nonatomic, strong) UILabel *promotionLabel;

@end

@implementation GoodsDetailCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {

    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self initGoodsDetailCell];
    }
    
    return self;
}

- (void)initGoodsDetailCell {
    
    // 商品图片
    _goodsImgScrollView = [[SDCycleScrollView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenWidth / 4 * 3)];
    _goodsImgScrollView.dotColor = Color;
    _goodsImgScrollView.placeholderImage = IMAGE(@"BannerError");
    _goodsImgScrollView.localizationImagesGroup = @[IMAGE(@"BannerError")];
    _goodsImgScrollView.layer.borderColor = [UIColor colorWithHexString:@"0xe3e3e3"].CGColor;
    _goodsImgScrollView.layer.borderWidth = 0.5;
    [self addSubview:_goodsImgScrollView];
    
    // 商品名
    _goodsNameLabel = [UILabel new];
    _goodsNameLabel.font = [UIFont boldSystemFontOfSize:16];
    _goodsNameLabel.textColor = [UIColor colorWithHexString:@"0x333333"];
    _goodsNameLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:_goodsNameLabel];
    
    _goodsNameLabel.sd_layout
    .leftSpaceToView(self.contentView, 15)
    .rightSpaceToView(self.contentView, 15)
    .topSpaceToView(_goodsImgScrollView, 21)
    .autoHeightRatio(0);
    
    // 商品介绍
    _goodsIntroduce = [UILabel new];
    _goodsIntroduce.font = [UIFont systemFontOfSize:14];
    _goodsIntroduce.textColor = [UIColor colorWithHexString:@"0x999999"];
    _goodsIntroduce.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:_goodsIntroduce];
    
    _goodsIntroduce.sd_layout
    .leftSpaceToView(self.contentView, 15)
    .rightSpaceToView(self.contentView, 15)
    .topSpaceToView(_goodsNameLabel, 15)
    .autoHeightRatio(0);
    
    // 价格View
    UIView *priceView = [UIView new];
    [self.contentView addSubview:priceView];
    
    priceView.sd_layout
    .leftEqualToView(self.contentView)
    .rightEqualToView(self.contentView)
    .topSpaceToView(_goodsIntroduce, 15)
    .heightIs(50);
    
    // 价格
    for (int i = 0; i < 2; i++) {
        
        UILabel *priceLabel = [UILabel new];
        priceLabel.tag = i + 10;
        priceLabel.textAlignment = NSTextAlignmentCenter;
        [priceView addSubview:priceLabel];
        
        priceLabel.sd_layout
        .topSpaceToView(priceView, 25 * i)
        .heightIs(25)
        .leftSpaceToView(priceView, 15)
        .rightSpaceToView(priceView, 15);
        
        if (i == 0) {
            
            priceLabel.font = [UIFont systemFontOfSize:22];
            priceLabel.textColor = Color;
        }
        else {
            
            priceLabel.font = [UIFont systemFontOfSize:14];
            priceLabel.textColor = [UIColor colorWithHexString:@"0x606060"];
        }
    }
    
    // 特价信息
    _specialOfferContextLabel = [UILabel new];
    _specialOfferContextLabel.font = [UIFont systemFontOfSize:14];;
    _specialOfferContextLabel.textColor = [UIColor colorWithHexString:@"0x606060"];
    _specialOfferContextLabel.textAlignment = NSTextAlignmentCenter;
    [_specialOfferContextLabel setSingleLineAutoResizeWithMaxWidth:200];
    [self.contentView addSubview:_specialOfferContextLabel];
    
    _specialOfferContextLabel.sd_layout
    .centerXEqualToView(self.contentView)
    .topSpaceToView(priceView, 10)
    .heightIs(15);
    
    // 促销活动
    _promotionLabel = [UILabel new];
    _promotionLabel.hidden = YES;
    _promotionLabel.text = @"促销";
    _promotionLabel.font = [UIFont systemFontOfSize:13];
    _promotionLabel.textColor = Color;
    _promotionLabel.textAlignment = NSTextAlignmentCenter;
    _promotionLabel.layer.borderColor = Color.CGColor;
    _promotionLabel.layer.borderWidth = 0.5;
    _promotionLabel.layer.cornerRadius = 12.5;
    _promotionLabel.layer.masksToBounds = YES;
    [self.contentView addSubview:_promotionLabel];
    
    _promotionLabel.sd_layout
    .rightSpaceToView(_specialOfferContextLabel, 10)
    .centerYEqualToView(_specialOfferContextLabel)
    .widthIs(45)
    .heightIs(25);
    
    UILabel *titleLable;
    NSArray *titles = @[@"产品规格",@"存储方式",@"库存"];
    for (int i = 0; i < 3; i++) {
        
        UILabel *nameLabel = [UILabel new];
        nameLabel.tag = i + 5;
        nameLabel.font = [UIFont systemFontOfSize:13];
        nameLabel.textColor = [UIColor colorWithHexString:@"0x333333"];
        nameLabel.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:nameLabel];
        
        nameLabel.sd_layout
        .leftSpaceToView(self.contentView, ScreenWidth / 3 * i)
        .topSpaceToView(_specialOfferContextLabel, 10)
        .widthIs(ScreenWidth / 3)
        .heightIs(15);
        
        titleLable = [UILabel new];
        titleLable.text = titles[i];
        titleLable.font = [UIFont systemFontOfSize:13];
        titleLable.textColor = [UIColor colorWithHexString:@"0x999999"];
        titleLable.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:titleLable];
        
        titleLable.sd_layout
        .leftSpaceToView(self.contentView, ScreenWidth / 3 * i)
        .topSpaceToView(nameLabel, 2)
        .widthIs(ScreenWidth / 3)
        .heightIs(15);
        
        if (i == 1) {
            
            for (int a = 0; a < 2; a++) {
                
                UILabel *line = [UILabel new];
                line.backgroundColor = [UIColor colorWithHexString:@"0xd7d7d7"];
                [nameLabel addSubview:line];
                
                line.sd_layout
                .leftSpaceToView(nameLabel, a * (ScreenWidth / 3 - 1))
                .topSpaceToView(nameLabel, 0)
                .heightIs(32)
                .widthIs(0.5);
            }
        }
    }
    
    UILabel *line = [UILabel new];
    line.backgroundColor = [UIColor colorWithHexString:@"0xd7d7d7"];;
    [self.contentView addSubview:line];
    
    line.sd_layout
    .leftSpaceToView(self.contentView, 0)
    .rightSpaceToView(self.contentView, 0)
    .topSpaceToView(titleLable, 10)
    .heightIs(0.5);
    
    [self setupAutoHeightWithBottomView:titleLable bottomMargin:10];
}

- (void)setDetailsModel:(Pruduct *)detailsModel {

    // 商品价格
    for (int i = 0; i < 2; i++) {
        
        NSRange range;
        UIFont *font;
        NSString *priceString;
        UILabel *priceLabel = (UILabel *)[self viewWithTag:i + 10];
        
        if (i == 0) {
            priceString = [NSString stringWithFormat:@"¥ %.2f",[detailsModel.salePrice floatValue]];
            range = NSMakeRange(2, priceString.length - 2);
            font = [UIFont boldSystemFontOfSize:28];
            
            priceLabel.attributedText = [self setAttributedText:priceString
                                                           Font:font
                                                          color:priceLabel.textColor
                                                          range:range];
        }
        else {
            priceLabel.text = [NSString stringWithFormat:@"会员价 ¥%.2f",[detailsModel.UserPrice floatValue]];
        }
    }
    
    // 商品图片
    if (detailsModel.albums.count > 0) {
    
        NSMutableArray *imgArr = [NSMutableArray array];
        for (int i = 0; i < detailsModel.albums.count; i++) {
            
            NSString *imgString = LMMC(detailsModel.albums[i][@"original_path"]);
            [imgArr addObject:imgString];
        }
        
        _goodsImgScrollView.imageURLStringsGroup = imgArr;
    }
    
    if (IsBlankString(detailsModel.specialOfferContext)) {
        
        _specialOfferContextLabel.hidden = YES;
        _promotionLabel.hidden = YES;
    }
    else {
        
        _specialOfferContextLabel.hidden = NO;
        _promotionLabel.hidden = NO;
    }

    // 名称
    _goodsNameLabel.text = detailsModel.productName;
    // 简介
    _goodsIntroduce.text = detailsModel.shortDesc;
    // 特价信息
    _specialOfferContextLabel.text = detailsModel.specialOfferContext;
    
    NSString *unitString = [NSString stringWithFormat:@"%@",detailsModel.unit];
    NSString *stockString = [NSString stringWithFormat:@"%@",detailsModel.stock];
    NSString *storageString = [NSString stringWithFormat:@"%@",detailsModel.storage];
    NSArray *arr = @[unitString,storageString,stockString];
    for (int i = 0; i < arr.count; i++) {
        
        NSString *string = [NSString stringWithFormat:@"%@",arr[i]];
        [(UILabel *)[self viewWithTag:i + 5] setText:string];
    }
}

/**
 *  设置字体属性
 *
 *  @param text  文本
 *  @param font  字体大小
 *  @param color 字体颜色
 *  @param range 范围
 */
- (NSMutableAttributedString *)setAttributedText:(NSString *)text
                                            Font:(UIFont *)font
                                           color:(UIColor *)color
                                           range:(NSRange)range
{
    NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc] initWithString:text];
    [attributeString setAttributes:@{NSForegroundColorAttributeName : color, NSFontAttributeName : font} range:range];
    return attributeString;
}

@end
