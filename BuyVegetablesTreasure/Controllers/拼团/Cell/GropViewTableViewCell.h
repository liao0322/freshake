//
//  GropViewTableViewCell.h
//  BuyVegetablesTreasure
//
//  Created by XiaoBeiMAC on 15/11/25.
//  Copyright © 2015年 c521xiong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GroupModel.h"
@interface GropViewTableViewCell : UITableViewCell

@property(nonatomic,strong)UIImageView *imgView;
@property(nonatomic,strong)UILabel *nameLabel;
@property(nonatomic,strong)UILabel *titleLabel;
@property(nonatomic,strong)UILabel *peopleLabel;
@property(nonatomic,strong)UIView *footView;

@property(nonatomic,strong)void(^goGroup)();

-(void)setGroupModel:(GroupModel *)model;

@end
