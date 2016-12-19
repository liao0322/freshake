//
//  LocationCell.h
//  BuyVegetablesTreasure
//
//  Created by sc on 15/10/14.
//  Copyright (c) 2015年 c521xiong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LocationCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *merchantsLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *merchantsAddresLabel;
@property (weak, nonatomic) IBOutlet UILabel *distance;

@property (nonatomic, copy) UILabel *l;
@property (nonatomic, copy) UILabel *l1;

- (void)setStoreInfo;

@end
