//
//  ChoiceGroupTableViewCell.h
//  BuyVegetablesTreasure
//
//  Created by XiaoBeiMAC on 15/11/27.
//  Copyright © 2015年 c521xiong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChoiceGroupTableViewCell : UITableViewCell

@property(nonatomic,strong)UIImageView *thumbnailsUrllImageView;   //商品图片
@property(nonatomic,strong)UILabel *goodsNameLabel;       //商品名称
@property(nonatomic,strong)UILabel *goodsTitleLabel;       //商品标题
@property(nonatomic,strong)UILabel *real_priceLabel;      //商品价格
@property(nonatomic,strong)UILabel *goodsNumLabel;      //商品数量

@end
