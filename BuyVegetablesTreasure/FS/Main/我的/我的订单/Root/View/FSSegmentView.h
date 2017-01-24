//
//  FSSegmentView.h
//  BuyVegetablesTreasure
//
//  Created by DamonLiao on 2017/1/18.
//  Copyright © 2017年 c521xiong. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FSSegmentView;

@protocol FSSegmentViewDelegate <NSObject>

- (void)segmentView:(FSSegmentView *)segmentView didSelectedIndex:(NSInteger)index;

@end

@interface FSSegmentView : UIView

@property (weak, nonatomic) id<FSSegmentViewDelegate> delegate;

- (instancetype)initWithTitles:(NSArray *)titles;

- (void)selectIndex:(NSInteger)index;

@end
