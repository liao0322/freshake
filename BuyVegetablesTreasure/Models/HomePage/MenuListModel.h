//
//  MenuListModel.h
//  BuyVegetablesTreasure
//
//  Created by sc on 15/10/22.
//  Copyright (c) 2015年 c521xiong. All rights reserved.
//

#import "ParentModel.h"

@interface MenuListModel : ParentModel

@property (nonatomic, copy) NSString *ico_url ;     // 图标
@property (nonatomic, copy) NSString *id ;          // ID,
@property (nonatomic, copy) NSString *img_url ;     // 图片链接
@property (nonatomic, copy) NSString *title ;       // 名字

@end
