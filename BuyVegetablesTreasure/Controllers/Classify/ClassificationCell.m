//
//  ClassificationCell.m
//  BuyVegetablesTreasure
//
//  Created by M on 16/4/22.
//  Copyright © 2016年 c521xiong. All rights reserved.
//

#import "ClassificationCell.h"

@implementation ClassificationCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initCell];
    }
    
    return self;
}

- (void)initCell {
    
    int width = isPad ? 200 : 100;
    
    // 商品图片
    _goodsImageView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 15, 80, 80)];
    _goodsImageView.image = IMAGE(@"列表页未成功图片");
    _goodsImageView.userInteractionEnabled = YES;
    [self.contentView addSubview:_goodsImageView];
    
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
    [_goodsImageView addGestureRecognizer:tap];
    
    // 商品名称
    _goodsNameLabel = [UILabel new];
    _goodsNameLabel.font = [UIFont systemFontOfSize:14];
    _goodsNameLabel.textColor = [UIColor blackColor];
    _goodsNameLabel.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:_goodsNameLabel];
    
    _goodsNameLabel.sd_layout
    .rightSpaceToView(self.contentView, 15)
    .topSpaceToView(self.contentView, 15)
    .leftSpaceToView(_goodsImageView, 10)
    .heightIs(15);
    
/*
    // 商品介绍
    _goodsShortDescLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_goodsImageView.frame) + 10, CGRectGetMaxY(_goodsNameLabel.frame) + 10, ScreenWidth - CGRectGetMaxX(_goodsImageView.frame) - 30 - width, 15)];
    _goodsShortDescLabel.font = [UIFont systemFontOfSize:14];
    _goodsShortDescLabel.textColor = [UIColor blackColor];
    _goodsShortDescLabel.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:_goodsShortDescLabel];
 */
    
    // 商品价格
    _goodsPriceLabel = [UILabel new];
    _goodsPriceLabel.font = [UIFont boldSystemFontOfSize:13];
    _goodsPriceLabel.textColor = [UIColor colorWithHexString:@"0x606060"];
    _goodsPriceLabel.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:_goodsPriceLabel];
    
    _goodsPriceLabel.sd_layout
    .leftSpaceToView(_goodsImageView, 10)
    .rightSpaceToView(self.contentView, 15)
    .topSpaceToView(_goodsNameLabel, 10)
    .heightIs(15);
    
    // 会员价格
    _goodsUserPriceLabel = [UILabel new];
    _goodsUserPriceLabel.font = [UIFont boldSystemFontOfSize:10];
    _goodsUserPriceLabel.textColor = Color;
    _goodsUserPriceLabel.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:_goodsUserPriceLabel];
    
    _goodsUserPriceLabel.sd_layout
    .topSpaceToView(_goodsPriceLabel, 5)
    .leftSpaceToView(_goodsImageView, 10)
    .rightSpaceToView(self.contentView, 15)
    .heightIs(10);
    
    UIView *bgView = [UIView new];
    [self.contentView addSubview:bgView];
    
    bgView.sd_layout
    .rightSpaceToView(self.contentView, 15)
    .topSpaceToView(_goodsUserPriceLabel, 5)
    .widthIs(90)
    .heightIs(30);
    
    for (int i = 0; i < 3; i++) {
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(i * 30, 0, 30, 30);
        button.tag = i + 10;
        [bgView addSubview:button];
        
        if (i != 1) {
            [button setImage:i == 0 ? IMAGE(@"减号") : IMAGE(@"加号") forState:UIControlStateNormal];
            [button addTarget:self action:@selector(goodsNumber:) forControlEvents:UIControlEventTouchUpInside];
        }
        else {
            button.titleLabel.font = [UIFont systemFontOfSize:14];
            [button setTitle:@"0" forState:UIControlStateNormal];
            [button setTitleColor:[UIColor colorWithHexString:@"0x262626"] forState:UIControlStateNormal];
        }
    }
    
    UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(0, 109.5, ScreenWidth - width, 0.5)];
    line.backgroundColor = [UIColor colorWithHexString:@"0xD5D5D5"];
    [self addSubview:line];
}

- (void)tap:(UITapGestureRecognizer *)tap {
    
    _imageClick();
}

- (void)goodsNumber:(UIButton *)btn {
    
    UIButton *goodsNumberBtn = (UIButton *)[self viewWithTag:11];
    
    BOOL isAdd = btn.tag == 10 ? NO : YES;
    if ([_stockString integerValue] < ([goodsNumberBtn.titleLabel.text integerValue] + 1) && isAdd) {
        return [Tools myHud:@"库存不足" inView:self];
    }
    else if ([goodsNumberBtn.titleLabel.text integerValue] == 0 && !isAdd) {
        return;
    }
    
    NSString *goodsNumber = [NSString stringWithFormat:@"%zd",[goodsNumberBtn.titleLabel.text integerValue] + (isAdd ? 1 : -1)];
    _goodsBlock(goodsNumber,_goodsIdString,isAdd,_salePriceString);
}

- (void)setGoodsModel:(RightGoodsModel *)model {
    
    _goodsIdString = model.id;
    _stockString = model.stock;
    _salePriceString = model.salePrice;
    
    _goodsNameLabel.text = model.productName;
    _goodsShortDescLabel.text = model.shortDesc;
    _goodsPriceLabel.text = [NSString stringWithFormat:@"￥%.2f",[model.salePrice floatValue]];
    _goodsUserPriceLabel.text = [NSString stringWithFormat:@"(会员价)￥%.2f",[model.UserPrice floatValue]];
    [(UIButton *)[self viewWithTag:11] setTitle:model.CartNum forState:UIControlStateNormal];
    [_goodsImageView sd_setImageWithURL:[NSURL URLWithString:model.imgUrl] placeholderImage:[UIImage imageNamed:@"列表页未成功图片"]];
}

@end
