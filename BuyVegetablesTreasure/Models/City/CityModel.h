//
//  CityModel.h
//  BuyVegetablesTreasure
//
//  Created by sc on 15/11/10.
//  Copyright © 2015年 c521xiong. All rights reserved.
//

#import "ParentModel.h"

@interface CityModel : ParentModel

@property (nonatomic, copy) NSString *id ; // 567,
@property (nonatomic, copy) NSString *name ; // 东华门街道,
@property (nonatomic, copy) NSString *upid ; // 37

@property (nonatomic, copy) NSMutableArray *cityArray ; // 3,

@end
