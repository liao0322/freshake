//
//  GroupHeadView.h
//  BuyVegetablesTreasure
//
//  Created by XiaoBeiMAC on 15/11/27.
//  Copyright © 2015年 c521xiong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GroupHeadView : UIView

@property(nonatomic,strong)UILabel *storeLabel;
@property(nonatomic,strong)void(^choiceStore)();

@end
