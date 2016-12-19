//
//  ShoppingCell.h
//  BuyVegetablesTreasure
//
//  Created by sc on 15/10/19.
//  Copyright (c) 2015年 c521xiong. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "RightGoodsModel.h"

@interface ShoppingCell : UITableViewCell

// 商品图片
@property (weak, nonatomic) IBOutlet UIImageView *goodsImage;

@property (weak, nonatomic) IBOutlet UILabel *goodsNameLabel;

@property (weak, nonatomic) IBOutlet UILabel *goodsCountLabel;

@property (weak, nonatomic) IBOutlet UILabel *goodsPriceLabel;

@property (nonatomic, copy) void(^goodsID)(NSString *goodsID);

@property (weak, nonatomic) IBOutlet UILabel *goddsNumLabel;

@property (nonatomic, copy) void(^goodsBlock)(NSString *goodsNum,NSString *goodsID,BOOL isAdd,BOOL isEnough);

@property (nonatomic, copy) void(^imageClick)(NSInteger index);

@property (nonatomic, copy) NSString * goodsId;

@property (nonatomic, copy) NSString * stock;

- (void)setGoodsModel:(RightGoodsModel *)model;


- (IBAction)editGoodsNum:(UIButton *)sender;

@end
