//
//  GoodsDetailsView.h
//  BuyVegetablesTreasure
//
//  Created by M on 16/11/22.
//  Copyright © 2016年 c521xiong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KTableView.h"
#import "GoodsDetailsModel.h"

@interface GoodsDetailsView : KTableView

@property (nonatomic, strong) GoodsDetailsModel *detailsModel;
@property (nonatomic, strong) void(^lookBlock)();

@end
