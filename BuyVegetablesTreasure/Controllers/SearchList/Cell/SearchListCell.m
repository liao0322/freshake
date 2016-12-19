//
//  SearchListCell.m
//  BuyVegetablesTreasure
//
//  Created by sc on 15/11/5.
//  Copyright © 2015年 c521xiong. All rights reserved.
//

#import "SearchListCell.h"
#import "UIImageView+WebCache.h"

@implementation SearchListCell

- (void)setModel:(SearchModel *)model
{
    self.backgroundColor = [UIColor whiteColor];
    
    _goddsNumLabel.text = model.CartNum;
    _stock = model.stock;
    _goodsId = model.id;
//    _originalPriceLabel.text = model.marketPrice;
    _salesLabel.text = [NSString stringWithFormat:@"已销售%@",model.SoldStock];
    
    [_goodsImage sd_setImageWithURL:[NSURL URLWithString:model.imgUrl] placeholderImage:IMAGE(@"列表页未成功图片")];
    _goodsImage.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap:)];
    
    NSString *tagString = [model.id stringByReplacingOccurrencesOfString:@"," withString:@""];
    _goodsImage.tag = [tagString integerValue];
    [_goodsImage addGestureRecognizer:tap];
    
    _goodsNameLabel.text = model.productName;
    _originalPriceLabel.text = [NSString stringWithFormat:@"原价 ¥ %.2f",[model.marketPrice floatValue]];
    
    float goodsPrice;
    int group_id = [[[NSUserDefaults standardUserDefaults] objectForKey:@"group_id"] intValue];
    if (group_id > 1) {
        goodsPrice = [model.UserPrice floatValue];
    }
    else {
        goodsPrice = [model.salePrice floatValue];
    }
    
    _goodsPriceLabel.text = [NSString stringWithFormat:@"¥ %.2f",goodsPrice];
    
    CGRect rect = [_originalPriceLabel.text boundingRectWithSize:CGSizeMake(10000, 10) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12]} context:nil];

    CGRect frame = _originalPriceLabel.frame;
    frame.size.width = rect.size.width;
    _originalPriceLabel.frame = frame;
    
    [(UILabel *)[self viewWithTag:1000] removeFromSuperview];
    UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(0, 5, rect.size.width, 1)];
    line.backgroundColor = [UIColor colorWithHexString:@"0x949596"];
    line.tag = 1000;
    [_originalPriceLabel addSubview:line];
}

- (void)tap:(UITapGestureRecognizer *)tap
{
    _imageClick();
}

- (IBAction)editGoodsNum:(UIButton *)sender {
    
    BOOL isEnough = YES;
    BOOL isAdd = sender.tag == 10 ? YES : NO;
    int Num = 0;
    
    if (sender.tag == 10 && [_goddsNumLabel.text integerValue] < 1) {
        
        _goddsNumLabel.text = @"0";
        return;
    }
    
    NSLog(@"_goddsNumLabel = %@",_goddsNumLabel.text);
    
    if ([_goddsNumLabel.text integerValue] >= [_stock integerValue] && isAdd == NO) {
        
        isEnough = NO;
    }
    else {
        
        Num = sender.tag == 10 ? - 1 : 1;
    }
    
    if ([_goddsNumLabel.text integerValue] + Num < 0) {
        return;
    }
    else if([_goddsNumLabel.text integerValue] >= 99 && Num == 1) {
        return;
    }
    
    NSLog(@"Num = %zd",Num);
    _goodsNumBlock([NSString stringWithFormat:@"%zd",[_goddsNumLabel.text integerValue] + Num],_goodsId,isAdd,isEnough);
}

@end
