//
//  ObviouslyEffectFlowLoyout.m
//  Album
//
//  Created by zhao on 2017/1/17.
//  Copyright © 2017年 zhao. All rights reserved.
//

#import "PPObviouslyEffectFlowLayout.h"

#define CollectionView_Width self.collectionView.frame.size.width
#define CollectionView_Height self.collectionView.frame.size.height

@implementation PPObviouslyEffectFlowLayout

/**
 * 初始化操作 一般放在这个方法中
 */
- (void)prepareLayout
{
    CGFloat leftMargin = (CollectionView_Width - Item_Width) / 2.0;
    CGFloat topMargin = 
    // 水平间距
    self.minimumLineSpacing = leftMargin - 30;
    // 滚动方向 水平
    self.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    self.itemSize = CGSizeMake(Item_Width, Item_Height);
    self.sectionInset = UIEdgeInsetsMake(topMargin, leftMargin, topMargin, leftMargin);
}

// 返回值为YES 会自动调用layoutAttributesForElementsInRect:刷新布局
- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds
{
    return YES;
}

- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect
{
    NSArray *array = [super layoutAttributesForElementsInRect:rect];
    // contentOffset.x到屏幕中心的距离
    CGFloat contentX = self.collectionView.contentOffset.x + CollectionView_Width * 0.5;
    // 距离屏幕中心越近 放大倍数越大
    for (UICollectionViewLayoutAttributes *attri in array)
    {
        CGFloat targetX = contentX - attri.center.x;
        CGFloat scale = 1.3 - ABS(targetX / CollectionView_Width * 0.5);
        attri.transform = CGAffineTransformMakeScale(scale, scale);
    }
    return array;
}

// 最终偏移量
- (CGPoint)targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset withScrollingVelocity:(CGPoint)velocity
{
    NSArray *array = [super layoutAttributesForElementsInRect:CGRectMake(proposedContentOffset.x, 0, CollectionView_Width, CollectionView_Height)];
    
    // contentOffset.x到屏幕中心的距离
    CGFloat contentX = proposedContentOffset.x + CollectionView_Width * 0.5;
    CGFloat minMargin = MAXFLOAT;
    for (UICollectionViewLayoutAttributes *attr in array)
    {
        if (ABS(minMargin) > ABS(attr.center.x - contentX))
        {
            minMargin = attr.center.x - contentX;
        }
    }
    proposedContentOffset.x += minMargin;
    return proposedContentOffset;
}


@end
