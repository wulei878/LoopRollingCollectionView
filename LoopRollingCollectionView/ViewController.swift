//
//  ViewController.swift
//  LoopRollingCollectionView
//
//  Created by 吴磊 on 15/3/24.
//  Copyright (c) 2015年 吴磊. All rights reserved.
//

import UIKit

class ViewController: UIViewController,UIScrollViewDelegate,UICollectionViewDelegate,UICollectionViewDataSource,BannerCollectionViewLayoutDelegate {
    var imageArray:NSArray
    var screenWidth:CGFloat
    var timer:NSTimer?
    var bannerCollectionViewDidMoving:Bool
    let kBannerImageViewHeight:CGFloat = 100
    var imageCollectionViewMinOffset:CGFloat
    var firstOffset:CGFloat
    var nextOffset:CGFloat
    var leftSpacing:CGFloat
    var imageCollectionViewMaxOffset:CGFloat
    var imageCollectionViewDidMoving:Bool
    var currentImageIndex:NSInteger
    
    @IBOutlet weak var bannerScrollView: UIScrollView!
    @IBOutlet weak var imageCollectionView: UICollectionView!
    @IBOutlet weak var bannerCollectionView: UICollectionView!
    @IBOutlet weak var scrollViewPageControl: UIPageControl!
    @IBOutlet weak var collectionViewPageControl: UIPageControl!

