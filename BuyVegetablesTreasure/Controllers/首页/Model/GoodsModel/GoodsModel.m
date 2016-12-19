//
//  GoodsModel.m
//  VegetablesApp
//
//  Created by M on 16/5/27.
//  Copyright © 2016年 M. All rights reserved.
//

#import "GoodsModel.h"

@implementation GoodsModel

@synthesize id = _id;

- (instancetype)init {
    
    self = [super init];
    if (self) {
        
        self.isSelect = YES;
        self.defaultImg = IMAGE(@"列表页未成功图片");
    }
    return self;
}

@end
