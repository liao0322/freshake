//
//  OrderTotalView.m
//  BuyVegetablesTreasure
//
//  Created by M on 16/9/18.
//
//

#import "OrderTotalView.h"

@implementation OrderTotalView

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        self.layer.borderWidth = 0.5;
        self.layer.borderColor = LineColor.CGColor;
        
        [self initView];
    }
    return self;
}

- (void)initView {
    
    UIView *priceBgView = [UIView new];
    priceBgView.backgroundColor = [UIColor whiteColor];
    [self addSubview:priceBgView];
    
    priceBgView.sd_layout
    .leftEqualToView(self)
    .topEqualToView(self)
    .bottomEqualToView(self)
    .widthRatioToView(self, 0.65);
    
    self.priceLabel = [UILabel new];
    self.priceLabel.text = @"应付金额: ¥0.00";
    self.priceLabel.font = [UIFont systemFontOfSize:14];
    self.priceLabel.textColor = Color;
    self.priceLabel.textAlignment = NSTextAlignmentCenter;
    [priceBgView addSubview:self.priceLabel];
    
    self.priceLabel.sd_layout
    .centerXEqualToView(priceBgView)
    .centerYEqualToView(priceBgView)
    .leftSpaceToView(priceBgView, 0)
    .rightSpaceToView(priceBgView, 0)
    .heightIs(15);
    
    self.payBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.payBtn.backgroundColor = Color;
    self.payBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [self.payBtn setTitle:@"确定付款" forState:UIControlStateNormal];
    [self.payBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.payBtn addTarget:self action:@selector(payClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.payBtn];
    
    self.payBtn.sd_layout
    .leftSpaceToView(priceBgView, 0)
    .rightEqualToView(self)
    .topEqualToView(self)
    .bottomEqualToView(self);
}

- (void)payClick {
    
    _payInfo();
}

- (CGFloat)setOrderTotalPrice:(CGFloat)totalPrice
                  couponPrice:(CGFloat)couponPrice
                      freight:(CGFloat)freight
{
    CGFloat orderPrice = totalPrice + freight - couponPrice;
    orderPrice = orderPrice <= 0 ? 0 : orderPrice;
    self.priceLabel.attributedText = [self setAttributedText:[NSString stringWithFormat:@"应付金额: ¥%.2f", orderPrice]
                                                   textColor:[UIColor blackColor]
                                                        font:[UIFont systemFontOfSize:14]];
    return orderPrice;
}

- (NSMutableAttributedString *)setAttributedText:(NSString *)text textColor:(UIColor *)color font:(UIFont *)font
{
    NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc] initWithString:text];
    [attributeString setAttributes:@{NSForegroundColorAttributeName : color, NSFontAttributeName : font} range:NSMakeRange(0, 5)];
    return attributeString;
}

@end
