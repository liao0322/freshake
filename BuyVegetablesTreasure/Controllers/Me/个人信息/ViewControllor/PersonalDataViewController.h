//
//  PersonalDataViewController.h
//  BuyVegetablesTreasure
//
//  Created by sc on 15/10/30.
//  Copyright © 2015年 c521xiong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PersonalDataViewController : UITableViewController

@property(nonatomic,copy)void(^changeImage)();
@property(nonatomic,copy)NSString *point;

@end
