//
//  RefreshView.swift
//  Eat
//
//  Created by Fan on 16/9/17.
//  Copyright © 2016年 Fan. All rights reserved.
//

import UIKit

protocol RefreshViewDelegate: class {
    func refreshViewDidRefresh(_ refreshView: RefreshView)
}

private let SceneHeight: CGFloat = 120.0

class RefreshView: UIView, UIScrollViewDelegate {
    
    fileprivate unowned var scrollView: UIScrollView
    fileprivate var progress: CGFloat = 0.0
    
    var refreshItems = [RefreshItem]()
    weak var delegate: RefreshViewDelegate?
    
    var isRefreshing = false
    
    init(frame: CGRect, scrollView: UIScrollView) {
        self.scrollView = scrollView
        super.init(frame: frame)
        updateBackgroundColor()
        setupRefreshItems()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func setupRefreshItems() {
        
        let backgroundImageView = UIImageView(image: UIImage(named: "3"))
        let frontImageView = UIImageView(image: UIImage(named: "2"))
        let loadingImageView = UIImageView(image: UIImage(named: "loading"))
        
        refreshItems = [
            RefreshItem(view: backgroundImageView,
                centerEnd: CGPoint(x: bounds.midX,
                    y: bounds.height  - backgroundImageView.bounds.height / 2),
                parallaxRatio: 1.5, sceneHeight: SceneHeight),
            RefreshItem(view: frontImageView,
                centerEnd: CGPoint(x: bounds.midX,
                    y: bounds.height  - frontImageView.bounds.height/1.4),
                parallaxRatio: 3, sceneHeight: SceneHeight),
            RefreshItem(view: loadingImageView, centerEnd: CGPoint(x: bounds.midX * 1.6, y: bounds.height - loadingImageView.bounds.height/1.85), parallaxRatio: -1, sceneHeight: SceneHeight),
        ]
        
        for refreshItem in refreshItems {
            addSubview(refreshItem.view)
        }
        
    }
    
    fileprivate func updateBackgroundColor() {
        backgroundColor = UIColor(white: 1 - 0.3 * progress, alpha: 1.0)
    }
    
    fileprivate func updateRefreshItemPositions() {
        for refreshItem in refreshItems {
            refreshItem.updateViewPositionForPercentage(progress)
        }
    }
    
    func beginRefreshing() {
        isRefreshing = true
        
        UIView.animate(withDuration: 0.4, delay: 0, options: UIViewAnimationOptions(), animations: { () -> Void in
            self.scrollView.contentInset.top += SceneHeight
        }) { (_) -> Void in
        }
    
    }
    
    fileprivate func loadingAnimation(){
        let loading = refreshItems[2].view
        loading.transform = CGAffineTransform(translationX: 0, y: 2.0)
        UIView.animate(withDuration: 0.6, delay: 0, options: [.repeat, .autoreverse] ,
            animations: { () -> Void in
            loading.transform = CGAffineTransform(translationX: 0, y: -2.0)
            }, completion: nil)
    }
    
    func endRefreshing() {
        UIView.animate(withDuration: 0.4, delay: 0, options: UIViewAnimationOptions(), animations: { () -> Void in
            self.scrollView.contentInset.top -= SceneHeight
            }) { (_) -> Void in
            self.isRefreshing = false
        }
        
        let loading = refreshItems[2].view
        loading.transform = CGAffineTransform.identity
        loading.layer.removeAllAnimations()
        
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        if  !isRefreshing && progress == 1 {
            beginRefreshing()
            targetContentOffset.pointee.y = -scrollView.contentInset.top
            delegate?.refreshViewDidRefresh(self)
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if isRefreshing {
            return
        }
        
        loadingAnimation()
        
        let refreshViewVisibleHeight = max(0, -scrollView.contentOffset.y - scrollView.contentInset.top)
        progress = min(1, refreshViewVisibleHeight / SceneHeight)
        updateBackgroundColor()
        updateRefreshItemPositions()
    }
    

}
