//
//  FSRequestAppDelegate.h
//  BuyVegetablesTreasure
//
//  Created by DamonLiao on 2017/3/15.
//  Copyright © 2017年 c521xiong. All rights reserved.
//

#import "FSBaseRequest.h"
#import "FSRequestAppDelegateKeys.h"

@class FSAdModel;

@interface FSRequestAppDelegate : FSBaseRequest

+ (void)adListWithTypeId:(NSString *)typeId
                 success:(void (^)(FSAdModel *adModel))success
                 failure:(Failed)failure;

@end
