//
//  CityPickerView.h
//  BuyVegetablesTreasure
//
//  Created by sc on 16/3/31.
//  Copyright © 2016年 c521xiong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CityPickerView : UIView<UIPickerViewDataSource,UIPickerViewDelegate>

@property (nonatomic, copy) NSString *cityString;
@property (nonatomic, copy) NSArray *cityArray;
@property (nonatomic, copy) NSArray *cityIdArray;

@property (nonatomic, copy) void(^buttonClickBlock)(NSString *cityString);

- (void)refreshCity;

@end
