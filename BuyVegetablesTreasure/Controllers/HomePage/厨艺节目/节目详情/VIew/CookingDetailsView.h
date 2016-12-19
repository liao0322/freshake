//
//  CookingDetailsView.h
//  BuyVegetablesTreasure
//
//  Created by M on 16/4/29.
//  Copyright © 2016年 c521xiong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CookingDetailsView : UIView

@property (nonatomic, copy) NSMutableArray *dataSource;

- (void)refreshTableView;

@end
