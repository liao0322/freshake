//
//  OrderReviceModel.h
//  BuyVegetablesTreasure
//
//  Created by XiaoBeiMAC on 15/11/14.
//  Copyright © 2015年 c521xiong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OrderReviceModel : NSObject
@property(nonatomic,copy)NSString *Context;//评论内容
@property(nonatomic,copy)NSNumber *Id;
@property(nonatomic,copy)NSNumber *ProductId;
@property(nonatomic,copy)NSString *addTime;
@property(nonatomic,copy)NSNumber *level;//评分
@property(nonatomic,copy)NSString *orderId;
@property(nonatomic,copy)NSString *productName;//商品名字
@property(nonatomic,copy)NSNumber *userId;

@property (nonatomic,assign,readonly) CGFloat contextHeight;
@end
