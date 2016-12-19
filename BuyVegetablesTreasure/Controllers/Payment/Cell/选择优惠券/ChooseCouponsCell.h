//
//  ChooseCouponsCell.h
//  VegetablesApp
//
//  Created by M on 16/6/14.
//  Copyright © 2016年 M. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChooseCouponsCell : UITableViewCell

/// 优惠券数量
@property (nonatomic, assign) NSInteger couponsNumber;
/// 优惠券Label
@property (nonatomic, strong) UILabel *couponsNumberLabel;
/// 标题Label
@property (nonatomic, strong) UILabel *titleLabel;
/// 标题
@property (nonatomic, strong) NSString *titleString;

@end
