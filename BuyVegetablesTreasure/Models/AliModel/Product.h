//
//  Product.h
//  LaMALL
//
//  Created by qianfeng on 15-7-4.
//  Copyright (c) 2015年 yuanjinsong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Product : NSObject


@property (nonatomic, copy) NSString *price; // 价格
@property (nonatomic, copy) NSString *name;// 商品名称
@property (nonatomic, copy) NSString *decripts;// 商品描述
@property (nonatomic, copy) NSString *orderId;// 订单号

@end
