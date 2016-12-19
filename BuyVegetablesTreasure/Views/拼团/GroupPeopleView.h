//
//  GroupPeopleView.h
//  BuyVegetablesTreasure
//
//  Created by XiaoBeiMAC on 15/11/27.
//  Copyright © 2015年 c521xiong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GroupPeopleView : UIView
@property(nonatomic,strong)void(^shar)();
-(id)initWithFrame:(CGRect)frame andNumberOfPeople:(int)numberStr;
@end
