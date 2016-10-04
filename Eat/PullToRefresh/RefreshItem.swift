//
//  RefreshItem.swift
//
//  Eat
//
//  Created by Fan on 16/9/17.
//  Copyright © 2016年 Fan. All rights reserved.
//

import UIKit

class RefreshItem {
    fileprivate var centerStart: CGPoint
    fileprivate var centerEnd: CGPoint
    unowned var view: UIView
    
    init(view: UIView, centerEnd: CGPoint, parallaxRatio: CGFloat, sceneHeight: CGFloat) {
        self.view = view
        self.centerEnd = centerEnd
        centerStart = CGPoint(x: centerEnd.x, y: centerEnd.y + (parallaxRatio * sceneHeight))
        self.view.center = centerStart
    }
    
    func updateViewPositionForPercentage(_ percentage: CGFloat) {
        view.center = CGPoint(
            x: centerStart.x + (centerEnd.x - centerStart.x) * percentage,
            y: centerStart.y + (centerEnd.y - centerStart.y) * percentage
        )
    }
    
    
}
