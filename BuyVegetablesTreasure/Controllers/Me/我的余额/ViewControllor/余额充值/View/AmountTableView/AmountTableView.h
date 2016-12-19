//
//  AmountTableView.h
//  BuyVegetablesTreasure
//
//  Created by M on 16/11/28.
//  Copyright © 2016年 c521xiong. All rights reserved.
//

#import "KTableView.h"

@interface AmountTableView : KTableView

@property (nonatomic, strong) NSArray *dataSource;
@property (nonatomic, strong) void(^amountBlock)(NSString *priceString, NSString *idString);

@end
