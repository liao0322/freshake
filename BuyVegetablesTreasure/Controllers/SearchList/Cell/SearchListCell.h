//
//  SearchListCell.h
//  BuyVegetablesTreasure
//
//  Created by sc on 15/11/5.
//  Copyright © 2015年 c521xiong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SearchModel.h"

@interface SearchListCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *goodsImage;
@property (weak, nonatomic) IBOutlet UILabel *goodsPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *goodsNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *goddsNumLabel;
@property (weak, nonatomic) IBOutlet UILabel *originalPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *salesLabel;

@property (nonatomic, copy) void(^goodsNumBlock)(NSString *goodsNum,NSString *goodsID,BOOL isAdd,BOOL isEnough);

@property(nonatomic,strong)void(^imageClick)();

@property (nonatomic, copy) NSString * goodsId;
@property (nonatomic, copy) NSString * stock;

- (IBAction)editGoodsNum:(UIButton *)sender;

- (void)setModel:(SearchModel *)model;

@end
