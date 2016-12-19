//
//  XFCarouselView.m
//  BuyVegetablesTreasure
//
//  Created by DamonLiao on 2016/12/7.
//  Copyright © 2016年 c521xiong. All rights reserved.
//

#import "XFCarouselView.h"
#import "XFCarouselCell.h"

#define MaxSections 100

// 轮播的间隔时间
#define INTERVAL_TIME 3.0f

@interface XFCarouselView ()<UICollectionViewDelegate, UICollectionViewDataSource>

{
    CGPoint _beginOffset;
}

@property (nonatomic) UICollectionView *collectionView;
@property (nonatomic) UICollectionViewFlowLayout *flowLayout;
@property (nonatomic) UIPageControl *pageControl;
@property (nonatomic) NSTimer *timer;

@end

@implementation XFCarouselView

static NSString * const carouselCellID = @"carouselCellID";

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {

        self.backgroundColor = [UIColor clearColor];
        _imageUrlArray = [NSMutableArray array];
        
        [self addSubview:self.collectionView];
        [self addSubview:self.pageControl];

    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat carouselViewWidth = self.width;
    CGFloat carouselViewHeight = self.height;

    self.flowLayout.itemSize = CGSizeMake(carouselViewWidth, carouselViewHeight);
    self.collectionView.frame = CGRectMake(0, 0, carouselViewWidth, carouselViewHeight);

    self.pageControl.centerX = self.centerX;
    self.pageControl.bottom = self.bottom - 20;
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return MaxSections;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView
     numberOfItemsInSection:(NSInteger)section {
    
    return self.imageUrlArray.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                           cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    XFCarouselCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:carouselCellID forIndexPath:indexPath];
    cell.imageUrlString = self.imageUrlArray[indexPath.row];
    return cell;
}

#pragma mark - Getter、Setter

- (void)setImageUrlArray:(NSMutableArray *)imageUrlArray {
    
    if (imageUrlArray.count == 0) {
        return;
    }
    
    _imageUrlArray = imageUrlArray;
    
    [self.collectionView reloadData];
    
    [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:MaxSections * 0.5] atScrollPosition:UICollectionViewScrollPositionLeft animated:NO];
    
    self.pageControl.numberOfPages = _imageUrlArray.count;
    [self addTimer];
    
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.delegate respondsToSelector:@selector(carouselView:didSelectItemAtIndexPath:)]) {
        [self.delegate carouselView:self didSelectItemAtIndexPath:indexPath];
    }
}


#pragma mark - Custom

- (void)addTimer {
    if (self.timer) {
        return;
    }
    self.timer = [NSTimer scheduledTimerWithTimeInterval:INTERVAL_TIME target:self selector:@selector(nextPage) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];

}

- (void)removeTimer {
    if (!self.timer) {
        return;
    }
    [self.timer invalidate];
    self.timer = nil;
}

- (void)nextPage {
    
    NSIndexPath *currentIndexPath = [[self.collectionView indexPathsForVisibleItems] lastObject];
    NSIndexPath *currentIndexPathReset = [NSIndexPath indexPathForItem:currentIndexPath.item inSection:MaxSections * 0.5];
    
    [self.collectionView scrollToItemAtIndexPath:currentIndexPathReset atScrollPosition:UICollectionViewScrollPositionLeft animated:NO];
    
    NSInteger nextItem = currentIndexPathReset.item + 1;
    NSInteger nextSection = currentIndexPathReset.section;
    if (nextItem == self.imageUrlArray.count) {
        nextItem = 0;
        nextSection++;
    }
    NSIndexPath *nextIndexPath = [NSIndexPath indexPathForItem:nextItem inSection:nextSection];
    
    [self.collectionView scrollToItemAtIndexPath:nextIndexPath atScrollPosition:UICollectionViewScrollPositionLeft animated:YES];
    
    
}

#pragma mark - UIScrollViewDelegate

- (void) scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self removeTimer];
}

- (void) scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{

    [self addTimer];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    // 改变页码
    CGFloat offsetX = scrollView.contentOffset.x;
    CGFloat contentSizeWidth = self.imageUrlArray.count * scrollView.bounds.size.width;
    NSInteger currentSection = offsetX / contentSizeWidth;
    NSInteger tempIndex = (offsetX - currentSection * contentSizeWidth) / scrollView.bounds.size.width + 0.5;
    self.pageControl.currentPage = tempIndex;
}

#pragma mark - LazyLoad

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:self.flowLayout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.pagingEnabled = YES;
        _collectionView.backgroundColor = [UIColor clearColor];
        
        [_collectionView registerClass:[XFCarouselCell class] forCellWithReuseIdentifier:carouselCellID];
        
    }
    return _collectionView;
}

- (UICollectionViewFlowLayout *)flowLayout {
    if (!_flowLayout) {
        _flowLayout = [[UICollectionViewFlowLayout alloc] init];
        _flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _flowLayout.minimumLineSpacing = 0;
    }
    return _flowLayout;
}

- (UIPageControl *)pageControl {
    if (!_pageControl) {
        _pageControl = [[UIPageControl alloc] init];
        _pageControl.pageIndicatorTintColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5f];
        _pageControl.currentPageIndicatorTintColor = [UIColor colorDomina];
        _pageControl.backgroundColor = [UIColor orangeColor];
        _pageControl.enabled = NO;
        _pageControl.numberOfPages = self.imageUrlArray.count - 2;
    }
    return _pageControl;
}

@end
