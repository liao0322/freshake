//
//  SubmitGroupViewController.h
//  BuyVegetablesTreasure
//
//  Created by XiaoBeiMAC on 15/11/27.
//  Copyright © 2015年 c521xiong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GroupModel.h"

@interface SubmitGroupViewController : UIViewController

@property (nonatomic, strong) GroupModel *groupModel;
@property (nonatomic, assign) BOOL isUpdate;

@end
