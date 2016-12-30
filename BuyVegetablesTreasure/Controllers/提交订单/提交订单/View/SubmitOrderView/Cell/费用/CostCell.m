//
//  CostCell.m
//  BuyVegetablesTreasure
//
//  Created by M on 16/9/9.
//
//

#import "CostCell.h"

@interface CostCell ()

/// 商品价格
@property (nonatomic, strong) UILabel *priceLabel;
/// 商品数量
@property (nonatomic, strong) UILabel *goodsNumber;

@end

@implementation CostCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self initCell];
    }
    
    return self;
}

- (void)initCell {
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    self.priceLabel = [UILabel new];
    self.priceLabel.text = @"¥0.00";
    self.priceLabel.font = [UIFont systemFontOfSize:14];
    self.priceLabel.textColor = [UIColor orangeColor];
    self.priceLabel.textAlignment = NSTextAlignmentRight;
    
    self.priceLabel.sd_layout
    .leftEqualToView(self.accessoryView)
    .topEqualToView(self.accessoryView)
    .widthIs(100)
    .heightIs(15);
    
    self.goodsNumber = [UILabel new];
    self.goodsNumber.font = [UIFont systemFontOfSize:14];
    self.goodsNumber.textColor = [UIColor blackColor];
    self.goodsNumber.textAlignment = NSTextAlignmentRight;
    [self.goodsNumber setSingleLineAutoResizeWithMaxWidth:50];
    [self.priceLabel addSubview:self.goodsNumber];
    
    self.goodsNumber.sd_layout
    .leftSpaceToView(self.priceLabel, 10)
    .centerYEqualToView(self.priceLabel)
    .heightIs(15);

    UILabel *line = [UILabel new];
    line.backgroundColor = LineColor;
    [self addSubview:line];
    
    line.sd_layout
    .leftEqualToView(self)
    .rightEqualToView(self)
    .bottomEqualToView(self)
    .heightIs(0.5);
    
    self.accessoryView = self.priceLabel;
    self.textLabel.numberOfLines = 0;
    self.textLabel.font = [UIFont systemFontOfSize:14];
}

- (void)setGoodsModel:(ShopCart *)goodsModel {

    self.textLabel.text = goodsModel.productName;
    self.goodsNumber.hidden = NO;
    self.goodsNumber.text = [NSString stringWithFormat:@"x%@",goodsModel.productNum];
    self.priceLabel.text = [NSString stringWithFormat:@"¥%.2f",[goodsModel.salePrice floatValue] * [goodsModel.productNum intValue]];
}

// 设置运费
- (void)setFreight:(CGFloat)freight {

    self.goodsNumber.hidden = YES;
    self.priceLabel.text = [NSString stringWithFormat:@"¥%.2f", freight];
}

// 优惠券价格
- (void)setCouponPrice:(CGFloat)couponPrice {
    
    self.goodsNumber.hidden = YES;
    self.priceLabel.text = [NSString stringWithFormat:@"-¥%.2f", couponPrice];
}

@end
