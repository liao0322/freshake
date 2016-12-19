//
//  RechardModel.h
//  BuyVegetablesTreasure
//
//  Created by Song on 16/3/14.
//  Copyright © 2016年 c521xiong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ParentModel.h"

@interface RechardModel : ParentModel

@property (nonatomic, copy) NSString *add_time;
@property (nonatomic, copy) NSNumber *ID;
@property (nonatomic, copy) NSString *remark;
@property (nonatomic, copy) NSString *user_name;
@property (nonatomic, copy) NSNumber *value;
@property (nonatomic, copy) NSString *status;

@property (nonatomic, assign) NSInteger contHeight;
@property (nonatomic, assign) BOOL isPoint;

@end
