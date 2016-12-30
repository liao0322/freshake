//
//  FSSelectDeliverySiteCell.m
//  BuyVegetablesTreasure
//
//  Created by 江玉元 on 2016/12/24.
//  Copyright © 2016年 c521xiong. All rights reserved.
//

#import "FSSelectDeliverySiteCell.h"

@implementation FSSelectDeliverySiteCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initAddressCell];
    }
    
    return self;
}

- (void)initAddressCell {
    
    // 手机号
    self.phoneLabel = [UILabel new];
    self.phoneLabel.frame = CGRectMake(SCREEN_WIDTH - SCREEN_WIDTH / 3 - 15, 17, SCREEN_WIDTH / 3, 17);
    self.phoneLabel.font = [UIFont systemFontOfSize:16.0];
    self.phoneLabel.textAlignment = NSTextAlignmentCenter;
    self.phoneLabel.textColor = [UIColor colorWithHexString:@"0*404040"];
    [self.contentView addSubview:self.phoneLabel];
    
//    self.phoneLabel.sd_layout
//    .rightSpaceToView(self.contentView, 15)
//    .topSpaceToView(self.contentView, 19)
//    .heightIs(17);
    
    // 名称
    self.nameLabel = [UILabel new];
    self.nameLabel.frame = CGRectMake(15, 17, SCREEN_WIDTH / 4 + 20, 17);
    self.nameLabel.font = [UIFont systemFontOfSize:16.0];
    self.nameLabel.textColor = [UIColor colorWithHexString:@"0*404040"];
    [self.contentView addSubview:self.nameLabel];
    
//    self.nameLabel.sd_layout
//    .leftSpaceToView(self.contentView, 15)
//    .rightSpaceToView(self.phoneLabel, 15)
//    .topSpaceToView(self.contentView, 19)
//    .heightIs(16);
    
    // 地址
    self.siteLabel = [UILabel new];
    self.siteLabel.font = [UIFont systemFontOfSize:16.0];
    self.siteLabel.textColor = [UIColor colorWithHexString:@"0*404040"];
    [self.contentView addSubview:self.siteLabel];
    
    self.siteLabel.sd_layout
    .leftSpaceToView(self.contentView, 15)
    .rightSpaceToView(self.contentView, 15)
    .topSpaceToView(self.nameLabel, 15)
    .autoHeightRatio(0);
    
    UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(0, 85, ScreenWidth, 0.5)];
    line.backgroundColor = [UIColor colorWithHexString:@"0xd9d9d9"];
    [self.contentView addSubview:line];
    
    self.defaultBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.defaultBtn.frame = CGRectMake(0, CGRectGetMaxY(line.frame), SCREEN_WIDTH / 3, 50);
    self.defaultBtn.titleLabel.font = [UIFont systemFontOfSize:14.0];
    [self.defaultBtn addTarget:self action:@selector(defaultClick) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:self.defaultBtn];
    
    self.deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.deleteBtn setTitle:@"  删除" forState:UIControlStateNormal];
    [self.deleteBtn setImage:IMAGE(@"FSAddress删除") forState:UIControlStateNormal];
    self.deleteBtn.titleLabel.font = [UIFont systemFontOfSize:15.0];
    [self.deleteBtn setTitleColor:[UIColor colorWithHexString:@"0x808080"] forState:UIControlStateNormal];
    [self.deleteBtn addTarget:self action:@selector(deleteClick) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:self.deleteBtn];
    
    self.deleteBtn.sd_layout
    .topEqualToView(line)
    .rightEqualToView(self.contentView)
    .widthIs(SCREEN_WIDTH / 4)
    .heightIs(50);
    
    self.editBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.editBtn setTitle:@"  编辑" forState:UIControlStateNormal];
    [self.editBtn setImage:IMAGE(@"FSAddress编辑") forState:UIControlStateNormal];
    self.editBtn.titleLabel.font = [UIFont systemFontOfSize:15.0];
    [self.editBtn setTitleColor:[UIColor colorWithHexString:@"0x808080"] forState:UIControlStateNormal];
    [self.editBtn addTarget:self action:@selector(editClick) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:self.editBtn];
    
    self.editBtn.sd_layout
    .topEqualToView(line)
    .rightSpaceToView(self.deleteBtn, 10)
    .widthIs(SCREEN_WIDTH / 4)
    .heightIs(50);
    
    [self setupAutoHeightWithBottomView:self.deleteBtn bottomMargin:0];
}

- (void)defaultClick {
    _defaultBtnClick();
}

- (void)editClick {
    _editBtnClick();
}

- (void)deleteClick {
    [Tools myAlert:@"确定删除该地址？" target:self];

}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (buttonIndex == 1) {
        _deleteBtnClick();

    }
}

- (void)setModel:(SiteModel *)model {
    
    
    // 昵称
    NSMutableString *nameString = [[NSMutableString alloc] initWithString:model.userName];
    [nameString appendString:[model.sex boolValue] ? @"先生" : @"女士"];
    self.nameLabel.text = nameString;
    
    // 地址
    NSMutableString *addressString = [[NSMutableString alloc] initWithString:[NSString stringWithFormat:@"%@%@%@", model.City, model.Area, model.Address]];
    self.siteLabel.text = addressString;
    
    // 判断默认地址 1 默认 0 否
    if ([model.isdefault boolValue] == 1) {
        [self.defaultBtn setTitle:@"  默认地址" forState:UIControlStateNormal];
        [self.defaultBtn setImage:IMAGE(@"FS选中") forState:UIControlStateNormal];
        [self.defaultBtn setTitleColor:[UIColor colorDomina] forState:UIControlStateNormal];
    }else {
        [self.defaultBtn setTitle:@"  设为默认" forState:UIControlStateNormal];
        [self.defaultBtn setImage:IMAGE(@"FS未选中") forState:UIControlStateNormal];
        [self.defaultBtn setTitleColor:[UIColor colorWithHexString:@"0x404040"] forState:UIControlStateNormal];
    }
    
    self.phoneLabel.text = model.Phone;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
