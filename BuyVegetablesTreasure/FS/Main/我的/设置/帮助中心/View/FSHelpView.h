//
//  FSHelpView.h
//  BuyVegetablesTreasure
//
//  Created by 江玉元 on 2016/12/20.
//  Copyright © 2016年 c521xiong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FSHelpView : UIView

@property (nonatomic, strong) NSArray *dataSource;
@property (nonatomic, copy) void(^goViewController)(UIViewController *viewController);

- (void)refreshTableView;

@end
