//
//  PaymentTypeView.h
//  BuyVegetablesTreasure
//
//  Created by M on 16/9/7.
//
//

#import <UIKit/UIKit.h>

@interface PaymentTypeView : UIView

@property (nonatomic, strong) void(^paymentId)(NSString *idString);

@end
