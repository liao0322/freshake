//
//  UserSiteInfoCell.m
//  BuyVegetablesTreasure
//
//  Created by sc on 15/10/16.
//  Copyright (c) 2015年 c521xiong. All rights reserved.
//

#import "UserSiteInfoCell.h"

#import "UserInfoView.h"

@implementation UserSiteInfoCell

- (void)initUserInfo{
            
    UserInfoView *userInfoView   = [[UserInfoView alloc] initWithFrame:CGRectMake(0, 50, SYSTEM_WIDTH, 50)];
    userInfoView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:userInfoView];

}

- (void)setLabelTitle:(NSString *)title{
    
    _userTypeLabel.text = title;
}

- (void)setTextFeildTitle:(NSString *)title{
    
    _userInfoTextField.text = title;
}

- (void)setTextFeildPlaceholder:(NSString *)title{
    
    _userInfoTextField.placeholder = title;
}

- (void)awakeFromNib {
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
