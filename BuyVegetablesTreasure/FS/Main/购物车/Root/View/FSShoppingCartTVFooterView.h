//
//  FSShoppingCartTVFooterView.h
//  BuyVegetablesTreasure
//
//  Created by DamonLiao on 2016/12/21.
//  Copyright © 2016年 c521xiong. All rights reserved.
//

#import "FSBaseView.h"

@interface FSShoppingCartTVFooterView : FSBaseView
@property (weak, nonatomic) IBOutlet UILabel *tipsLabel;

@property (weak, nonatomic) IBOutlet UIView *firstSeparatorLine;

@property (weak, nonatomic) IBOutlet UILabel *pointLabel;

@property (weak, nonatomic) IBOutlet UIView *secondSeparatorLine;

@property (weak, nonatomic) IBOutlet UILabel *couponLabel;

@property (weak, nonatomic) IBOutlet UIImageView *pointImageView;

@property (weak, nonatomic) IBOutlet UIImageView *couponImageView;

@end
