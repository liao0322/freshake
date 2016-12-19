//
//  ShowGifView.h
//  BuyVegetablesTreasure
//
//  Created by Linf on 15/10/27.
//  Copyright © 2015年 c521xiong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShowGifView : UIView

@property(nonatomic,strong)UIView *gifView;
@property(nonatomic,strong)UIImageView *gifImageView;
@property(nonatomic,strong)NSString *playStr;


- (id)initWithFrame:(CGRect)frame fileURL:(NSURL*)fileURL;
- (void)startGif;
- (void)stopGif;
+ (NSArray*)framesInGif:(NSURL*)fileURL;

@property (nonatomic, copy) void(^GifStop)();

@end
