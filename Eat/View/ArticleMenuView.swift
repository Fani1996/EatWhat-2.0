//
//  ArticleMenuView.swift
//  Delicious
//
//  Created by Sean Choo on 5/4/16.
//  Copyright © 2016 Demo. All rights reserved.
//

import UIKit

class ArticleMenuView: UIView {

    @IBOutlet weak var blurView: UIVisualEffectView!
    
    @IBOutlet weak var starButton: UIButton!
    @IBOutlet weak var pinButton: UIButton!
    @IBOutlet weak var moreButton: UIButton!
    
    @IBAction func starButtonPressed(_ sender: UIButton) {
        starButton.setImage(UIImage(named:"starSelected"),for:UIControlState())
    }
    
    
    @IBAction func pinButtonPressed(_ sender: UIButton) {
        pinButton.setImage(UIImage(named:"pinSelected"),for:UIControlState())
    }
    
    @IBAction func moreButtonPressed(_ sender: UIButton) {
        moreButton.setImage(UIImage(named:"moreSelected"),for:UIControlState())
    }
}
