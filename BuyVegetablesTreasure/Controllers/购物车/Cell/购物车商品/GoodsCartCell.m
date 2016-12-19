//
//  GoodsCartCell.m
//  BuyVegetablesTreasure
//
//  Created by M on 16/4/22.
//  Copyright © 2016年 c521xiong. All rights reserved.
//

#import "GoodsCartCell.h"

@implementation GoodsCartCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
 
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self initCell];
    }
    
    return self;
}

- (void)initCell {
    
    UIImage *img = IMAGE(@"没有选择");
    _isDelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _isDelBtn.frame = CGRectMake(0, 0, img.size.width + 30, 110);
    _isDelBtn.selected = YES;
    [_isDelBtn setImage:IMAGE(@"没有选择") forState:UIControlStateNormal];
    [_isDelBtn setImage:IMAGE(@"购物车-选择") forState:UIControlStateSelected];
    [_isDelBtn addTarget:self action:@selector(selectGoods) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_isDelBtn];
    
    // 商品图片
    _goodsImageView = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_isDelBtn.frame), 15, 80, 80)];
    _goodsImageView.image = IMAGE(@"列表页未成功图片");
    [self.contentView addSubview:_goodsImageView];
    
    // 商品名称
    _goodsNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_goodsImageView.frame) + 10, 20, ScreenWidth - CGRectGetMaxX(_goodsImageView.frame) - 30, 15)];
    _goodsNameLabel.font = [UIFont systemFontOfSize:14];
    _goodsNameLabel.textColor = [UIColor blackColor];
    _goodsNameLabel.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:_goodsNameLabel];
    
    // 商品价格
    _goodsPriceLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_goodsImageView.frame) + 10, CGRectGetMaxY(_goodsNameLabel.frame) + 10, ScreenWidth - CGRectGetMaxX(_goodsImageView.frame) - 30, 15)];
    _goodsPriceLabel.font = [UIFont systemFontOfSize:16];
    _goodsPriceLabel.textColor = Color;
    _goodsPriceLabel.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:_goodsPriceLabel];
    
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(ScreenWidth - 100, CGRectGetMaxY(_goodsPriceLabel.frame) + 5, 90, 30)];
    [self addSubview:bgView];
    
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
    
    UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(0, 109.5, ScreenWidth, 0.5)];
    line.backgroundColor = [UIColor colorWithHexString:@"0xD5D5D5"];
    [self addSubview:line];
}

- (void)selectGoods {
    
    _btnClick();
}

- (void)goodsNumber:(UIButton *)btn {
    
    UIButton *goodsNumberBtn = (UIButton *)[self viewWithTag:11];
    
    BOOL isAdd = btn.tag == 10 ? NO : YES;
    BOOL isDel = [goodsNumberBtn.titleLabel.text integerValue] - 1 == 0 || [goodsNumberBtn.titleLabel.text integerValue] == 0 ? YES : NO;
    
    NSInteger goodsNumber = [goodsNumberBtn.titleLabel.text integerValue];
    _goodsNumberBlock(goodsNumber, isDel, isAdd);
}

- (void)setModel:(ShopCart *)model {
    
    UIButton *goodsNumberBtn = (UIButton *)[self viewWithTag:11];
    [goodsNumberBtn setTitle:[NSString stringWithFormat:@"%zd",[model.productNum integerValue]] forState:UIControlStateNormal];
    
    _isDelBtn.selected = !model.isSelect;
    _goodsNameLabel.text = model.productName;
    _goodsPriceLabel.text = [NSString stringWithFormat:@"￥%.2f",[model.salePrice floatValue]];
    [_goodsImageView sd_setImageWithURL:[NSURL URLWithString:model.thumbnailsUrll] placeholderImage:IMAGE(@"列表页未成功图片")];
}

@end
