//
//  ImageCollectionViewLayout.swift
//  LoopRollingCollectionView
//
//  Created by 吴磊 on 15/3/24.
//  Copyright (c) 2015年 吴磊. All rights reserved.
//

import UIKit

let kLineBigSpacing:CGFloat = 35
let kItemWidth:CGFloat = 205

class ImageCollectionViewLayout: UICollectionViewFlowLayout {
    let kItemHeight:CGFloat = 316
    var kActiveDistance:CGFloat?
    let kZoomFactor = 0.0752
    override func awakeFromNib() {
        super.awakeFromNib()
        self.itemSize = CGSizeMake(kItemWidth, kItemHeight)
        self.scrollDirection = UICollectionViewScrollDirection.Horizontal
        self.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0)
        self.minimumLineSpacing = kLineBigSpacing
        self.minimumInteritemSpacing = 0
        self.kActiveDistance = UIScreen.mainScreen().bounds.width / 2
    }
    
    override func shouldInvalidateLayoutForBoundsChange(newBounds: CGRect) -> Bool {
        return true
    }
    
    override func layoutAttributesForElementsInRect(rect: CGRect) -> [AnyObject]? {
        var array = super.layoutAttributesForElementsInRect(rect)! as NSArray
        var visibleRect = CGRectMake(self.collectionView!.contentOffset.x, self.collectionView!.contentOffset.y, self.collectionView!.bounds.size.width, self.collectionView!.bounds.size.height)
        var size:CGSize = self.itemSize
        
        for object in array {
            let attributes = object as UICollectionViewLayoutAttributes
            if (CGRectIntersectsRect(attributes.frame, visibleRect)) {
                var distance:CGFloat = CGRectGetMidX(visibleRect) - attributes.center.x
                var normalizedDistance:CGFloat = distance / self.kActiveDistance!
                if (abs(distance) < self.kActiveDistance) {
                    var zoom = 1 + CGFloat(kZoomFactor) * (1 - abs(normalizedDistance));
                    attributes.transform3D = CATransform3DMakeScale(zoom, zoom, 1.0)
                    attributes.zIndex = 1;
                }
            }
        }
        
        return array;
    }
    
//    override func targetContentOffsetForProposedContentOffset(proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
//        var offsetAdjustment = CGFloat(MAXFLOAT)
//        var horizontalCenter:CGFloat = proposedContentOffset.x + (CGRectGetWidth(self.collectionView!.bounds) / 2.0)
//        
//        var targetRect:CGRect = CGRectMake(proposedContentOffset.x, 0.0, self.collectionView!.bounds.size.width, self.collectionView!.bounds.size.height)
//        var array:NSArray = super.layoutAttributesForElementsInRect(targetRect)!
//        
//        for layoutAttributes in array {
//            var itemHorizontalCenter:CGFloat = (layoutAttributes as UICollectionViewLayoutAttributes).center.x
//            if abs(itemHorizontalCenter - horizontalCenter) < abs(offsetAdjustment) {
//                offsetAdjustment = itemHorizontalCenter - horizontalCenter
//            }
//        }
//        
//        return CGPointMake(proposedContentOffset.x + offsetAdjustment, proposedContentOffset.y);
//    }
}