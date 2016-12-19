//
//  GoodsCartCell.h
//  BuyVegetablesTreasure
//
//  Created by M on 16/4/22.
//  Copyright © 2016年 c521xiong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ShopCart.h"

@interface GoodsCartCell : UITableViewCell

@property (nonatomic, copy) UIImageView *goodsImageView;
@property (nonatomic, copy) UILabel *goodsNameLabel;
@property (nonatomic, copy) UILabel *goodsPriceLabel;
@property (nonatomic, copy) UIButton *isDelBtn;

@property (nonatomic, copy) void(^goodsNumberBlock)(NSInteger goodsNumber,BOOL isDel,BOOL isAdd);
@property (nonatomic, copy) void(^btnClick)();

- (void)setModel:(ShopCart *)model;

@end
