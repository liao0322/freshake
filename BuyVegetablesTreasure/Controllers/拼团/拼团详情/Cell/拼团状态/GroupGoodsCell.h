//
//  GroupGoodsCell.h
//  BuyVegetablesTreasure
//
//  Created by Kai on 16/4/6.
//  Copyright © 2016年 c521xiong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyGroupModel.h"

@interface GroupGoodsCell : UITableViewCell

@property (nonatomic, copy) UILabel *goodsNameLabel;      // 商品名称
@property (nonatomic, copy) UILabel *goodsTitleLabel;     // 商品标题
@property (nonatomic, copy) UILabel *goodsNumLabel;       // 商品数量
@property (nonatomic, copy) UIImageView *isSuccessImageView;        // 是否成功图片
@property (nonatomic, copy) UIImageView *thumbnailsUrllImageView;   // 商品图片

- (void)setGroupModel:(MyGroupModel *)model;

@end
