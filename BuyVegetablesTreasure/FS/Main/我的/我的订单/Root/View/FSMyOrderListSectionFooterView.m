//
//  FSMyOrderListSectionFooterView.m
//  BuyVegetablesTreasure
//
//  Created by DamonLiao on 2017/1/24.
//  Copyright © 2017年 c521xiong. All rights reserved.
//

#import "FSMyOrderListSectionFooterView.h"
#import "Order.h"
#import <Masonry.h>

@interface FSMyOrderListSectionFooterView ()

@property (nonatomic) UILabel *totalCountTitleLabel;
@property (nonatomic) UILabel *totalCountLabel;

@property (nonatomic) UILabel *totalPriceTitleLabel;
@property (nonatomic) UILabel *totalPriceLabel;

@property (copy, nonatomic) NSMutableArray *titles;
@property (copy, nonatomic) NSMutableArray *buttons;

@property (nonatomic) UIView *separatorLineOne;

@end

@implementation FSMyOrderListSectionFooterView

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        
        UIView *bgView = [UIView new];
        bgView.backgroundColor = [UIColor whiteColor];
        self.backgroundView = bgView;
        
        [self addSubviews];
    }
    return self;
}

- (void)addSubviews {
    [self.contentView addSubview:self.totalCountTitleLabel];
    [self.contentView addSubview:self.totalCountLabel];
    [self.contentView addSubview:self.totalPriceTitleLabel];
    [self.contentView addSubview:self.totalPriceLabel];
    
    [self.contentView addSubview:self.separatorLineOne];
    
}

- (void)addButtons {
    [self.buttons enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIButton *button = obj;
        [button removeFromSuperview];
        button = nil;
    }];
    [self.buttons removeAllObjects];
    [self.titles enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString *title = obj;
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.tag = idx;
        button.titleLabel.font = [UIFont systemFontOfSize:14];
        [button setTitle:title forState:UIControlStateNormal];
        [button setTitleColor:[UIColor colorTextDomina] forState:UIControlStateNormal];
        
        // 边框和圆角
        button.layer.borderColor = [UIColor colorDomina].CGColor;
        button.layer.borderWidth = 0.5;
        button.layer.cornerRadius = 3;
        button.layer.masksToBounds = YES;
        
        [button addTarget:self action:@selector(itemTouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.buttons addObject:button];
        [self.contentView addSubview:button];
    }];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self.totalCountTitleLabel sizeToFit];
    self.totalCountTitleLabel.x = 15;
    self.totalCountTitleLabel.y = 8;
    
    [self.totalCountLabel sizeToFit];
    self.totalCountLabel.x = self.totalCountTitleLabel.right;
    self.totalCountLabel.y = self.totalCountTitleLabel.y;
    
    [self.totalPriceLabel sizeToFit];
    self.totalPriceLabel.right = self.width - 15;
    self.totalPriceLabel.y = self.totalCountTitleLabel.y;
    
    [self.totalPriceTitleLabel sizeToFit];
    self.totalPriceTitleLabel.right = self.totalPriceLabel.x;
    self.totalPriceTitleLabel.y = self.totalCountTitleLabel.y;
    
    self.separatorLineOne.width = self.width;
    self.separatorLineOne.height = 0.5;
    self.separatorLineOne.x = 0;
    self.separatorLineOne.y = self.totalCountTitleLabel.bottom + 8;
    
    CGFloat buttonWidth = 69;
    CGFloat buttonHeight = 28;
    
    [self.buttons enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIButton *button = obj;
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@(buttonWidth));
            make.height.equalTo(@(buttonHeight));
            make.top.equalTo(self.separatorLineOne.mas_bottom).offset(8);
        }];
        
        if (idx == 0) {
            [button mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.mas_equalTo(self).offset(-15);
            }];
        } else {
            UIButton *previouButton = self.buttons[idx - 1];
            [button mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.mas_equalTo(previouButton).offset(-(buttonWidth + 6));
            }];
        }
    }];
    
}

