//
//  OrderReviceModel.m
//  BuyVegetablesTreasure
//
//  Created by XiaoBeiMAC on 15/11/14.
//  Copyright © 2015年 c521xiong. All rights reserved.
//

#import "OrderReviceModel.h"

@implementation OrderReviceModel
-(void)setContext:(NSString *)Context{
    _Context=Context;
    CGRect rect=[_Context boundingRectWithSize:CGSizeMake(SCREEN_WIDTH-40, 3000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]} context:nil];
    if (rect.size.height<=30) {
        _contextHeight=30;
    }else{
        _contextHeight=rect.size.height;
    }
}
-(id)valueForUndefinedKey:(NSString *)key
{
    return nil;
}
-(void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    
}
@end
