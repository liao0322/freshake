//
//  ButtonView.h
//  BuyVegetablesTreasure
//
//  Created by Song on 16/1/12.
//  Copyright © 2016年 c521xiong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ButtonView : UIView

@property(nonatomic,strong)void(^refreshUI)(NSInteger index);

@end
