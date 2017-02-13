//
//  XFMeBottomTVCell.h
//  BuyVegetablesTreasure
//
//  Created by DamonLiao on 2017/2/11.
//  Copyright © 2017年 c521xiong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XFMeBottomTVCell : UITableViewCell

@property (nonatomic) void(^myGroupBuyBlock)();
@property (nonatomic) void(^myCouponsBlock)();
@property (nonatomic) void(^myFavouriteBlock)();
@property (nonatomic) void(^myAddressBlock)();
@property (nonatomic) void(^helpCenterBlock)();
@property (nonatomic) void(^customerServiceBlock)();

@end
