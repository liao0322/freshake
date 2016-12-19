//
//  DeliveryTimeView.h
//  BuyVegetablesTreasure
//
//  Created by M on 16/6/20.
//  Copyright © 2016年 c521xiong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DeliveryTimeView : UIView<UIPickerViewDataSource,UIPickerViewDelegate>

@property (nonatomic, copy) void(^selectTime)(NSString *timeString);

@end
