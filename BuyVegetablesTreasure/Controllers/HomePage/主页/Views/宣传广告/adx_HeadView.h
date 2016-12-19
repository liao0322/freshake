//
//  adx_HeadView.h
//  BuyVegetablesTreasure
//
//  Created by sc on 16/3/17.
//  Copyright © 2016年 c521xiong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface adx_HeadView : UICollectionReusableView<SDCycleScrollViewDelegate>

@property (nonatomic, copy) SDCycleScrollView *bannerScrollView;
@property (nonatomic, copy) void(^picBlock)(NSInteger index);

@end
