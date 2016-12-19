//
//  HomePageGoodsCell.h
//  BuyVegetablesTreasure
//
//  Created by M on 16/12/8.
//  Copyright © 2016年 c521xiong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GoodsModel.h"

@interface HomePageGoodsCell : UITableViewCell

@property (nonatomic, strong) NSArray *goodsArray;
@property (nonatomic, strong) void(^imgClick)(GoodsModel *model);

@end
