//
//  FSCommodityCVCell.h
//  BuyVegetablesTreasure
//
//  Created by DamonLiao on 2016/12/15.
//  Copyright © 2016年 c521xiong. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RightGoodsModel;
@class FSCommodityCVCell;

@protocol FSCommodityCVCellDelegate <NSObject>

- (void)commodityCVCell:(FSCommodityCVCell *)cell plusButtonTouchUpInside:(UIButton *)sender;

- (void)commodityCVCell:(FSCommodityCVCell *)cell minusButtonTouchUpInside:(UIButton *)sender;

@end

@interface FSCommodityCVCell : UICollectionViewCell

@property (nonatomic) RightGoodsModel *model;

@property (weak, nonatomic) IBOutlet UIView *topSeparatorLine;
@property (weak, nonatomic) IBOutlet UIView *leftSeparatorLine;

@property (weak, nonatomic) id<FSCommodityCVCellDelegate> delegate;


+ (CGFloat)height;

/// 商品图片
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
/// 商品标题
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
/// 商品价格
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
/// 商品简介
@property (weak, nonatomic) IBOutlet UILabel *descLabel;
/// 购物车数量
@property (weak, nonatomic) IBOutlet UILabel *countLabel;
/// 添加至购物车按钮
@property (weak, nonatomic) IBOutlet UIButton *plusButton;
/// 减少商品按钮
@property (weak, nonatomic) IBOutlet UIButton *minusButton;

@end
