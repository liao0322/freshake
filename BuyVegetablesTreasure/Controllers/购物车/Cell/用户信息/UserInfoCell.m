//
//  UserInfoCell.m
//  BuyVegetablesTreasure
//
//  Created by sc on 15/10/14.
//  Copyright (c) 2015年 c521xiong. All rights reserved.
//

#import "UserInfoCell.h"

@implementation UserInfoCell

- (void)awakeFromNib {

    for (int i = 0; i < 2; i++) {
        
        UILabel *l = [[UILabel alloc] initWithFrame:CGRectMake(0, 105 * i, ScreenWidth, 1)];
        l.backgroundColor = [UIColor colorWithHexString:@"0xDAD9D9"];
        [self.contentView addSubview:l];
    }
}

- (void)setModel:(Address *)model{
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];

    NSString *nameString;
    NSString *telephoneString;
    NSString *siteString;
    
    if (model.user_name == NULL) {
        
        telephoneString = [userDefaults objectForKey:@"mobile"];
        siteString = [userDefaults objectForKey:@"address"];
        nameString = [userDefaults objectForKey:@"user_name"];
    }
    else {
        
        nameString = model.user_name;
        telephoneString = model.telephone;
        siteString = model.addr;
        
    }
    
    _nameLabel.text = [NSString stringWithFormat:@"收货人: %@",nameString];
    _telephone.text = [NSString stringWithFormat:@"电话: %@",telephoneString];
    _site.text = [NSString stringWithFormat:@"收货地址: %@",siteString];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
