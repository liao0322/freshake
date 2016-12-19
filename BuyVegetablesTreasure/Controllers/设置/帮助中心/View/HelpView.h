//
//  HelpView.h
//  BuyVegetablesTreasure
//
//  Created by M on 16/5/10.
//  Copyright © 2016年 c521xiong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HelpView : UIView

@property (nonatomic, strong) NSArray *dataSource;
@property (nonatomic, copy) void(^goViewController)(UIViewController *viewController);

- (void)refreshTableView;

@end
