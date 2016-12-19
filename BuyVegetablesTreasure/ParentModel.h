//
//  ParentModel.h
//  MiZheDemo
//
//  Created by Kai on 15/6/29.
//  Copyright (c) 2015年 Kai. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ParentModel : NSObject

- (instancetype)initWithDict:(NSDictionary *)dict;
+ (instancetype)modelWithDict:(NSDictionary *)dict;

@end
