//
//  FSRequestAppDelegate.m
//  BuyVegetablesTreasure
//
//  Created by DamonLiao on 2017/3/15.
//  Copyright © 2017年 c521xiong. All rights reserved.
//

#import "FSRequestAppDelegate.h"
#import "FSAdModel.h"

@implementation FSRequestAppDelegate

+ (void)adListWithTypeId:(NSString *)typeId
                 success:(void (^)(FSAdModel *adModel))success
                 failure:(Failed)failure {
    
    [XFNetworking GET:@"http://test.freshake.cn:8050/mcapi/queryAdList?typeId=0&syscode=004" parameters:nil success:^(id responseObject, NSInteger statusCode) {
        if (statusCode != 200) {
            if (failure) {
                failure(nil, statusCode);
            }
            return;
        }
        NSDictionary *dict = [XFNetworking dictWithData:responseObject];
        NSString *code = dict[KEY_CODE];
        
        if (![code isEqualToString:@"0"]) {
            [self handleCode:code];
            if (failure) {
                failure(nil, statusCode);
            }
            return;
        }
        
        NSArray *resultArray = dict[KEY_RESULT];
        
        if (resultArray == nil || resultArray.count == 0) {
            if (failure) {
                failure(nil, statusCode);
            }
            return;
        }
        
        NSDictionary *adDict = [resultArray objectAtIndex:0];
        FSAdModel *adModel = [FSAdModel mj_objectWithKeyValues:adDict];
        if (success) {
            success(adModel);
        }
        
    } failure:^(NSError *error, NSInteger statusCode) {
        if (failure) {
            failure(error, statusCode);
        }
    }];
    
}

@end
