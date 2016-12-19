//
//  ClassificationCell.h
//  BuyVegetablesTreasure
//
//  Created by M on 16/4/22.
//  Copyright © 2016年 c521xiong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RightGoodsModel.h"

@interface ClassificationCell : UITableViewCell

@property (nonatomic, copy) UIImageView *goodsImageView;
@property (nonatomic, copy) UILabel *goodsNameLabel;
@property (nonatomic, copy) UILabel *goodsPriceLabel;
@property (nonatomic, copy) UILabel *goodsUserPriceLabel;
@property (nonatomic, copy) UILabel *goodsShortDescLabel;

@property (nonatomic, copy) NSString *goodsIdString;
@property (nonatomic, copy) NSString *stockString;
@property (nonatomic, copy) NSString *salePriceString;

@property(nonatomic,strong)void(^imageClick)();
@property (nonatomic, copy) void(^goodsBlock)(NSString *goodsNum,NSString *goodsID,BOOL isAdd,NSString *salePrice);

- (void)setGoodsModel:(RightGoodsModel *)model;

@end
