//
//  CostCell.h
//  BuyVegetablesTreasure
//
//  Created by M on 16/9/9.
//
//

#import <UIKit/UIKit.h>
#import "ShopCart.h"

@interface CostCell : UITableViewCell

// 优惠券价格
@property (nonatomic, assign) CGFloat couponPrice;
// 运费
@property (nonatomic, assign) CGFloat freight;
@property (nonatomic, strong) ShopCart *goodsModel;

@end
