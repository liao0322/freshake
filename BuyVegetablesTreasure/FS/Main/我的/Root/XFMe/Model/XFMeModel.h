//
//  XFMeModel.h
//  BuyVegetablesTreasure
//
//  Created by DamonLiao on 2017/3/23.
//  Copyright © 2017年 c521xiong. All rights reserved.
//

#import "FSBaseModel.h"

@interface XFMeModel : FSBaseModel

@property (copy, nonatomic) NSString *title;
@property (copy, nonatomic) NSString *imageName;

- (instancetype)initWithTitle:(NSString *)title imageName:(NSString *)imageName;
@end