    required init(coder aDecoder: NSCoder) {
        self.imageArray = []
        self.screenWidth = 0
        self.firstOffset = 0
        self.nextOffset = 0
        self.leftSpacing = 0
        self.imageCollectionViewMaxOffset = 0
        self.imageCollectionViewMinOffset = 0
        self.currentImageIndex = 1
        self.imageCollectionViewDidMoving = false
        self.bannerCollectionViewDidMoving = false
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.imageArray = ["3.jpg","1.jpg","2.jpg","3.jpg","1.jpg",]
        self.screenWidth = UIScreen.mainScreen().bounds.width
        self.imageCollectionViewMinOffset = (kItemWidth * 2 + kLineBigSpacing - self.screenWidth) / 2
        self.leftSpacing = (self.screenWidth - kItemWidth) / 2
        self.firstOffset = kItemWidth + kLineBigSpacing - self.leftSpacing
        self.nextOffset = self.firstOffset + self.leftSpacing
        self.imageCollectionViewMaxOffset = self.firstOffset + (kItemWidth + kLineBigSpacing) * 2 + self.imageCollectionViewMinOffset
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.addBannerImageView()
        (self.bannerCollectionView.collectionViewLayout as BannerCollectionViewLayout).delegate = self
        self.bannerCollectionView.contentOffset = CGPointMake(screenWidth, 0)
        self.imageCollectionView.contentOffset = CGPointMake(self.firstOffset, 0)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func addNSTimer(){
        if (self.timer? != nil){
            return
        }
        
        self.timer = NSTimer.scheduledTimerWithTimeInterval(2, target: self, selector:"runTimePage", userInfo: nil, repeats: true)
        NSRunLoop.mainRunLoop().addTimer(self.timer!, forMode: NSRunLoopCommonModes)
        
    }
    
    func runTimePage(){
        if !self.bannerCollectionView.dragging && !self.bannerCollectionView.decelerating {
            self.bannerCollectionView.setContentOffset(CGPointMake(self.screenWidth*(CGFloat(self.collectionViewPageControl.currentPage+2)), 0), animated: true)
        }
        if !self.imageCollectionView.dragging && !self.imageCollectionView.decelerating {
            self.imageCollectionView.setContentOffset(CGPointMake(self.firstOffset+self.nextOffset*CGFloat(self.currentImageIndex), 0), animated: true)
        }

    }
    
    func addBannerImageView() {
        for (var i = 0;i < self.imageArray.count;i++) {
            var imageView:UIImageView = UIImageView(frame: CGRectMake(self.screenWidth*(CGFloat (i)), 0, self.screenWidth, kBannerImageViewHeight))
            imageView.contentMode = UIViewContentMode.ScaleAspectFill
            imageView.clipsToBounds = true
            imageView.image = UIImage(named: self.imageArray[i] as String)
            self.bannerScrollView .addSubview(imageView)
        }
        self.bannerScrollView.contentSize = CGSizeMake(self.screenWidth*(CGFloat(self.imageArray.count)), kBannerImageViewHeight)
        self.bannerScrollView.contentOffset = CGPointMake(self.screenWidth, 0)
        self.scrollViewPageControl.numberOfPages = self.imageArray.count-2
        self.scrollViewPageControl.currentPage = 0
        self.addNSTimer()
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        var cell:UICollectionViewCell?
        if collectionView == self.bannerCollectionView {
            var cell = collectionView.dequeueReusableCellWithReuseIdentifier(NSStringFromClass(BannerCollectionViewCell.self), forIndexPath: indexPath) as BannerCollectionViewCell
            cell.bannerImageView.image = UIImage(named: self.imageArray[indexPath.row] as String)
            return cell
        } else if collectionView == self.imageCollectionView {
            var cell = collectionView.dequeueReusableCellWithReuseIdentifier(NSStringFromClass(ImageCollectionViewCell.self), forIndexPath: indexPath) as ImageCollectionViewCell
            cell.presentImageView.image = UIImage(named: self.imageArray[indexPath.row] as String)
            return cell
        }
        return cell!
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.imageArray.count
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        if scrollView == self.bannerCollectionView{
            if scrollView.contentOffset.x >= self.screenWidth && scrollView.contentOffset.x < CGFloat(self.imageArray.count - 1) * self.screenWidth {
                self.bannerCollectionViewDidMoving = false
                var pagewidth:CGFloat = self.bannerCollectionView.bounds.width
                var currentPage = Int(floor((self.bannerCollectionView.contentOffset.x - pagewidth / (CGFloat(self.imageArray.count))) / pagewidth))
                self.collectionViewPageControl.currentPage = currentPage
                return
            }
            if (self.bannerCollectionViewDidMoving) {
                return
            }
            self.bannerCollectionViewDidMoving = true
            if (scrollView.contentOffset.x < self.screenWidth) {
                scrollView.contentOffset = CGPointMake(scrollView.contentOffset.x + self.screenWidth * CGFloat(self.imageArray.count - 2), scrollView.contentOffset.y)
                self.collectionViewPageControl.currentPage = self.imageArray.count - 3
            } else {
                scrollView.contentOffset = CGPointMake(scrollView.contentOffset.x - self.screenWidth * CGFloat(self.imageArray.count - 2), scrollView.contentOffset.y)
                self.collectionViewPageControl.currentPage = 0
            }
        } else if scrollView == self.imageCollectionView {
            if ((scrollView.contentOffset.x >= self.imageCollectionViewMinOffset) && (scrollView.contentOffset.x < self.imageCollectionViewMaxOffset + kItemWidth / 2)) {
                self.imageCollectionViewDidMoving = false
                self.configCurrentMasterIndex()
                return
            }
            if (self.imageCollectionViewDidMoving) {
                return
            }
            self.imageCollectionViewDidMoving = true
            if (scrollView.contentOffset.x < self.imageCollectionViewMinOffset) {
                scrollView.contentOffset = CGPointMake(scrollView.contentOffset.x + (kItemWidth + kLineBigSpacing) * (CGFloat(self.imageArray.count - 2)), scrollView.contentOffset.y)
                self.currentImageIndex = self.imageArray.count - 2
            } else {
                scrollView.contentOffset = CGPointMake(scrollView.contentOffset.x - (kItemWidth + kLineBigSpacing) * (CGFloat(self.imageArray.count - 2)), scrollView.contentOffset.y)
                self.currentImageIndex = 1
            }
        }
        
    }
    
    func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if scrollView == self.imageCollectionView && !decelerate {
            self.adjustCollectionViewContentOffset()
        }
    }
    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        if scrollView == self.bannerScrollView {
            var currentPage = Int(floor((self.bannerScrollView.contentOffset.x - self.screenWidth/(CGFloat(self.imageArray.count)))/self.screenWidth) + 1)
            if currentPage == 0 {
                self.bannerScrollView.contentOffset = CGPointMake(self.screenWidth*(CGFloat(self.imageArray.count-2)), 0)
                self.scrollViewPageControl.currentPage = self.imageArray.count - 2
            } else if currentPage == self.imageArray.count - 1 {
                self.bannerScrollView.contentOffset = CGPointMake(self.screenWidth, 0)
                self.scrollViewPageControl.currentPage = 0
            } else {
                self.scrollViewPageControl.currentPage = currentPage - 1
            }
        } else if scrollView == self.imageCollectionView {
            self.adjustCollectionViewContentOffset()
        }
    }
    
    func adjustCollectionViewContentOffset() {
        self.imageCollectionView.setContentOffset(CGPointMake(self.imageCollectionView.contentOffset.x + self.configCurrentMasterIndex(), 0) ,animated:true)
    }
    
    func configCurrentMasterIndex()->CGFloat {
        var offsetAdjustment = CGFloat(MAXFLOAT)
        var horizontalCenter:CGFloat = self.imageCollectionView.contentOffset.x + (CGRectGetWidth(self.imageCollectionView.bounds) / 2.0)
        var targetRect = CGRectMake(self.imageCollectionView.contentOffset.x, 0.0, self.imageCollectionView.bounds.size.width, self.imageCollectionView.bounds.size.height)
        var array:NSArray = (self.imageCollectionView.collectionViewLayout as ImageCollectionViewLayout).layoutAttributesForElementsInRect(targetRect)!
        for object in array {
            let attributes = object as UICollectionViewLayoutAttributes
            var itemHorizontalCenter:CGFloat = attributes.center.x
            if abs(itemHorizontalCenter - horizontalCenter) < abs(offsetAdjustment) {
                offsetAdjustment = itemHorizontalCenter - horizontalCenter
                self.currentImageIndex = attributes.indexPath.row
            }
        }
        return offsetAdjustment
    }
    
    func bannerCollectionViewLayout(currentIndex: Int) {
//        self.collectionViewPageControl.currentPage = currentIndex-1
    }
}

