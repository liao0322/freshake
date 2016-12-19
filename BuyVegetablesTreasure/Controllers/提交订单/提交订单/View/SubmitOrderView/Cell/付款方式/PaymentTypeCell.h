//
//  PaymentTypeCell.h
//  BuyVegetablesTreasure
//
//  Created by M on 16/9/9.
//
//

#import <UIKit/UIKit.h>

@interface PaymentTypeCell : UITableViewCell

@property (nonatomic, assign) NSInteger currentIndex;
@property (nonatomic, assign) NSInteger payId;
@property (nonatomic, strong) UIButton *paymentBtn;

@end
