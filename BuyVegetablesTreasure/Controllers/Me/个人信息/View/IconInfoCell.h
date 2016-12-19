//
//  IconInfoCell.h
//  BuyVegetablesTreasure
//
//  Created by Song on 16/4/21.
//  Copyright © 2016年 c521xiong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IconInfoCell : UITableViewCell

@property (nonatomic, copy)UILabel *name;
@property (nonatomic, copy)UILabel *mobile;
@property (nonatomic,copy)UIImageView  *icon;
@property (nonatomic, copy)void(^pushLogin)();
-(void)setDataSource;


@end
