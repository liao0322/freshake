//
//  EvaluationModel.h
//  BuyVegetablesTreasure
//
//  Created by sc on 16/1/7.
//  Copyright © 2016年 c521xiong. All rights reserved.
//

#import "ParentModel.h"

@interface EvaluationModel : ParentModel

@property (nonatomic, copy) NSString *Context;      // 内容
@property (nonatomic, copy) NSString *Id;
@property (nonatomic, copy) NSString *ProductId;    // 商品ID
@property (nonatomic, copy) NSString *addTime;      // 时间
@property (nonatomic, copy) NSString *level;
@property (nonatomic, copy) NSString *orderId;
@property (nonatomic, copy) NSString *productName;  // 商品名称
@property (nonatomic, copy) NSString *userId;       // 用户ID
@property (nonatomic, copy) NSString *userName;     // 用户名称
@property (nonatomic, assign) NSInteger contHeight; // 内容高度
@property (nonatomic, copy) NSString *avatar;
@property (nonatomic, copy) NSArray *List;
@property (nonatomic, copy) NSString *image;
@property (nonatomic, copy) NSString *image1;
@property (nonatomic, copy) NSString *image2;
@property (nonatomic, copy) NSString *image3;
@property (nonatomic, copy) NSString *image4;

@end
