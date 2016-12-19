//
//  Map.h
//  BuyVegetablesTreasure
//
//  Created by sc on 15/11/11.
//  Copyright © 2015年 c521xiong. All rights reserved.
//

#import "ParentModel.h"

@interface Map : ParentModel

@property (nonatomic, copy) NSString *id;
@property (nonatomic, copy) NSString *Fendianname ; // 南山分区提货点3,
@property (nonatomic, copy) NSString *addr ;        // 深圳市南山区蛇口办事处,
@property (nonatomic, copy) NSString *area ;        // 深圳-南山-蛇口,
@property (nonatomic, copy) NSString *tel ;         // 123456789,
@property (nonatomic, copy) NSString *telephone ;   //
@property (nonatomic, copy) NSString *user_name ;   //
@property (nonatomic, copy) NSString *xPoint ;      // 22.49859,
@property (nonatomic, copy) NSString *yPoint ;      // 113.934965
@property (nonatomic, copy) NSString *picktime ;    // 11:00-21:00
@property (nonatomic, copy) NSString *mid ;         // 11:00-21:00
@property (nonatomic, copy) NSString *pickJuli;
@property (nonatomic, copy) NSString *DistancePrice;
@property (nonatomic, copy) NSString *Distance;
@property (nonatomic, copy) NSString *IsDistribution;
@property (nonatomic, copy) NSString *fullPrice;

@end
