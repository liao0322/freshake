//
//  FirstStarView.m
//  BuyVegetablesTreasure
//
//  Created by XiaoBeiMAC on 15/11/12.
//  Copyright © 2015年 c521xiong. All rights reserved.
//

#import "FirstStarView.h"

@implementation FirstStarView

-(instancetype)initWithFrame:(CGRect)frame{
    self=[super initWithFrame:frame];
    if (self) {
        _firstStartScrollView=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        _firstStartScrollView.delegate=self;
        _firstStartScrollView.bounces=NO;
        _firstStartScrollView.pagingEnabled=YES;
        _firstStartScrollView.showsVerticalScrollIndicator=NO;
        _firstStartScrollView.showsHorizontalScrollIndicator=NO;
        _firstStartScrollView.contentSize=CGSizeMake(SCREEN_WIDTH*3, SCREEN_HEIGHT);
        [self addSubview:_firstStartScrollView];
        
        for (int i=0; i<3; i++)
        {
            UIImageView *_fIamgeView=[[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH*i, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
            if (SCREEN_HEIGHT<=480) {
                _fIamgeView.image=[UIImage imageNamed:[NSString stringWithFormat:@"960启动页%d",i+1]];
            }else{
                _fIamgeView.image=[UIImage imageNamed:[NSString stringWithFormat:@"1136启动页%d",i+1]];
            }
            
            if (i==2) {
                _fIamgeView.userInteractionEnabled=YES;
                UITapGestureRecognizer *_tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(touchImageView:)];
                [_fIamgeView addGestureRecognizer:_tap];
            }
            [_firstStartScrollView addSubview:_fIamgeView];
        }
        _firstStartPageControl= [[UIPageControl alloc] initWithFrame:CGRectMake((SCREEN_WIDTH-80)/2,SCREEN_HEIGHT-40, 80, 40)];
        _firstStartPageControl.numberOfPages =3;
        _firstStartPageControl.backgroundColor=[UIColor clearColor];
        _firstStartPageControl.currentPageIndicatorTintColor =[UIColor redColor];
        _firstStartPageControl.hidesForSinglePage=YES;
        _firstStartPageControl.pageIndicatorTintColor = [UIColor colorWithRed:140/255.0 green:167/255.0 blue:185/255.0 alpha:1.0];
        [self addSubview:_firstStartPageControl];
    }
    return self;
}
#pragma mark - UIScrollViewDelegate
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    if (scrollView==_firstStartScrollView) {
        int numberOfScrollViewSet=_firstStartScrollView.contentOffset.x/SCREEN_WIDTH;
        //计算当前页数
        _firstStartPageControl.currentPage = numberOfScrollViewSet;
    }
}
-(void)touchImageView:(UITapGestureRecognizer *)tap{
    [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"firstStart"];
    //是否第一次选择
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"firstSelect"];

    [[NSUserDefaults standardUserDefaults] synchronize];
    
    _removeFirstViewBlock();
    
    //    [self removeFromSuperview];
}
@end
