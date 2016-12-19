//
//  BannerView.h
//  BuyVegetablesTreasure
//
//  Created by M on 16/12/8.
//  Copyright © 2016年 c521xiong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AdvertisingModel.h"

@interface BannerView : UIView

@property (nonatomic, strong) NSArray *bannerArray;
@property (nonatomic, strong) void(^iconBtnClick)(NSInteger index);
@property (nonatomic, strong) void(^bannerClick)(AdvertisingModel *model);

@end
