//
//  URLBase.m
//  BuyVegetablesTreasure
//
//  Created by DamonLiao on 2016/12/6.
//  Copyright © 2016年 c521xiong. All rights reserved.
//

#import "URLBase.h"


NSString *URLBaseDomain() {
    
#if DEBUG
    return @"http://192.168.1.161:7100/";
#else
    return @"http://h5.freshake.cn/";
#endif
}

NSString *URLBasePath() {
    return [NSString stringWithFormat:@"%@%@", URLBaseDomain(), @"api/Phone/four/index.aspx"];
}



