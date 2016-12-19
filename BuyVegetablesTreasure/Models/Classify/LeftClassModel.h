//
//  LeftClassModel.h
//  BuyVegetablesTreasure
//
//  Created by sc on 15/10/21.
//  Copyright (c) 2015年 c521xiong. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "ParentModel.h"
#import "RightGoodsModel.h"

@interface LeftClassModel : ParentModel

@property (nonatomic, copy) NSString *CategoryId;
@property (nonatomic, copy) NSString *CategoryName;

@property (nonatomic, copy) NSMutableArray *listArray;

@end
