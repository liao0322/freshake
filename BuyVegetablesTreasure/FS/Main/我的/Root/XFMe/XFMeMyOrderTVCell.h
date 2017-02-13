//
//  XFMeMyOrderTVCell.h
//  BuyVegetablesTreasure
//
//  Created by DamonLiao on 2017/2/10.
//  Copyright © 2017年 c521xiong. All rights reserved.
//

#import <UIKit/UIKit.h>
@class XFMeVerticalButton;

@interface XFMeMyOrderTVCell : UITableViewCell

@property (weak, nonatomic) IBOutlet XFMeVerticalButton *waitForPayButton;
@property (weak, nonatomic) IBOutlet XFMeVerticalButton *waitForPickUpButton;
@property (weak, nonatomic) IBOutlet XFMeVerticalButton *pickedButton;

@property (weak, nonatomic) IBOutlet XFMeVerticalButton *waitForCommentButton;

@property (nonatomic) void(^viewAllOrdersBlock)();
@property (nonatomic) void(^waitForPayBlock)();
@property (nonatomic) void(^waitForPickUpBlock)();
@property (nonatomic) void(^pickedBlock)();
@property (nonatomic) void(^waitForCommentBlock)();

@end
