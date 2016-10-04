//
//  ViewController.swift
//  Eat
//
//  Created by Fan on 16/9/4.
//  Copyright © 2016年 Fan. All rights reserved.
//

import UIKit

class ViewController: UIViewController, MenuTransitionManagerDelegate {
    
    var isButtonNotTouched = true
    var isdetailAddButtonTouched = false
    var isButtonDetailTouched = false
    var textAdded = ""
    var timer, imageViewTimer, interfaceTimer :Timer!
    let menuTransitionManager = MenuTransitionManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Home"
                
        buttonGo.layer.cornerRadius = 25
        buttonDetail.layer.cornerRadius = 25
        
        buttonGo.layer.shadowColor = buttonGo.layer.backgroundColor
        buttonGo.layer.shadowOpacity = 0.4
        buttonGo.layer.shadowOffset = CGSize(width: 1, height: 3)
        buttonDetail.layer.shadowColor = buttonDetail.layer.backgroundColor
        buttonDetail.layer.shadowOpacity = 0.4
        buttonDetail.layer.shadowOffset = CGSize(width: 1, height: 3)
        
        bottomBlankView.layer.shadowColor = UIColor.white.cgColor
        bottomBlankView.layer.shadowOpacity = 0.4
        bottomBlankView.layer.shadowOffset = CGSize(width: 1, height: -3)
        
        imageViewTimer = Timer.scheduledTimer (timeInterval: 0,
            target:self,selector:#selector(ViewController.imageViewAnimation),
            userInfo:nil,repeats:false)
        
        interfaceTimer = Timer.scheduledTimer (timeInterval: 0,
            target:self,selector:#selector(ViewController.interfaceAnimation),
            userInfo:nil,repeats:false)

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        //NSTimer 循环执行printStore
        timer = Timer.scheduledTimer (timeInterval: 0.5,
            target:self,selector:#selector(ViewController.printStore),
            userInfo:nil,repeats:true)
    }
    
    @IBAction func unwindToViewController (_ sender: UIStoryboardSegue){
    }
    
    @IBAction func unwindToHome(_ segue: UIStoryboardSegue) {
    }
    
    func dismiss() {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showMenu" {
        let menuTableViewController = segue.destination as! MenuTableViewController
        menuTableViewController.currentItem = self.title!
        menuTableViewController.transitioningDelegate = menuTransitionManager
        menuTransitionManager.delegate = self
        }
    }

    @IBOutlet weak var mainScrollView: UIScrollView!

    @IBOutlet weak var bottomBlankView: UIImageView!
    
    @IBOutlet weak var buttonAdd: UIButton!
    
    @IBOutlet weak var buttonGo: UIButton!
    
    @IBOutlet weak var display: UILabel!
    
    @IBOutlet weak var buttonDetail: UIButton!
    
    @IBAction func buttonDetailPressed(_ sender: UIButton) {
        isButtonDetailTouched = true
    }
    
    @IBAction func buttonPressed(_ sender: UIButton) {
        isButtonNotTouched = false
        let avc = AddDetailViewController()
        
        if isdetailAddButtonTouched {
            print("isdetailAddButtonTouched")
            if textAdded != "" {
                print("textAdded")
                let addCount = count! + 1
                storeList.updateValue(textAdded, forKey: addCount)
                textAdded = ""
            }
            avc.detailAddButtonTouched = false
        }
        timer.invalidate()
        printStore()
    }
    
    @objc fileprivate func interfaceAnimation(){
        self.buttonGo.alpha = 0
        UIView.animate(withDuration: 0.75, delay: 0.25, options: UIViewAnimationOptions(), animations: {
            self.buttonGo.alpha = 1.0
            }, completion: nil)
        
        self.buttonDetail.alpha = 0
        UIView.animate(withDuration: 0.75, delay: 0.35, options: UIViewAnimationOptions(), animations: {
            self.buttonDetail.alpha = 1.0
            }, completion: nil)
        
        self.display.alpha = 0
        UIView.animate(withDuration: 3.0, delay: 0, options: UIViewAnimationOptions(), animations: {
            self.display.alpha = 1.0
            }, completion: nil)
    }
    
    @objc fileprivate func imageViewAnimation(){
        self.bottomBlankView.center.y += 200
        UIView.animate(withDuration: 0.65, delay: 0, options: .curveEaseIn, animations: {
            self.bottomBlankView.center.y -= 225
            }, completion: nil)
        UIView.animate(withDuration: 1.5, delay: 0.65,usingSpringWithDamping: 0.3, initialSpringVelocity: 3, options: .curveEaseOut, animations: {
            self.bottomBlankView.center.y += 25
            }, completion: nil)
    }
    
    
    var storeList:Dictionary <Int,String> = [
        1: "华师卤饭",
        2: "黄焖鸡米饭",
        3: "华师盖浇饭",
        4: "西苑食堂",
        5: "三顾冒菜",
        6: "华师卤菜",
        7: "重庆小面",
        8: "东苑食堂",
        9: "沙县小吃",
        10:"💩💩💩",
    ]
    
    var count: Int? {
        return storeList.count
    }
    
    func getStore(_ num: Int) -> String{
        return storeList[num]!
    }
    
    func randomIn(_ min: Int, max: Int) -> Int {
        return Int(arc4random()) % (max - min + 1) + min
    }
    
    func printStore(){
        let temp = randomIn(1,max: count!)
        display.text = getStore(temp)
    }
    
    
    
    
}

