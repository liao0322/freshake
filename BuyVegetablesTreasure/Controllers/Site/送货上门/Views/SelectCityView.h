//
//  SelectCityView.h
//  BuyVegetablesTreasure
//
//  Created by sc on 16/3/29.
//  Copyright © 2016年 c521xiong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SelectCityView : UIView<UIPickerViewDataSource,UIPickerViewDelegate>

@property (nonatomic, copy) NSString *cityString;
@property (nonatomic, copy) NSArray *cityArray;

@property (nonatomic, copy) UIPickerView *selectCityPickerView;
@property (nonatomic, copy) void(^buttonClickBlock)(NSString *cityString);

@end
