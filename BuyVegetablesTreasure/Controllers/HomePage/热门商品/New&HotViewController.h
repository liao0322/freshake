//
//  New&HotViewController.h
//  BuyVegetablesTreasure
//
//  Created by Song on 16/1/12.
//  Copyright © 2016年 c521xiong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface New_HotViewController : UIViewController

@property (nonatomic, copy) NSString *Navtitle;        // 导航条标题
@property (nonatomic, copy) NSString *specialOffer;    // 是否促销
@property (nonatomic, copy) NSString *latest;          // 是否新品
@property (nonatomic, assign) BOOL isNewGoods;

@end
