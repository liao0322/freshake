//
//  AmountCell.m
//  BuyVegetablesTreasure
//
//  Created by M on 16/11/28.
//  Copyright © 2016年 c521xiong. All rights reserved.
//

#import "AmountCell.h"

@interface AmountCell ()

// 背景图片
@property (nonatomic, strong) UIImageView *bgImgView;
// 价格
@property (nonatomic, strong) UILabel *priceLabel;
// 留言
@property (nonatomic, strong) UILabel *remarkLabel;

@end

@implementation AmountCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self initCell];
    }
    
    return self;
}

- (void)initCell {
    
    self.bgImgView = [UIImageView new];
    self.bgImgView.userInteractionEnabled = YES;
    [self.contentView addSubview:self.bgImgView];
    
    self.bgImgView.sd_layout
    .leftSpaceToView(self.contentView, 10)
    .rightSpaceToView(self.contentView, 10)
    .topEqualToView(self.contentView)
    .heightIs((ScreenWidth - 20) / 2);
    
    UIView *bgView = [UIView new];
    bgView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.2];
    [self.bgImgView addSubview:bgView];
    
    bgView.sd_layout
    .leftEqualToView(self.bgImgView)
    .rightEqualToView(self.bgImgView)
    .bottomEqualToView(self.bgImgView)
    .heightIs(55);
    
    self.remarkLabel = [UILabel new];
    self.remarkLabel.font = [UIFont systemFontOfSize:13];
    self.remarkLabel.textColor = [UIColor whiteColor];
    [bgView addSubview:self.remarkLabel];
    
    self.remarkLabel.sd_layout
    .heightIs(15)
    .leftSpaceToView(bgView, 15)
    .rightSpaceToView(bgView, 15)
    .bottomSpaceToView(bgView, 10);
    
    self.priceLabel = [UILabel new];
    self.priceLabel.font = [UIFont systemFontOfSize:14];
    self.priceLabel.textColor = [UIColor whiteColor];
    [bgView addSubview:self.priceLabel];
    
    self.priceLabel.sd_layout
    .heightIs(15)
    .leftSpaceToView(bgView, 15)
    .rightSpaceToView(bgView, 15)
    .bottomSpaceToView(self.remarkLabel, 5);
    
    [self setupAutoHeightWithBottomView:self.bgImgView bottomMargin:0];
}

- (void)setModel:(AmountModel *)model {
    
    if ([model.type intValue] == 0) {
        self.remarkLabel.text = [NSString stringWithFormat:@"赠送%.2f元、%@",[model.giveCash floatValue], model.strName];
    }
    else if ([model.type intValue] == 1) {
        self.remarkLabel.text = [NSString stringWithFormat:@"赠送%.2f元",[model.giveCash floatValue]];
    }
    else {
        self.remarkLabel.text = [NSString stringWithFormat:@"赠送%@",model.strName];
    }
    
    self.priceLabel.text = [NSString stringWithFormat:@"充值%.2f元",[model.total_fee floatValue]];
    [self.bgImgView sd_setImageWithURL:[NSURL URLWithString:model.rimage]
                      placeholderImage:IMAGE(@"ErrorBackImage")];
}

@end
