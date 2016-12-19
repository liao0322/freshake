//
//  SettingView.h
//  BuyVegetablesTreasure
//
//  Created by M on 16/5/10.
//  Copyright © 2016年 c521xiong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SettingView : UIView

@property (nonatomic, copy) void(^goViewController)(UIViewController *viewController);
@property (nonatomic, copy) void(^LogOut)();

- (void)refreshTableView;

@end
