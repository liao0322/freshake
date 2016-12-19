//
//  OrderTotalView.h
//  BuyVegetablesTreasure
//
//  Created by M on 16/9/18.
//
//

#import <UIKit/UIKit.h>

@interface OrderTotalView : UIView

@property (nonatomic, strong) UILabel *priceLabel;
@property (nonatomic, strong) UIButton *payBtn;
@property (nonatomic, strong) void(^payInfo)();

/**
 *  设置订单价格
 *
 *  @param totalPrice  总价
 *  @param couponPrice 优惠券价格
 *  @param freight     运费
 */
- (CGFloat)setOrderTotalPrice:(CGFloat)totalPrice
                  couponPrice:(CGFloat)couponPrice
                      freight:(CGFloat)freight;

@end
