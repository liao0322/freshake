//
//  PriceDetailCell.m
//  BuyVegetablesTreasure
//
//  Created by M on 16/4/7.
//  Copyright © 2016年 c521xiong. All rights reserved.
//

#import "PriceDetailCell.h"

@interface PriceDetailCell ()

@property (nonatomic, copy) UIView *bgView;
@property (nonatomic, copy) UIView *goodsBgView;
@property (nonatomic, copy) UIButton *isSelectBtn;
@property (nonatomic, copy) UILabel *goodsNameLaebl;
@property (nonatomic, copy) UILabel *goodsCountLaebl;
@property (nonatomic, copy) UILabel *goodsPriceLaebl;
@property (nonatomic, copy) UILabel *freightPriceLabel;
@property (nonatomic, copy) UILabel *couponLabel;

@end

@implementation PriceDetailCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self initCell];
    }
    
    return self;
}

- (void)initCell {
    
    _bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 50)];
    _bgView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:_bgView];
    
    _isSelectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _isSelectBtn.frame = CGRectMake(15, 13.5, 22, 23);
    [_isSelectBtn setImage:[UIImage imageNamed:@"提交-选中"] forState:UIControlStateSelected];
    [_isSelectBtn setImage:[UIImage imageNamed:@"发票图标"] forState:UIControlStateNormal];
    [_isSelectBtn addTarget:self action:@selector(btnClick) forControlEvents:UIControlEventTouchUpInside];
    [_bgView addSubview:_isSelectBtn];
    
    NSArray *places = @[@"请输入发票抬头",@"请输入发票内容"];

    for (int i = 0; i < 2; i++) {
        
        UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(15, 50 + i * 50, ScreenWidth - 30, 35)];
        textField.tag = i + 1;
        textField.borderStyle = UITextBorderStyleRoundedRect;
        textField.placeholder = places[i];
        textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        [textField addTarget:self
                      action:@selector(textFieldEditChanged:)
            forControlEvents:UIControlEventEditingChanged];
        [_bgView addSubview:textField];
    }
    
    UILabel *invoiceLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_isSelectBtn.frame) + 10, 0, 100, 50)];
    invoiceLabel.text = @"开具发票";
    invoiceLabel.font = [UIFont systemFontOfSize:14];
    invoiceLabel.textColor = [UIColor colorWithHexString:@"0x606060"];
    [_bgView addSubview:invoiceLabel];
    
    UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 1)];
    line.backgroundColor = [UIColor colorWithHexString:@"0xDAD9D9"];
    [_bgView addSubview:line];
    
    _goodsBgView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(_bgView.frame), ScreenWidth, 50 * 2)];
    _goodsBgView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:_goodsBgView];
    
    _goodsNameLaebl = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, ScreenWidth / 2 - 30, 50)];
    _goodsNameLaebl.font = [UIFont systemFontOfSize:14];
    _goodsNameLaebl.textColor = [UIColor colorWithHexString:@"0x606060"];
    [_goodsBgView addSubview:_goodsNameLaebl];
    
    _goodsCountLaebl = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_goodsNameLaebl.frame), 0, ScreenWidth / 4, 50)];
    _goodsCountLaebl.text = @"1";
    _goodsCountLaebl.font = [UIFont systemFontOfSize:14];
    _goodsCountLaebl.textColor = [UIColor blackColor];
    _goodsCountLaebl.textAlignment = NSTextAlignmentRight;
    [_goodsBgView addSubview:_goodsCountLaebl];
    
    _goodsPriceLaebl = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth - 100, 0, 80, 50)];
    _goodsPriceLaebl.font = [UIFont systemFontOfSize:15];
    _goodsPriceLaebl.textColor = [UIColor colorWithHexString:@"0xff6600"];
    _goodsPriceLaebl.textAlignment = NSTextAlignmentRight;
    [_goodsBgView addSubview:_goodsPriceLaebl];
    
    UILabel *freightLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 50, ScreenWidth / 2 - 30, 50)];
    freightLabel.text = @"配送费";
    freightLabel.font = [UIFont systemFontOfSize:14];
    freightLabel.textColor = [UIColor colorWithHexString:@"0x606060"];
    [_goodsBgView addSubview:freightLabel];
    
    _freightPriceLabel = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth - 100, 50, 80, 50)];
    _freightPriceLabel.text = @"¥0.00";
    _freightPriceLabel.font = [UIFont systemFontOfSize:15];
    _freightPriceLabel.textColor = [UIColor colorWithHexString:@"0xff6600"];
    _freightPriceLabel.textAlignment = NSTextAlignmentRight;
    [_goodsBgView addSubview:_freightPriceLabel];
    
    _couponLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 100, ScreenWidth / 2 - 30, 50)];
    _couponLabel.hidden = YES;
    _couponLabel.text = @"优券";
    _couponLabel.font = [UIFont systemFontOfSize:14];
    _couponLabel.textColor = [UIColor colorWithHexString:@"0x606060"];
    [_goodsBgView addSubview:_couponLabel];
    
    _couponPriceLabel = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth - 100, 100, 80, 50)];
    _couponPriceLabel.hidden = YES;
    _couponPriceLabel.text = @"¥0.00";
    _couponPriceLabel.font = [UIFont systemFontOfSize:15];
    _couponPriceLabel.textColor = [UIColor colorWithHexString:@"0xff6600"];
    _couponPriceLabel.textAlignment = NSTextAlignmentRight;
    [_goodsBgView addSubview:_couponPriceLabel];
    
    for (int i = 0; i < 3; i++) {
        
        UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(0, 50 * i, ScreenWidth, 1)];
        line.backgroundColor = [UIColor colorWithHexString:@"0xDAD9D9"];
        [_goodsBgView addSubview:line];
    }
}

- (void)btnClick {
    
    _isSelectBtn.selected = !_isSelectBtn.selected;
    
    CGRect frame = _bgView.frame;
    frame.size.height = _isSelectBtn.selected ? 150 : 50;
    
    CGRect frame1 = _goodsBgView.frame;
    frame1.origin.y = CGRectGetHeight(frame);
    
    [UIView animateWithDuration:0.3 animations:^{
        _bgView.frame = frame;
        _goodsBgView.frame = frame1;
    }];
    
    _isSelect(_isSelectBtn.selected);
}

- (void)setGroupModel:(GroupModel *)gourpModel {
    
    _goodsNameLaebl.text = gourpModel.ProductName;
    _goodsPriceLaebl.text = [NSString stringWithFormat:@"¥%.2f",[gourpModel.ActivityPrice floatValue]];
}

- (void)setCouponPrice:(float)price {

    _goodsBgView.frame = CGRectMake(0, CGRectGetHeight(_bgView.frame), ScreenWidth, 50 * 3);
    
    if (_couponLabel.hidden) {
        
        UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(_goodsBgView.frame) - 1, ScreenWidth, 1)];
        line.backgroundColor = [UIColor colorWithHexString:@"0xDAD9D9"];
        [_goodsBgView addSubview:line];
    }

    _couponLabel.hidden = NO;
    _couponPriceLabel.hidden = NO;
    _couponPriceLabel.text = [NSString stringWithFormat:@"¥%.2f",price];
}

- (void)setDistancePrice:(NSString *)price {
    _freightPriceLabel.text = [NSString stringWithFormat:@"￥%@",price];
}

- (void)textFieldEditChanged:(UITextField *)textField {
    
    if (textField.tag == 1) {
        [Single sharedInstance].invoiceTitle = textField.text;
    }
    else {
        [Single sharedInstance].invoiceContent = textField.text;
    }
}

@end
