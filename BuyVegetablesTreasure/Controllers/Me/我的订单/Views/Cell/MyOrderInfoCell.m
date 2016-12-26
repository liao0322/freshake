//
//  MyOrderInfoCell.m
//  BuyVegetablesTreasure
//
//  Created by M on 16/5/11.
//  Copyright © 2016年 c521xiong. All rights reserved.
//

#import "MyOrderInfoCell.h"

@interface MyOrderInfoCell ()

@property (nonatomic, strong) UILabel *totalCountLabel;
@property (nonatomic, strong) UILabel *totalPriceLabel;
@property (nonatomic, strong) UILabel *line;

@end

@implementation MyOrderInfoCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self initCell];
    }
    
    return self;
}

- (void)initCell {
    
    _totalCountLabel = [[UILabel alloc] init];
    _totalCountLabel.font = [UIFont systemFontOfSize:15];
    _totalCountLabel.textColor = [UIColor colorWithHexString:@"0x404040"];
    [self.contentView addSubview:_totalCountLabel];
    
    _totalPriceLabel = [[UILabel alloc] init];
    _totalPriceLabel.font = [UIFont systemFontOfSize:15];
    _totalPriceLabel.textColor = [UIColor colorWithHexString:@"0x404040"];
    _totalPriceLabel.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:_totalPriceLabel];
    
    _line = [[UILabel alloc] init];
    _line.backgroundColor = [UIColor colorWithHexString:@"0xd9d9d9"];
    [self.contentView addSubview:_line];
    
    NSArray *arr = @[@"立即评价",@"立即付款",@"订单详情"];
    for (int i = 0; i < 3; i++) {
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(ScreenWidth - 90 * 3 - 45 + 105 * i, 0, 90, 40);
        btn.titleLabel.font = [UIFont systemFontOfSize:14.0];
        btn.tag = i + 10;
        btn.hidden = i == 2 ? NO : YES;
        btn.layer.borderWidth = 1;
        btn.layer.cornerRadius = 5;
        btn.layer.borderColor = [UIColor colorDomina].CGColor;
        [btn setTitle:arr[i] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor colorWithHexString:@"0x404040"] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:btn];
    }
}

- (void)layoutSubviews {
    
    float width = self.contentView.frame.size.width;
    float height = self.contentView.frame.size.height;

    _totalCountLabel.frame = CGRectMake(15, 15, width / 2 - 15, 15);
    _totalPriceLabel.frame = CGRectMake(width / 2, 15, width / 2 - 15, 15);
    _line.frame = CGRectMake(0, height - 0.5, width, 0.5);
    
    for (int i = 0; i < 3; i++) {
        
        UIButton *btn = (UIButton *)[self viewWithTag:i + 10];
        
        CGRect frame = btn.frame;
        frame.origin.y = CGRectGetMaxY(_totalPriceLabel.frame) + 15;
        btn.frame = frame;
    }
}

- (void)setModel:(Order *)model {
    
    int totalCount = 0;
    for (int i = 0; i < model.List.count; i++) {
        totalCount += [model.List[i][@"quantity"] integerValue];
    }
    
    float totalPrice = 0;
    for (int i = 0; i < model.List.count; i++) {
        NSLog(@"%@",model.List[i][@"goods_price"]);
        totalPrice += [model.List[i][@"goods_price"] floatValue];
    }

    NSString *priceString = [NSString stringWithFormat:@"￥%.2f",[model.payable_amount floatValue]];
    NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"总计: %@",priceString]];
    [attributeString setAttributes:@{NSForegroundColorAttributeName : Color, NSFontAttributeName : [UIFont boldSystemFontOfSize:15]} range:NSMakeRange(4, priceString.length)];
    
    _totalPriceLabel.attributedText = attributeString;
    _totalCountLabel.text = [NSString stringWithFormat:@"总计: %zd件商品",totalCount];
    
    [(UIButton *)[self viewWithTag:10] setHidden:YES];
    [(UIButton *)[self viewWithTag:11] setHidden:YES];
    
    if ([model.status integerValue] == 1) {
        
        if ([model.payment_status integerValue] == 1) {
            [(UIButton *)[self viewWithTag:11] setHidden:NO];
            [(UIButton *)[self viewWithTag:11] setTitle:@"立即付款" forState:UIControlStateNormal];
        }
    }
    
    if ([model.status integerValue] == 3) {
        
        if ([model.isContext isEqualToString:@"0"]) {
            [(UIButton *)[self viewWithTag:10] setHidden:NO];
        }
        
        NSString *midString = [[NSUserDefaults standardUserDefaults] objectForKey:@"MID"];
        if ([midString isEqualToString:[model.sid stringValue]]) {
            [(UIButton *)[self viewWithTag:11] setHidden:NO];
            [(UIButton *)[self viewWithTag:11] setTitle:@"再次购买" forState:UIControlStateNormal];
            
            CGRect frame = CGRectMake(ScreenWidth - 75 * 3 - 45, 0, 75, 30);
            [(UIButton *)[self viewWithTag:10] setFrame:frame];
        }
        else if (![midString isEqualToString:[model.sid stringValue]]){
            CGRect frame = [(UIButton *)[self viewWithTag:11] frame];
            [(UIButton *)[self viewWithTag:10] setFrame:frame];
            [(UIButton *)[self viewWithTag:11] setHidden:YES];
        }
    }
}

- (void)btnClick:(UIButton *)btn {
    _btnClickBlock(btn.tag);
}

@end
