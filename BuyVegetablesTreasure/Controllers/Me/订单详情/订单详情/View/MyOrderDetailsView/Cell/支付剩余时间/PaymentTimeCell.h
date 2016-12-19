//
//  PaymentTimeCell.h
//  BuyVegetablesTreasure
//
//  Created by M on 16/9/7.
//
//

#import <UIKit/UIKit.h>
#import "MyOrderDetailsModel.h"

@interface PaymentTimeCell : UITableViewCell

@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) MyOrderDetailsModel *orderDetailsModel;

@end
