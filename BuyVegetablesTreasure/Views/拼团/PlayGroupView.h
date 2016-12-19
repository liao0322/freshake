//
//  PlayGroupView.h
//  BuyVegetablesTreasure
//
//  Created by XiaoBeiMAC on 15/11/26.
//  Copyright © 2015年 c521xiong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PlayGroupView : UIView

@property(nonatomic,strong)NSString *NStr;
@property(nonatomic,strong)void(^goPlayGroup)();

-(id)initWithFrame:(CGRect)frame andShowNumber:(NSString *)numberStr;

@end
