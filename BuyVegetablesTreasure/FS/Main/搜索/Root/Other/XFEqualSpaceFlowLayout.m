//
//  XFEqualSpaceFlowLayout.m
//  BuyVegetablesTreasure
//
//  Created by DamonLiao on 2016/12/7.
//  Copyright © 2016年 c521xiong. All rights reserved.
//

#import "XFEqualSpaceFlowLayout.h"

@interface XFEqualSpaceFlowLayout ()

@property (copy, nonatomic) NSMutableArray *itemAttributes;

@end

@implementation XFEqualSpaceFlowLayout

#pragma mark - Override

- (instancetype)init {
    self = [super init];
    if (self) {
        
        
    }
    return self;
}


// 用来做布局的初始化操作，不建议在init方法中进行布局的初始化操作
- (void)prepareLayout {
    [super prepareLayout];
}



/**
 *  UICollectionViewLayoutAttributes *attrs;
 *  1.一个cell对应一个UICollectionViewLayoutAttributes对象
 *  2.UICollectionViewLayoutAttributes对象决定了cell的展示样式(frame)
 */


/**
 *  这个方法的返回值是一个数组（数组里面存放着rect范围内所有元素的布局属性），也就是说决定了rect范围内所有元素的排布(frame)
 *
 */
- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect {
    
    // 获得super已经计算好的布局属性
    NSArray *attributes = [super layoutAttributesForElementsInRect:rect];

    BOOL isSkip = NO;
    for (int i = 1; i < [attributes count]; ++i) {
        // 当前attributes
        UICollectionViewLayoutAttributes *currentLayoutAttributes = attributes[i];
        // 当前section
        NSInteger currentSection = currentLayoutAttributes.indexPath.section;

        if (currentSection == 1 && isSkip == NO) {

            isSkip = YES;
            continue;
        }
        
        // 上一个attributes
        UICollectionViewLayoutAttributes *prevLayoutAttributes = attributes[i - 1];
        
        // 我们想设置的最大间距，可根据需要改
        NSInteger spacing = 15;
        
        // 前一个cell的最右边
        NSInteger right = CGRectGetMaxX(prevLayoutAttributes.frame);
        // 如果当前一个cell的最右边加上我们想要的间距加上当前cell的宽度依然在contentSize中，我们改变当前cell的原点位置
        if(right + spacing + currentLayoutAttributes.frame.size.width + 15 < self.collectionViewContentSize.width) {
            CGRect frame = currentLayoutAttributes.frame;
            frame.origin.x = right + spacing;
            currentLayoutAttributes.frame = frame;
        }
        
        

    }
    return attributes;

}


- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds {
    
    return NO;
}


@end
