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

@end
