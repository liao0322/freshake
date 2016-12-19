//
//  SelectCityPickerView.h
//  BuyVegetablesTreasure
//
//  Created by sc on 15/11/9.
//  Copyright © 2015年 c521xiong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SelectCityPickerView : UIView

@property (nonatomic, copy) UIPickerView *provincePickerView;
@property (nonatomic, copy) void(^btnClickBlock)(NSString *block);

@end
