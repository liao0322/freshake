//
//  MyCollectTableViewCell.h
//  BuyVegetablesTreasure
//
//  Created by XiaoBeiMAC on 15/12/10.
//  Copyright © 2015年 c521xiong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyCollectModel.h"
@interface MyCollectTableViewCell : UITableViewCell

@property(nonatomic,strong)UIImageView *ImageView;   //商品图片
@property(nonatomic,strong)UILabel *goodsNameLabel;       //商品名称
@property(nonatomic,strong)UILabel *goodsPriceLabel;       //商品标题

@property(nonatomic,strong)UIView *deleteView;

@property(nonatomic,strong)void(^payNow)();

-(void)setMyCollectModel:(MyCollectModel *)model;
@end
