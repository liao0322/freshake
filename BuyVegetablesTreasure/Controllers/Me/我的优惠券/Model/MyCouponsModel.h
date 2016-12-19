//
//  MyCouponsModel.h
//  BuyVegetablesTreasure
//
//  Created by XiaoBeiMAC on 15/11/2.
//  Copyright © 2015年 c521xiong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyCouponsModel : NSObject

@property(nonatomic,copy)NSString *AddTime;//添加时间
@property(nonatomic,copy)NSNumber *ExpileDate;//有效期
@property(nonatomic,copy)NSNumber *Id;//优惠券ID
@property(nonatomic,copy)NSNumber *IsExpileDate;//1、0  有效、否
@property(nonatomic,copy)NSNumber *IsReceive;//1、0领取、未领取
@property(nonatomic,copy)NSString *Mobile;//电话
@property(nonatomic,copy)NSString *Price;  //价格
@property(nonatomic,copy)NSString *SN;//密码
@property(nonatomic,copy)NSNumber *TickId;//没有用的ID
@property(nonatomic,copy)NSString *TickName;  //优惠券名字
@property(nonatomic,copy)NSNumber *UserId;  //用户ID
@property(nonatomic,copy)NSNumber *consumeMoney; //满多少金额使用
@property(nonatomic,copy)NSNumber *hasLingQu;//1、领取 2、未
@property(nonatomic,copy)NSNumber *usedContent;//使用规则
@property (nonatomic, copy) NSString *Remark;

@property(nonatomic,copy)NSString *isSelect;//是否被选中
@end
