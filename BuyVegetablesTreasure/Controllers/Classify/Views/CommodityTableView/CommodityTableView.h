//
//  CommodityTableView.h
//  BuyVegetablesTreasure
//
//  Created by M on 16/4/20.
//  Copyright © 2016年 c521xiong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CommodityTableView : UIView<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, copy) UITableView *commodityTableView;
@property (nonatomic, copy) NSArray *commodityArray;
@property (nonatomic, assign) NSInteger goodsNumber;

@property (nonatomic, copy) void(^moveType)(NSInteger index);
@property (nonatomic, copy) void(^updateGoods)(NSString *urlString, NSIndexPath *indexPath);
@property (nonatomic, copy) void(^goViewController)(UIViewController *viewController);
@property (nonatomic, copy) void(^addCartAnimation)(CGRect frame,UIImage *image);

- (void)refreshTableView;
- (void)moveSection:(NSInteger)index;

@end
