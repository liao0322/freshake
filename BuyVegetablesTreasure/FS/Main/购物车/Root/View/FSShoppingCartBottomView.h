//
//  FSShoppingCartBottomView.h
//  BuyVegetablesTreasure
//
//  Created by DamonLiao on 2016/12/21.
//  Copyright © 2016年 c521xiong. All rights reserved.
//

#import "FSBaseView.h"

@interface FSShoppingCartBottomView : FSBaseView
@property (weak, nonatomic) IBOutlet UIButton *selectAllButton;
@property (weak, nonatomic) IBOutlet UILabel *totalPriceTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalPriceLabel;
@property (weak, nonatomic) IBOutlet UIView *orderButtonBGView;
@property (weak, nonatomic) IBOutlet UIButton *orderButton;
@end
