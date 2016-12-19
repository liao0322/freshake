//
//  OrderDetailUserModel.m
//  BuyVegetablesTreasure
//
//  Created by XiaoBeiMAC on 15/10/29.
//  Copyright © 2015年 c521xiong. All rights reserved.
//

#import "OrderDetailUserModel.h"

@implementation OrderDetailUserModel

-(void)setAddress:(NSString *)address{
    _address=address;
    CGRect rect=[_address boundingRectWithSize:CGSizeMake(SCREEN_WIDTH-120, 3000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]} context:nil];
    if (rect.size.height<=20) {
         _addressHeight=20;
    }else{
        _addressHeight=rect.size.height;
    }
}
-(void)setMessage:(NSString *)message{
    _message=message;
    CGRect rect=[_message boundingRectWithSize:CGSizeMake(SCREEN_WIDTH-120, 3000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]} context:nil];
    if (rect.size.height<=30) {
        _messageHeight=30;
    }else{
       _messageHeight=rect.size.height;
    }
    
}
-(void)setInvoiceTitle:(NSString *)InvoiceTitle{
    _InvoiceTitle=InvoiceTitle;
    CGRect rect=[_InvoiceContent boundingRectWithSize:CGSizeMake(SCREEN_WIDTH-120, 3000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]} context:nil];
    if (rect.size.height<=30) {
        _InvoiceTitleHeight=30;
    }else{
        _InvoiceTitleHeight=rect.size.height;
    }
}
-(void)setInvoiceContent:(NSString *)InvoiceContent{
    _InvoiceContent=InvoiceContent;
    CGRect rect=[_InvoiceContent boundingRectWithSize:CGSizeMake(SCREEN_WIDTH-120, 3000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]} context:nil];
    if (rect.size.height<=30) {
        _InvoiceContentHeight=30;
    }else{
        _InvoiceContentHeight=rect.size.height;
    }
}
-(instancetype)init
{
    self = [super init];
    if (self)
    {
        _list = [NSMutableArray array];
    }
    return self;
}

-(id)valueForUndefinedKey:(NSString *)key
{
    return nil;
}
-(void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    
}
@end
