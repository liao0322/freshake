//
//  TetabBarBtn.h
//  PocketKitchen
//
//  Created by mac on 15-4-28.
//  Copyright (c) 2015年 yuanjinsong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TetabBarBtn : UIView
{
    UIImageView *_iconImageView;
    UILabel     *_titlelabel;
    UIImage     *_selectedImg;
    UIImage     *_unselectedImg;
}

@property(nonatomic,assign)BOOL selected;

-(instancetype)initWithFrame:(CGRect)frame
                       title:(NSString *)title
               selectedImage:(UIImage *)selectedImage
             unselectedImage:(UIImage *)unselectedImage;

@end
