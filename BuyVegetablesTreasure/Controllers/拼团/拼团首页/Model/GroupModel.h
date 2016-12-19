//
//  GroupModel.h
//  BuyVegetablesTreasure
//
//  Created by M on 16/4/7.
//  Copyright © 2016年 c521xiong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ParentModel.h"

@interface GroupModel : ParentModel

@property (nonatomic, copy) NSString *ActivityEtime;    // 活动结束时间
@property (nonatomic, copy) NSString *ActivityName ;    // 团购名称
@property (nonatomic, copy) NSString *ActivityPrice;    // 价格
@property (nonatomic, copy) NSString *ActivityStime;    // 活动开始时间
@property (nonatomic, copy) NSString *ActivityStock;    // 库存
@property (nonatomic, copy) NSString *ActivityType ;    // 活动类型
@property (nonatomic, copy) NSString *ActivityUserNum;  // 活动参加人数
@property (nonatomic, copy) NSString *AddDate ;         // 创建有效期
@property (nonatomic, copy) NSString *AddTime ;         // 创建时间
@property (nonatomic, copy) NSString *AddUserId ;       // 团长ID
@property (nonatomic, copy) NSString *AddUserName ;     // 创建人姓名
@property (nonatomic, copy) NSString *Id ;              // 7,
@property (nonatomic, copy) NSString *PayDdate ;        // 支付有效期
@property (nonatomic, copy) NSString *ProductId ;       // 商品ID
@property (nonatomic, copy) NSString *ProductName ;     // 商品名称
@property (nonatomic, copy) NSString *Remark ;          // 备注
@property (nonatomic, copy) NSString *SoldStock ;       // 已售库存
@property (nonatomic, copy) NSString *Specifications ;  // 44,
@property (nonatomic, copy) NSString *salePrice ;       // 商品销售价格
@property (nonatomic, copy) NSString *shortDesc ;       // 
@property (nonatomic, copy) NSString *thumbnailsUrll ;  // 商品图片
@property (nonatomic, copy) NSString *virtuaStock ;     // 

@property(nonatomic, assign) CGFloat titleHight;        // 文本高度

@end
