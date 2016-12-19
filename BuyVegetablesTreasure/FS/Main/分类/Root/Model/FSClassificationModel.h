//
//  FSClassificationModel.h
//  BuyVegetablesTreasure
//
//  类别
//
//  Created by DamonLiao on 2016/12/16.
//  Copyright © 2016年 c521xiong. All rights reserved.
//

#import "FSBaseModel.h"

@interface FSClassificationModel : FSBaseModel

@property (assign, nonatomic) NSInteger CategoryId;
@property (copy, nonatomic) NSString *CategoryName;
@property (copy, nonatomic) NSArray *List;

@end
