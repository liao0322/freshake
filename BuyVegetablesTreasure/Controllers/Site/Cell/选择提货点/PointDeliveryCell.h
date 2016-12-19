//
//  PointDeliveryCell.h
//  VegetablesApp
//
//  Created by M on 16/6/6.
//  Copyright © 2016年 M. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Map.h"

@interface PointDeliveryCell : UITableViewCell

@property (nonatomic, strong) Map *model;
@property (nonatomic, assign) NSInteger spacing;

@end
