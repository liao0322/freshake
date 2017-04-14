//
//  CompileNumber.h
//  BuyVegetablesTreasure
//
//  Created by sc on 15/10/15.
//  Copyright (c) 2015年 c521xiong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CompileNumber : UIView

@property (nonatomic, copy) UILabel *goodsSumLabel;
@property (nonatomic, copy) UIButton *reduceGoodsQuantityBtn;
@property (nonatomic, copy) UIButton *addGoodsQuantityBtn;

@property (nonatomic, assign) BOOL isDel;
@property (nonatomic, assign) BOOL isUpselling;
@property (nonatomic, assign) NSInteger stork;
@property (nonatomic, assign) NSInteger num;
@property (nonatomic, copy) void(^addBlock)(NSString *goodsNumberString);
@property (nonatomic, copy) void(^goodsNumberBlock)(NSString *goodsNumberString,BOOL isStork,BOOL isDel,BOOL isAdd);
@property (nonatomic, copy) void(^storkBlock)();

@end
