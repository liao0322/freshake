//
//  ShoppingCell.m
//  BuyVegetablesTreasure
//
//  Created by sc on 15/10/19.
//  Copyright (c) 2015年 c521xiong. All rights reserved.
//

#import "ShoppingCell.h"

#import "UIImageView+WebCache.h"

@implementation ShoppingCell

- (void)setGoodsModel:(RightGoodsModel *)model{
    
    _goodsId = model.id;
    
    _stock = model.stock;
    
    _goddsNumLabel.text = model.CartNum;
    
    _goodsCountLabel.text = model.shortDesc;
    
    // 设置图片
    [_goodsImage sd_setImageWithURL:[NSURL URLWithString:model.imgUrl] placeholderImage:[UIImage imageNamed:@"列表页未成功图片"]];
    
    // 商品名字
    _goodsNameLabel.text = model.productName;
        
    // 商品价格
    _goodsPriceLabel.text = [NSString stringWithFormat:@"￥%.2f",[model.salePrice floatValue]];

    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
    [_goodsImage addGestureRecognizer:tap];
}

- (void)tap:(UITapGestureRecognizer *)tap {
    
    UIImageView *imageView = (UIImageView *)tap.view;
    _imageClick(imageView.tag);
}

- (IBAction)editGoodsNum:(UIButton *)sender {
    
    BOOL isEnough = YES;
    BOOL isAdd = sender.tag == 10 ? YES : NO;
    int Num = 0;

    if ([_goddsNumLabel.text integerValue] >= [_stock integerValue] && isAdd == NO) {
        
        isEnough = NO;
    }
    else {
        
        Num = sender.tag == 10 ? - 1 : 1;
    }
    
    
    if ([_goddsNumLabel.text integerValue] <= 0 && Num == -1) {
        return;
    }
    else if([_goddsNumLabel.text integerValue] >= 99 && Num == 1) {
        return;
    }

    _goodsBlock([NSString stringWithFormat:@"%zd",[_goddsNumLabel.text integerValue] + Num],_goodsId,isAdd,isEnough);
}

@end
