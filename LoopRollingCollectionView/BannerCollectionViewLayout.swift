//
//  BannerCollectionViewLayout.swift
//  LoopRollingCollectionView
//
//  Created by 吴磊 on 15/3/24.
//  Copyright (c) 2015年 吴磊. All rights reserved.
//

import UIKit

protocol BannerCollectionViewLayoutDelegate {
    func bannerCollectionViewLayout(currentIndex:Int)
}
    
class BannerCollectionViewLayout: UICollectionViewFlowLayout {
    var delegate:BannerCollectionViewLayoutDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        var screenWidth = UIScreen.mainScreen().bounds.width
        self.itemSize = CGSizeMake(screenWidth, 100)
        self.scrollDirection = UICollectionViewScrollDirection.Horizontal
        self.minimumInteritemSpacing = 0
        self.minimumLineSpacing = 0
    }
}
