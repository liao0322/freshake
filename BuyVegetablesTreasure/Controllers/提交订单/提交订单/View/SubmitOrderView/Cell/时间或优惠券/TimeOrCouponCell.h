//
//  TimeOrCouponCell.h
//  BuyVegetablesTreasure
//
//  Created by M on 16/9/13.
//
//

#import <UIKit/UIKit.h>

@interface TimeOrCouponCell : UITableViewCell

/// 优惠券
@property (nonatomic, strong) NSString *couponString;
/// 时间
@property (nonatomic, strong) NSString *timeString;

@end
