//
//  OrderAddressCell.h
//  BuyVegetablesTreasure
//
//  Created by M on 16/9/5.
//
//

#import <UIKit/UIKit.h>
#import "MyOrderDetailsModel.h"

@interface OrderAddressCell : UITableViewCell

@property (nonatomic, strong) NSArray *textArray;
@property (nonatomic, strong) MyOrderDetailsModel *orderDetailsModel;

@end
