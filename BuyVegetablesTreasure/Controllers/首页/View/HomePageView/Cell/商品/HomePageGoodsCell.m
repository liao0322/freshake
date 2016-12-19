//
//  HomePageGoodsCell.m
//  BuyVegetablesTreasure
//
//  Created by M on 16/12/8.
//  Copyright © 2016年 c521xiong. All rights reserved.
//

#import "HomePageGoodsCell.h"
#import "EditNumberView.h"

@interface HomePageGoodsCell ()

/// 编辑商品数量
@property (nonatomic, strong) EditNumberView *editNumberView;

@end

@implementation HomePageGoodsCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor colorWithHexString:@"0xf8f8f8"];
        
        [self setupUI];
    }
    
    return self;
}

- (void)setupUI {
    
    for (int i = 0; i < 2; i++) {
        
        CGFloat imgWidth = (ScreenWidth - HomePageSpacing * 3) / 2;
        // 背景
        UIView *bgView = [UIView new];
        bgView.tag = i + 5;
        bgView.backgroundColor = [UIColor whiteColor];
        bgView.layer.borderColor = [LineColor CGColor];
        bgView.layer.borderWidth = 0.5;
        [self.contentView addSubview:bgView];
        
        bgView.sd_layout
        .leftSpaceToView(self.contentView, HomePageSpacing + (imgWidth + HomePageSpacing) * i)
        .topSpaceToView(self.contentView, HomePageSpacing)
        .widthIs(imgWidth)
        .heightIs(imgWidth + 75);
        
        // 商品图片
        UIImageView *goodsImgView = [UIImageView new];
        goodsImgView.tag = i + 10;
        goodsImgView.userInteractionEnabled = YES;
        [bgView addSubview:goodsImgView];
        
        goodsImgView.sd_layout
        .leftEqualToView(bgView)
        .topEqualToView(bgView)
        .heightIs(imgWidth)
        .widthIs(imgWidth);
        
        // 增加图片点击事件
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imgClick:)];
        [goodsImgView addGestureRecognizer:tap];
        
        // 商品名称
        UILabel *nameLabel = [UILabel new];
        nameLabel.tag = i + 20;
        nameLabel.font = [UIFont systemFontOfSize:13];
        nameLabel.textColor = [UIColor colorWithHexString:@"0x3c3c3c"];
        [bgView addSubview:nameLabel];
        
        nameLabel.sd_layout
        .leftSpaceToView(bgView, 5)
        .rightSpaceToView(bgView, 5)
        .topSpaceToView(goodsImgView, 5)
        .heightIs(15);
        
        // 价格
        UILabel *priceLabel = [UILabel new];
        priceLabel.tag = i + 30;
        priceLabel.font = [UIFont systemFontOfSize:13];
        priceLabel.textColor = [UIColor redColor];
        [bgView addSubview:priceLabel];
        
        priceLabel.sd_layout
        .leftSpaceToView(bgView, 5)
        .rightSpaceToView(bgView, 5)
        .topSpaceToView(nameLabel, 2.5)
        .heightIs(15);
        
        // 原价
        UILabel *originalPriceLabel = [UILabel new];
        originalPriceLabel.tag = i + 40;
        originalPriceLabel.font = [UIFont systemFontOfSize:11];
        originalPriceLabel.textColor = [UIColor colorWithHexString:@"0x909090"];
        [bgView addSubview:originalPriceLabel];
        
        originalPriceLabel.sd_layout
        .leftSpaceToView(bgView, 5)
        .rightSpaceToView(bgView, 5)
        .topSpaceToView(priceLabel, 2.5)
        .heightIs(15);
        
        // 销售量
        UILabel *salesLabel = [UILabel new];
        salesLabel.tag = i + 50;
        salesLabel.font = [UIFont systemFontOfSize:11];
        salesLabel.textColor = [UIColor colorWithHexString:@"0x909090"];
        [bgView addSubview:salesLabel];
        
        salesLabel.sd_layout
        .leftSpaceToView(bgView, 5)
        .rightSpaceToView(bgView, 5)
        .topSpaceToView(originalPriceLabel, 0)
        .heightIs(15);
        
        EditNumberView *editNumberView = [EditNumberView new];
        editNumberView.tag = i + 60;
        [bgView addSubview:editNumberView];
        
        editNumberView.sd_layout
        .rightSpaceToView(bgView, 5)
        .bottomSpaceToView(bgView, 5)
        .widthIs(70)
        .heightIs(30);
        
        [self setupAutoHeightWithBottomView:bgView bottomMargin:0];
    }
}

- (void)imgClick:(UITapGestureRecognizer *)tap {

    UIImageView *imgView = (UIImageView *)tap.view;
    NSLog(@"imgTag = %zd",imgView.tag);
}

- (void)setGoodsArray:(NSArray *)goodsArray {
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        _goodsArray = goodsArray;
        
        for (int i = 0; i < 2; i++) {
            
            UIView *bgView = [self viewWithTag:i + 5];
            bgView.hidden = YES;
            
            UIImageView *imgView = [self viewWithTag:i + 10];
            UILabel *nameLabel = [self viewWithTag:i + 20];
            UILabel *priceLabel = [self viewWithTag:i + 30];
            UILabel *originalPriceLabel = [self viewWithTag:i + 40];
            UILabel *salesLabel = [self viewWithTag:i + 50];
            EditNumberView *editNumberView = [self viewWithTag:i + 60];
            
            if (i < goodsArray.count) {
                
                GoodsModel *model = goodsArray[i];
                
                if (model.img != nil) {
                    imgView.image = model.img;
                }
                else {
                    imgView.image = model.defaultImg;
                }
                
                bgView.hidden = NO;
                nameLabel.text = model.productName;
                priceLabel.text = [NSString stringWithFormat:@"¥%.2f",[model.salePrice floatValue]];
                originalPriceLabel.text = [NSString stringWithFormat:@"原价 ¥%.2f",[model.marketPrice floatValue]];
                salesLabel.text = [NSString stringWithFormat:@"已销售 %@",model.SoldStock];
                editNumberView.numberString = model.CartNum;
            }
        }
    });
    

}

@end
