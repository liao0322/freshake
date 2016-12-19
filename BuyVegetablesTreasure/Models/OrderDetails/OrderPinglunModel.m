//
//  OrderPinglunModel.m
//  BuyVegetablesTreasure
//
//  Created by XiaoBeiMAC on 15/11/14.
//  Copyright © 2015年 c521xiong. All rights reserved.
//

#import "OrderPinglunModel.h"

@implementation OrderPinglunModel

-(void)setPinglunText:(NSString *)pinglunText{
    _pinglunText=pinglunText;
    CGRect rect=[_pinglunText boundingRectWithSize:CGSizeMake(SCREEN_WIDTH-40, 3000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]} context:nil];
    if (rect.size.height<=30) {
        _textHeight=30;
    }else{
        _textHeight=rect.size.height;
    }
}

@end
