//
//  UserSiteInfoCell.h
//  BuyVegetablesTreasure
//
//  Created by sc on 15/10/16.
//  Copyright (c) 2015年 c521xiong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UserSiteInfoCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel     *userTypeLabel;
@property (weak, nonatomic) IBOutlet UITextField *userInfoTextField;

- (void)setLabelTitle:(NSString *)title;
- (void)setTextFeildTitle:(NSString *)title;
- (void)setTextFeildPlaceholder:(NSString *)title;

@end
