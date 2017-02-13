//
//  OtherCell.h
//  BuyVegetablesTreasure
//
//  Created by M on 16/9/6.
//
//

#import <UIKit/UIKit.h>
#import "MyOrderDetailsModel.h"

@interface OtherCell : UITableViewCell

@property (nonatomic, strong) MyOrderDetailsModel *orderDetailsModel;

- (void)setOrderModel:(MyOrderDetailsModel *)orderDetailsModel indexPath:(NSIndexPath *)indexPath;


//@property (nonatomic) void(^viewExpressBlock)();

@property (nonatomic) void(^pushViewController)(UIViewController *viewController);

@end
