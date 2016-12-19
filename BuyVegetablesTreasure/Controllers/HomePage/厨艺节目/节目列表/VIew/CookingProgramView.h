//
//  CookingProgramView.h
//  BuyVegetablesTreasure
//
//  Created by M on 16/4/26.
//  Copyright © 2016年 c521xiong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CookingProgramView : UIView

@property (nonatomic, copy) NSArray *dataSource;
@property (nonatomic, copy) void(^isCollect)(NSString *idString, NSString *nameString,BOOL isCollect);
@property (nonatomic, copy) void(^goViewController)(UIViewController *viewController);

- (void)refreshTableView;

@end
