//
//  SelectStoreDeliveryView.h
//  BuyVegetablesTreasure
//
//  Created by sc on 16/3/30.
//  Copyright © 2016年 c521xiong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Map.h"

@interface SelectStoreDeliveryView : UIView<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, copy) NSArray *siteArray;
@property (nonatomic, copy) void(^midSite)(Map *mapArray);
@property (nonatomic, copy) void(^userAddress)(Map *mapArray);

- (void)refreshSite;

@end
