//
//  AmountModel.h
//  BuyVegetablesTreasure
//
//  Created by M on 16/11/28.
//  Copyright © 2016年 c521xiong. All rights reserved.
//

#import "ParentModel.h"

@interface AmountModel : ParentModel

// id
@property (nonatomic, strong) NSString *id;
// 金额
@property (nonatomic, strong) NSString *total_fee;
// 图片
@property (nonatomic, strong) NSString *rimage;
// 文本
@property (nonatomic, strong) NSString *strName;
@property (nonatomic, strong) NSString *type;
@property (nonatomic, strong) NSString *giveCash;

@end
