//
//  AffirmPayment.h
//  BuyVegetablesTreasure
//
//  Created by sc on 15/10/15.
//  Copyright (c) 2015年 c521xiong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AffirmPayment : UIView

@property (nonatomic, copy) void (^gopPayment)(NSString *urlString);
@property (nonatomic, copy) UILabel *priceLabel;
@property (nonatomic, copy) UIButton *payBtn;

@end
