//
//  EditNumberView.h
//  BuyVegetablesTreasure
//
//  Created by M on 16/12/12.
//  Copyright © 2016年 c521xiong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EditNumberView : UIView

@property (nonatomic, strong) NSString *numberString;
@property (nonatomic, strong) void (^editGoodsNumber)(BOOL isAdd, int goodsNum);

@end
