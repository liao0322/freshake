//
//  XFModel.h
//  InnerForCourier
//
//  Created by DamonLiao on 2017/2/7.
//  Copyright © 2017年 DamonLiao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MJExtension.h>

@interface XFModel : NSObject

- (instancetype)initWithDict:(NSDictionary *)dict;
+ (instancetype)modelWithDict:(NSDictionary *)dict;

@end
