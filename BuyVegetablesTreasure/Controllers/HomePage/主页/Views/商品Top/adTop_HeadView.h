//
//  adTop_HeadView.h
//  BuyVegetablesTreasure
//
//  Created by sc on 16/3/17.
//  Copyright © 2016年 c521xiong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomePageModel.h"

@interface adTop_HeadView : UICollectionReusableView

@property (nonatomic, copy) UIImageView *topImageView;
@property (nonatomic, copy) void(^topModel)(HomePageModel *model);

- (void)setTopImageWithArray:(NSArray *)arr;

@end
