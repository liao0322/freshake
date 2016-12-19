//
//  CookingProgramListModel.h
//  BuyVegetablesTreasure
//
//  Created by M on 16/5/10.
//  Copyright © 2016年 c521xiong. All rights reserved.
//

#import "ParentModel.h"

@interface CookingProgramListModel : ParentModel

// 添加时间
@property (nonatomic, copy) NSString *AddTime;
// 简介内容
@property (nonatomic, copy) NSString *CountText;
// 浏览次数
@property (nonatomic, copy) NSString *Flow;
// 主键id
@property (nonatomic, copy) NSString *Id;
// 材料
@property (nonatomic, copy) NSString *Material;
// 做法
@property (nonatomic, copy) NSString *Practice;
// 标题
@property (nonatomic, copy) NSString *Title;
// 视频路径
@property (nonatomic, copy) NSString *Vediourl;
// 是否收藏 1:已收藏 0:未收藏
@property (nonatomic, copy) NSString *isVedio;
// 图片
@property (nonatomic, copy) NSString *pic;

@end
