//
//  OrderPinglunModel.h
//  BuyVegetablesTreasure
//
//  Created by XiaoBeiMAC on 15/11/14.
//  Copyright © 2015年 c521xiong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OrderPinglunModel : NSObject

@property(nonatomic,copy)NSString *pinglunText;//评论内容
@property(nonatomic,copy)NSString *pinglunStar;//评论星星
@property(nonatomic,copy)NSString *isPinglun;//是否被评论

@property (nonatomic,assign,readonly) CGFloat textHeight;

@end
