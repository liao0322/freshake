//
//  SelectDeliverySiteCell.m
//  BuyVegetablesTreasure
//
//  Created by sc on 16/3/30.
//  Copyright © 2016年 c521xiong. All rights reserved.
//

#import "SelectDeliverySiteCell.h"

@implementation SelectDeliverySiteCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.layer.borderWidth = 0.5;
        self.layer.borderColor = [[UIColor colorWithHexString:@"0xd7d7d7"] CGColor];
        
        [self initAdressCell];
    }
    
    return self;
}

- (void)initAdressCell {
    
    // 编辑按钮
    UIImage *editImg = IMAGE(@"收货-编辑");
    self.editBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.editBtn setImage:editImg forState:UIControlStateNormal];
    [self.editBtn addTarget:self
                     action:@selector(btnClick)
           forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:self.editBtn];
    
    self.editBtn.sd_layout
    .topEqualToView(self.contentView)
    .bottomEqualToView(self.contentView)
    .rightEqualToView(self.contentView)
    .widthIs(70);
    
    // 分割线
    UIView *lineView = [UIView new];
    lineView.backgroundColor = [UIColor colorWithHexString:@"0xd7d7d7"];
    [self.editBtn addSubview:lineView];
    
    lineView.sd_layout
    .leftEqualToView(self.editBtn)
    .topSpaceToView(self.editBtn, 15)
    .bottomSpaceToView(self.editBtn, 15)
    .widthIs(0.5);
    
    // 手机号
    self.phoneLabel = [UILabel new];
    self.phoneLabel.font = [UIFont systemFontOfSize:14];
    self.phoneLabel.textColor = [UIColor colorWithHexString:@"0x333333"];
    [self.phoneLabel setSingleLineAutoResizeWithMaxWidth:100];
    [self.contentView addSubview:self.phoneLabel];
    
    self.phoneLabel.sd_layout
    .rightSpaceToView(self.editBtn, 15)
    .topSpaceToView(self.contentView, 15)
    .heightIs(15);
    
    // 昵称
    self.nameLabel = [UILabel new];
    self.nameLabel.font = [UIFont systemFontOfSize:14];
    self.nameLabel.textColor = [UIColor colorWithHexString:@"0x333333"];
    [self.contentView addSubview:self.nameLabel];
    
    self.nameLabel.sd_layout
    .leftSpaceToView(self.contentView, 15)
    .rightSpaceToView(self.phoneLabel, 15)
    .topSpaceToView(self.contentView, 15)
    .heightIs(15);
    
    // 地址
    self.siteLabel = [UILabel new];
    self.siteLabel.font = [UIFont systemFontOfSize:14];
    self.siteLabel.textColor = [UIColor colorWithHexString:@"0x333333"];
    [self.contentView addSubview:self.siteLabel];
    
    self.siteLabel.sd_layout
    .leftSpaceToView(self.contentView, 15)
    .rightSpaceToView(self.editBtn, 15)
    .topSpaceToView(self.nameLabel, 15)
    .autoHeightRatio(0);
    
    [self setupAutoHeightWithBottomView:self.siteLabel bottomMargin:15];
}

- (void)btnClick {
    _editBtnClick();
}

- (void)setModel:(SiteModel *)model {
    
    // 昵称
    NSMutableString *nameString = [[NSMutableString alloc] initWithString:model.userName];
    [nameString appendString:[model.sex boolValue] ? @"先生" : @"女士"];
    self.nameLabel.text = nameString;

    // 地址
    NSMutableString *addressString = [[NSMutableString alloc] initWithString:[NSString stringWithFormat:@"%@%@%@", model.City, model.Area, model.Address]];
    
    // 判断是否默认
    if ([model.isdefault boolValue]) {
        
        [addressString insertString:@"[默认]" atIndex:0];
        self.siteLabel.attributedText = [self setAttributedText:addressString
                                                           Font:[UIFont systemFontOfSize:14]
                                                          color:Color
                                                          range:NSMakeRange(0, 4)];
        
    }
    else self.siteLabel.text = addressString;
    
    // 手机号
    self.phoneLabel.text = model.Phone;
    
}

- (NSMutableAttributedString *)setAttributedText:(NSString *)text
                                            Font:(UIFont *)font
                                           color:(UIColor *)color
                                           range:(NSRange)range
{
    NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc] initWithString:text];
    [attributeString setAttributes:@{NSForegroundColorAttributeName : color, NSFontAttributeName : font} range:range];
    return attributeString;
}

@end
