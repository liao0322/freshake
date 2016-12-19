//
//  RecordTableViewCell.h
//  BuyVegetablesTreasure
//
//  Created by Song on 16/3/14.
//  Copyright © 2016年 c521xiong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RechardModel.h"
@interface RecordTableViewCell : UITableViewCell

@property(nonatomic,strong)UILabel *numLabel;
@property(nonatomic,strong)UILabel *timeLabel;
@property(nonatomic,strong)UILabel *detailLabel;

-(void)setData:(RechardModel *)model;

@end
