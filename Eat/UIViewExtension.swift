//
//  UIViewExtension.swift
//  Delicious
//
//  Created by Fan on 16/9/17.
//  Copyright © 2016年 Demo. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    
    func slideInFromBottom(_ duration: TimeInterval = 0.1, completionDelegate: AnyObject? = nil) {
        let slideInFromBottomTransition = CATransition()
        
        if let delegate: CAAnimationDelegate = completionDelegate as! CAAnimationDelegate? {
            slideInFromBottomTransition.delegate = delegate
        }
        
        slideInFromBottomTransition.type = kCATransitionPush
        slideInFromBottomTransition.subtype = kCATransitionFromTop
        slideInFromBottomTransition.duration = duration
        slideInFromBottomTransition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        slideInFromBottomTransition.fillMode = kCAFillModeRemoved
        
        self.layer.add(slideInFromBottomTransition, forKey: "slideInFromBottomTransition")
    }
    
}
