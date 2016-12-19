//
//  GoodsCartTableView.h
//  BuyVegetablesTreasure
//
//  Created by M on 16/4/21.
//  Copyright © 2016年 c521xiong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GoodsCartTableView : UIView

@property (nonatomic, copy) NSArray *goodsCartArray;
@property (nonatomic, copy) NSIndexPath *indexPath;
@property (nonatomic, assign) NSInteger goodsNumber;

@property (nonatomic, copy) NSString *point;
@property (nonatomic, copy) NSString *tick;

@property (nonatomic, copy) void(^bottomViewBlock)();
@property (nonatomic, copy) void(^deleteCartGoods)(NSString *goodsID);
@property (nonatomic, copy) void(^upCartGoodsNumber)(NSInteger productNum,NSString *productId,BOOL type);

- (void)refreshTableView;

@end
