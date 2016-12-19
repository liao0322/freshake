//
//  GroupFootView.h
//  BuyVegetablesTreasure
//
//  Created by XiaoBeiMAC on 15/11/27.
//  Copyright © 2015年 c521xiong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GroupFootView : UIView

@property(nonatomic,strong)NSString *butStr;
@property(nonatomic,strong)void(^goPay)(NSString *str);
@end
