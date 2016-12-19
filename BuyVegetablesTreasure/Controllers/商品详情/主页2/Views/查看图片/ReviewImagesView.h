//
//  ReviewImagesView.h
//  BuyVegetablesTreasure
//
//  Created by M on 16/11/28.
//  Copyright © 2016年 c521xiong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EvaluationModel.h"

@interface ReviewImagesView : UIView <UIScrollViewDelegate>

@property (nonatomic, strong) EvaluationModel *model;
@property (nonatomic, strong) UIScrollView *imgScrollView;
@property (nonatomic, assign) NSInteger index;

@end
