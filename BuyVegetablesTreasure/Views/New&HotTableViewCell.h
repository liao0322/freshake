//
//  New&HotTableViewCell.h
//  BuyVegetablesTreasure
//
//  Created by Song on 16/1/12.
//  Copyright © 2016年 c521xiong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NewPruduct.h"
@interface New_HotTableViewCell : UITableViewCell

@property (nonatomic, strong) NewPruduct *model;
@property(nonatomic,strong)UIImageView *ImageView;        //商品图片
@property(nonatomic,strong)UIImageView *image;        //促
@property(nonatomic,strong)UILabel *goodsNameLabel;       //商品名称
@property(nonatomic,strong)UILabel *goodsPriceLabel;      //商品价格
@property(nonatomic,strong)UILabel *originalPriceLabel;   //商品原价格

@property(nonatomic,strong)UIView *deleteView;

@property (nonatomic, strong) void(^addCart)();
@property (nonatomic, strong) void(^imageClick)(NewPruduct *model);

-(void)setData:(NewPruduct *)model isNewPruduct:(NSString *)isNewPruduct;

@end
