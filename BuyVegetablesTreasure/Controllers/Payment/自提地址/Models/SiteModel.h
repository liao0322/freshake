//
//  SiteModel.h
//  BuyVegetablesTreasure
//
//  Created by sc on 16/3/30.
//  Copyright © 2016年 c521xiong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ParentModel.h"

@interface SiteModel : ParentModel

@property (nonatomic, copy) NSString *Address ; //  棒棒鸭老鸭粉丝汤(第156分店),
@property (nonatomic, copy) NSString *Area ; //  0,
@property (nonatomic, copy) NSString *City ; //  0,
@property (nonatomic, copy) NSString *Phone ; //  13682516802,
@property (nonatomic, copy) NSString *Province ; //  0,
@property (nonatomic, copy) NSString *X ; //  22.547080 ,
@property (nonatomic, copy) NSString *Y ; //  114.085910,
@property (nonatomic, copy) NSString *addTime ; //  2016/3/30 20; // 35; // 26,
@property (nonatomic, copy) NSString *id ; //  7,
@property (nonatomic, copy) NSString *sex ; //  0,
@property (nonatomic, copy) NSString *userId ; //  118,
@property (nonatomic, copy) NSString *userName ; //  我们
// 1.默认地址  0.否
@property (nonatomic, copy) NSString *isdefault;

@end
