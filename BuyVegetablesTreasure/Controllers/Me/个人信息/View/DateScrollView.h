//
//  DateScrollView.h
//  BuyVegetablesTreasure
//
//  Created by sc on 15/11/2.
//  Copyright © 2015年 c521xiong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DateScrollView : UIView

@property (nonatomic, copy) NSString *dateString;
@property (nonatomic, copy) void(^dateBlock)(NSString *dateString);

@end