- (void)setModel:(Order *)model {
    _model = model;
    int totalCount = 0;
    for (int i = 0; i < model.List.count; i++) {
        totalCount += [model.List[i][@"quantity"] integerValue];
    }
    self.totalCountLabel.text = [NSString stringWithFormat:@"%zd 件商品",totalCount];
    
    float totalPrice = 0;
    for (int i = 0; i < model.List.count; i++) {
        totalPrice += [model.List[i][@"goods_price"] floatValue];
    }
    
    NSString *priceString = [NSString stringWithFormat:@"￥%.2f",[model.payable_amount floatValue]];
    self.totalPriceLabel.text = priceString;


    // status == 1 - 取消订单
    // payment_status == 1：
    // 订单详情、立即付款
    
    
    // status == 2 - 待提货
    // 订单详情、查看物流
    
    // status == 3 - 已提货
    // 再次购物、订单详情

    [self.titles removeAllObjects];
    [self.titles addObject:@"订单详情"];
    
    if ([model.status integerValue] == 1) {
        if ([model.payment_status integerValue] == 1) {
            [self.titles addObject:@"立即付款"];
        }
    }
    /*
    if ([model.status integerValue] == 2 && [model.express_id integerValue] == 1) {
        [self.titles addObject:@"查看物流"];
    }
     */
    
    if ([model.status integerValue] == 3) {
        NSString *midString = [[NSUserDefaults standardUserDefaults] objectForKey:@"MID"];
        if ([midString isEqualToString:[model.sid stringValue]]) {
            [self.titles addObject:@"再次购买"];
        }
        if ([model.isContext isEqualToString:@"0"]) {
            [self.titles addObject:@"立即评价"];
        }
        /*
        if ([model.express_id integerValue] == 1) {
            [self.titles addObject:@"查看物流"];
        }
         */
    }
    
    if ([model.payment_status integerValue] != 1 && [model.express_id integerValue] == 1) {
        [self.titles addObject:@"查看物流"];
    }
    
    
    /* 10 立即评价 11 立即付款 12 订单详情
     
    [(UIButton *)[self viewWithTag:10] setHidden:YES];
    [(UIButton *)[self viewWithTag:11] setHidden:YES];
    
    if ([model.status integerValue] == 3) {
        
        if ([model.isContext isEqualToString:@"0"]) {
            [(UIButton *)[self viewWithTag:10] setHidden:NO];
        }
        
        NSString *midString = [[NSUserDefaults standardUserDefaults] objectForKey:@"MID"];
        if ([midString isEqualToString:[model.sid stringValue]]) {
            [(UIButton *)[self viewWithTag:11] setHidden:NO];
            [(UIButton *)[self viewWithTag:11] setTitle:@"再次购买" forState:UIControlStateNormal];
            
            CGRect frame = CGRectMake(ScreenWidth - 85 * 3 - 50, 0, 85, 35);
            [(UIButton *)[self viewWithTag:10] setFrame:frame];
        }
        else if (![midString isEqualToString:[model.sid stringValue]]){
            CGRect frame = [(UIButton *)[self viewWithTag:11] frame];
            [(UIButton *)[self viewWithTag:10] setFrame:frame];
            [(UIButton *)[self viewWithTag:11] setHidden:YES];
        }
    }
    */
    [self addButtons];
    [self setNeedsLayout];
}

#pragma mark - Custom

- (void)itemTouchUpInside:(UIButton *)sender {
    NSString *title = sender.currentTitle;
    
    if ([title isEqualToString:@"订单详情"]) {
        if (self.viewOrderDetailsBlock) {
            self.viewOrderDetailsBlock();
        }
    } else if ([title isEqualToString:@"立即付款"]) {
        if (self.toPayBlock) {
            self.toPayBlock();
        }
    } else if ([title isEqualToString:@"再次购买"]) {
        if (self.buyAgainBlock) {
            self.buyAgainBlock();
        }
    } else if ([title isEqualToString:@"查看物流"]) {
        if (self.viewExpressBlock) {
            self.viewExpressBlock();
        }
    } else if ([title isEqualToString:@"立即评价"]) {
        if (self.toCommentBlock) {
            self.toCommentBlock();
        }
    }
    NSLog(@"%@", sender.currentTitle);
}

#pragma mark - LazyLoad

- (UILabel *)totalCountTitleLabel {
    if (!_totalCountTitleLabel) {
        _totalCountTitleLabel = [UILabel new];
        _totalCountTitleLabel.text = @"总计：";
        _totalCountTitleLabel.font = [UIFont systemFontOfSize:14];
        _totalCountTitleLabel.textColor = [UIColor colorTextDomina];
    }
    return _totalCountTitleLabel;
}

- (UILabel *)totalPriceTitleLabel {
    if (!_totalPriceTitleLabel) {
        _totalPriceTitleLabel = [UILabel new];
        _totalPriceTitleLabel.text = @"总价：";
        _totalPriceTitleLabel.font = [UIFont systemFontOfSize:14];
        _totalPriceTitleLabel.textColor = [UIColor colorTextDomina];
    }
    return _totalPriceTitleLabel;
}

- (UILabel *)totalCountLabel {
    if (!_totalCountLabel) {
        _totalCountLabel = [UILabel new];
        _totalCountLabel.text = @"1件商品";
        _totalCountLabel.font = [UIFont systemFontOfSize:14];
        _totalCountLabel.textColor = [UIColor colorTextDomina];
    }
    return _totalCountLabel;
}

- (UILabel *)totalPriceLabel {
    if (!_totalPriceLabel) {
        _totalPriceLabel = [UILabel new];
        _totalPriceLabel.text = @"￥15.50";
        _totalPriceLabel.font = [UIFont boldSystemFontOfSize:14];
        
        _totalPriceLabel.textColor = [UIColor orangeColor];
    }
    return _totalPriceLabel;
}

- (UIView *)separatorLineOne {
    if (!_separatorLineOne) {
        _separatorLineOne = [UIView new];
        _separatorLineOne.backgroundColor = [UIColor colorSeparatorLine];
    }
    return _separatorLineOne;
}

- (NSMutableArray *)titles {
    if (!_titles) {
        _titles = [NSMutableArray array];
    }
    return _titles;
}

- (NSMutableArray *)buttons {
    if (!_buttons) {
        _buttons = [NSMutableArray array];
    }
    return _buttons;
}
@end
