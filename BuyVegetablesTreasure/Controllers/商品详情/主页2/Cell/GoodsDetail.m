//
//  GoodsDetail.m
//  BuyVegetablesTreasure
//
//  Created by sc on 16/1/21.
//  Copyright © 2016年 c521xiong. All rights reserved.
//

#import "GoodsDetail.h"

@interface GoodsDetail ()

@property (nonatomic, copy) UIView *bgView;

@end

@implementation GoodsDetail

- (void)setModel:(Pruduct *)model {
    
    [_otherTypesView removeFromSuperview];
    [_bgView removeFromSuperview];
    
    NSMutableArray *imageArray = [NSMutableArray array];
    
    if (model.albums.count > 0) {
        
        for (int i = 0; i < model.albums.count; i++) {
            
            NSString *imageString = [NSString stringWithFormat:@"%@%@",RODUCTINFOPIC,model.albums[i][@"original_path"]];
            [imageArray addObject:imageString];
        }
    }
    
    if (_goodsImageScrollView == nil) {
                
        _goodsImageScrollView = [[SDCycleScrollView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenWidth / 2)];
        _goodsImageScrollView.dotColor = Color;
        _goodsImageScrollView.placeholderImage = IMAGE(@"ErrorBackImage");
        _goodsImageScrollView.imageURLStringsGroup = imageArray;
        [self.contentView addSubview:_goodsImageScrollView];
    }
    else {
        
        _goodsImageScrollView.imageURLStringsGroup = imageArray;
    }
    
    UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 1)];
    line.backgroundColor = [UIColor colorWithHexString:@"0xC9C9C9"];
    [_goodsImageScrollView addSubview:line];
    
    _bgView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_goodsImageScrollView.frame), ScreenWidth, 180)];
    _bgView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:_bgView];
    
    for (int i = 0; i < 2; i++) {
        
        UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(0, i * CGRectGetHeight(_bgView.frame), ScreenWidth, 1)];
        line.backgroundColor = [UIColor colorWithHexString:@"0xC9C9C9"];
        [_bgView addSubview:line];
    }
    
    // 商品名
    UILabel *goodsNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, ScreenWidth, 20)];
    goodsNameLabel.text = model.productName;
    goodsNameLabel.font = [UIFont boldSystemFontOfSize:21];
    goodsNameLabel.textColor = [UIColor blackColor];
    goodsNameLabel.textAlignment = NSTextAlignmentCenter;
    [_bgView addSubview:goodsNameLabel];
    
    // 商品介绍
    UILabel *goodsIntroduce = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(goodsNameLabel.frame) + 15, ScreenWidth, 20)];
    goodsIntroduce.text = model.shortDesc;
    goodsIntroduce.font = [UIFont systemFontOfSize:12];
    goodsIntroduce.textColor = [UIColor colorWithHexString:@"0x383737"];
    goodsIntroduce.textAlignment = NSTextAlignmentCenter;
    [_bgView addSubview:goodsIntroduce];

    // 商品价格
    UILabel *goodsPriceLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(goodsIntroduce.frame) + 15, ScreenWidth, 45)];
    goodsPriceLabel.text = [NSString stringWithFormat:@"￥%.2f",[model.salePrice floatValue]];
    goodsPriceLabel.font = [UIFont systemFontOfSize:21];
    goodsPriceLabel.textColor = Color;
    goodsPriceLabel.textAlignment = NSTextAlignmentCenter;
    [_bgView addSubview:goodsPriceLabel];
    
    NSString *priceString = [NSString stringWithFormat:@"￥%.2f",[model.salePrice floatValue]];
    NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc] initWithString:priceString];
    [attributeString setAttributes:@{NSForegroundColorAttributeName : Color, NSFontAttributeName : [UIFont boldSystemFontOfSize:45]} range:NSMakeRange(1, priceString.length-1)];

    goodsPriceLabel.attributedText = attributeString;
    
    NSString *unitString = [NSString stringWithFormat:@"%@",model.unit];
    NSString *storageString = [NSString stringWithFormat:@"%@",model.storage];
    NSString *stockString = [NSString stringWithFormat:@"%@",model.stock];
    NSArray *arr = @[unitString,storageString,stockString];
    NSArray *nameArry = @[@"产品规格",@"存储方式",@"库存"];
    for (int i = 0; i < 3; i++) {
        
        UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth / 3 * i, CGRectGetMaxY(goodsPriceLabel.frame) + 20, ScreenWidth / 3, 20)];
        nameLabel.text = [NSString stringWithFormat:@"%@: %@",nameArry[i],arr[i]];
        nameLabel.font = [UIFont systemFontOfSize:14];
        nameLabel.textColor = [UIColor blackColor];
        nameLabel.textAlignment = NSTextAlignmentCenter;
        [_bgView addSubview:nameLabel];
        
        if (i == 1) {
            
            for (int a = 0; a < 2; a++) {
                
                UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(a * (ScreenWidth / 3 - 1), 0, 1, 20)];
                line.backgroundColor = [UIColor colorWithHexString:@"0x878787"];
                [nameLabel addSubview:line];
            }
        }
    }
    
    if (model.attr.count > 0) {
        
        _otherTypesView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_bgView.frame), SCREEN_WIDTH, 50 * model.attr.count)];
        [self.contentView addSubview:_otherTypesView];
        
        for (int i = 0; i < model.attr.count; i++) {
            
            UILabel *nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 50 * i, 80, 50)];
            nameLabel.text = model.attr[i][@"paName"];
            nameLabel.textAlignment = NSTextAlignmentRight;
            nameLabel.textColor = [UIColor blackColor];
            nameLabel.font = [UIFont systemFontOfSize:16];
            [_otherTypesView addSubview:nameLabel];
            
            UILabel *typesLabel= [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(nameLabel.frame) + 30, nameLabel.frame.origin.y, SCREEN_WIDTH - 80-30-10, 50)];
            typesLabel.text = model.attr[i][@"paValue"];
            typesLabel.textColor = [UIColor blackColor];
            typesLabel.font = [UIFont systemFontOfSize:16];
            typesLabel.numberOfLines = 2;
            [_otherTypesView addSubview:typesLabel];
            
            UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(nameLabel.frame) - 1, SCREEN_WIDTH, 1)];
            line.backgroundColor = [UIColor grayColor];
            line.alpha = 0.3;
            [_otherTypesView addSubview:line];
        }
    }
    
    /*
     [_goodsTypesView removeFromSuperview];
     [_promotionView removeFromSuperview];
     [_goodsPriceView removeFromSuperview];
     
     UILabel *line1 = [[UILabel alloc] initWithFrame:CGRectMake(0, SCREEN_WIDTH/2 - 1, ScreenWidth, 1)];
     line1.backgroundColor = [UIColor grayColor];
     line1.alpha = 0.3;
     [self.contentView addSubview:line1];
     
     _goodsPriceView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_WIDTH/2, ScreenWidth, 60)];
     _goodsPriceView.backgroundColor = [UIColor colorWithHexString:@"0xf8f8f8"];
     [self.contentView addSubview:_goodsPriceView];
     
     for (int i = 0; i < 2; i++) {
     
     UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, 60, SCREEN_WIDTH, 1)];
     line.backgroundColor = [UIColor grayColor];
     line.alpha = 0.3;
     [_goodsPriceView addSubview:line];
     }
     
     // 价格
     UILabel *priceLabel = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-100, 0, 100-12, CGRectGetHeight(_goodsPriceView.frame) - 1)];
     priceLabel.text = [NSString stringWithFormat:@"￥%.2f",[model.salePrice floatValue]];
     priceLabel.textColor = [UIColor colorWithHexString:@"0xf79c18"];
     priceLabel.font = [UIFont systemFontOfSize:18];
     priceLabel.textAlignment = NSTextAlignmentRight;
     [_goodsPriceView addSubview:priceLabel];
     
     UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(priceLabel.frame) - 1, SCREEN_WIDTH, 1)];
     line.backgroundColor = [UIColor grayColor];
     line.alpha = 0.3;
     [_goodsPriceView addSubview:line];
     
     // 商品名
     UILabel *nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(12, 0, SCREEN_WIDTH - CGRectGetWidth(priceLabel.frame), CGRectGetHeight(_goodsPriceView.frame))];
     nameLabel.text = model.productName;
     nameLabel.textColor = [UIColor colorWithHexString:@"0x737373"];
     nameLabel.font = [UIFont systemFontOfSize:18];
     nameLabel.numberOfLines = 2;
     [_goodsPriceView addSubview:nameLabel];
     
     NSString *specialOfferString = [NSString stringWithFormat:@"%@",model.specialOffer];
     if ([specialOfferString isEqualToString:@"1"]) {
     
     _promotionView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_goodsPriceView.frame), ScreenWidth, 50)];
     _promotionView.backgroundColor = [UIColor whiteColor];
     [self.contentView addSubview:_promotionView];
     
     UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
     btn.frame = CGRectMake(12, 10, 50, 30);
     btn.titleLabel.font = [UIFont systemFontOfSize:13];
     [btn setTitle:@"促 销" forState:UIControlStateNormal];
     [btn setTitleColor:[UIColor colorWithHexString:@"0xf79c18"] forState:UIControlStateNormal];
     [btn setBackgroundImage:IMAGE(@"促销框") forState:UIControlStateNormal];
     [_promotionView addSubview:btn];
     
     UILabel *saleLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(btn.frame) + 10, 0, SCREEN_WIDTH - CGRectGetMaxX(btn.frame) - 10, 50)];
     //        saleLabel.text = @"买一送一(数量有限，送完为止)";
     saleLabel.text = model.specialOfferContext;
     saleLabel.textColor = [UIColor colorWithHexString:@"0x737373"];
     saleLabel.font = [UIFont systemFontOfSize:15];
     [_promotionView addSubview:saleLabel];
     
     UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(saleLabel.frame)-1, SCREEN_WIDTH, 1)];
     line.backgroundColor = [UIColor grayColor];
     line.alpha = 0.3;
     [_promotionView addSubview:line];
     
     _goodsTypesView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_promotionView.frame), SCREEN_WIDTH, 150)];
     }
     else if ([specialOfferString isEqualToString:@"0"]) {
     
     _goodsTypesView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_goodsPriceView.frame), SCREEN_WIDTH, 150)];
     }
     
     _goodsTypesView.backgroundColor = [UIColor whiteColor];
     [self.contentView addSubview:_goodsTypesView];
     
     NSArray *nameArry = @[@"产品规格",@"存储方式",@"库存"];
     NSString *unitString = [NSString stringWithFormat:@"%@",[Tools isBlankString:model.unit] ? @"" : model.unit];
     NSString *storageString = [NSString stringWithFormat:@"%@",[Tools isBlankString:model.storage] ? @"" : model.storage];
     NSString *stockString = [NSString stringWithFormat:@"%@",[model.stock stringByReplacingOccurrencesOfString:@"," withString:@""]];
     NSArray *dataArrray = @[unitString,storageString,stockString];
     
     for (int i = 0; i < nameArry.count; i++) {
     
     UILabel *nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 50 * i, 80, 50)];
     nameLabel.text = nameArry[i];
     nameLabel.textAlignment = NSTextAlignmentRight;
     nameLabel.textColor = [UIColor colorWithHexString:@"0xb4b4b4"];
     nameLabel.font = [UIFont systemFontOfSize:16];
     [_goodsTypesView addSubview:nameLabel];
     
     UILabel *typesLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(nameLabel.frame) + 30, nameLabel.frame.origin.y, SCREEN_WIDTH - CGRectGetMaxX(nameLabel.frame) + 10 - 10, 50)];
     typesLabel.text = dataArrray[i];
     typesLabel.textColor = [UIColor colorWithHexString:@"0x737373"];
     typesLabel.font = [UIFont systemFontOfSize:16];
     [_goodsTypesView addSubview:typesLabel];
     
     UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(nameLabel.frame)-1, SCREEN_WIDTH, 1)];
     line.backgroundColor = [UIColor grayColor];
     line.alpha = 0.3;
     [_goodsTypesView addSubview:line];
     }
     
     
     */
}

@end
