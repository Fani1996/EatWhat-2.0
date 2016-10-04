//
//  TableViewController.swift
//  Eat
//
//  Created by Fan on 16/9/17.
//  Copyright © 2016年 Fan. All rights reserved.
//

import UIKit
import MapKit

private let RefreshViewHeight: CGFloat = 200

class ArticleController: UITableViewController, RefreshViewDelegate{
    
    fileprivate var refreshView: RefreshView!
    
    let screenWidth: CGFloat = UIScreen.main.bounds.width
    let screenHeight: CGFloat = UIScreen.main.bounds.height
    
    var currentArticle: Article?
    var articleMenu: ArticleMenuView?
    var articleMenuHidden = false
    var lastContentOffset: CGFloat = 0.0
    
    
    
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        refreshView.scrollViewDidScroll(scrollView)
        
        if let menu = articleMenu {
            if lastContentOffset < 0.0 {
            } else if lastContentOffset > scrollView.contentOffset.y {
                unhideArticleMenu(menu)
            } else if lastContentOffset < scrollView.contentOffset.y {
                hideArticleMenu(menu)
            }
            lastContentOffset = scrollView.contentOffset.y
        }
        
    }
    
    override func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        refreshView.scrollViewWillEndDragging(scrollView, withVelocity: velocity, targetContentOffset: targetContentOffset)
    }
    
    
    func refreshViewDidRefresh(_ refreshView: RefreshView) {
        sleep(3)
        refreshView.endRefreshing()
    }
    
    
    
    
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 500.0
        initializeArticle()
        addFooterView()
        
        refreshView = RefreshView(frame: CGRect(x: 0, y: -RefreshViewHeight, width: view.bounds.width, height: RefreshViewHeight), scrollView: tableView)
        refreshView.delegate = self
        view.insertSubview(refreshView, at: 0)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        addArticleMenu()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        removeArticleMenu()
    }
    /*
    override func scrollViewDidScroll(scrollView: UIScrollView) {
        if let menu = articleMenu {
            if lastContentOffset < 0.0 {
            } else if lastContentOffset > scrollView.contentOffset.y {
                unhideArticleMenu(menu)
            } else if lastContentOffset < scrollView.contentOffset.y {
                hideArticleMenu(menu)
            }
            lastContentOffset = scrollView.contentOffset.y
        }
    }
    */
    
    
    func initializeArticle() {
        
        let mainContent = "Start your day with this amazing breakfast, and you will be happy throughout the day"
        let article = Article(title: "Lovely Breakfast", mainContent: mainContent, coverPhoto: "Toast", coverPhotoWidth: 1080, coverPhotoHeight: 810, mealType: "Breakfast", mealPrice: 34)
        
        article.restaurantName = "Toast Box"
        article.restaurantAddress = "G/F, JD Mall, 233-239 Nathan Rd, Jordan"
        article.restaurantLatitude = 22.304864882982680
        article.restaurantLongitude = 114.171386361122100
        article.authorDisplayName = "The Dreamer"
        article.authorUsername = "dreamer"
        
        let subContentOne = SubContent(photo: "Egg", photoWidth: 1080, photoHeight: 810, text: "Half-boiled eggs is a must")
        let subContentTwo = SubContent(photo: "Tea", photoWidth: 1080, photoHeight: 810, text: "Singapore/Malaysia-styled milk tea. Milder than Hong Kong style but still great")
        
        article.subContents = [subContentOne, subContentTwo]
        
        currentArticle = article
    }
    
    func attributedContentFromText(_ text: String) -> NSMutableAttributedString {
        let paraStyle = NSMutableParagraphStyle()
        paraStyle.lineSpacing = 7
        let attrs = [NSFontAttributeName: UIFont.systemFont(ofSize: 15),
                     NSParagraphStyleAttributeName: paraStyle]
        let attrContent = NSMutableAttributedString(string: text, attributes: attrs)
        return attrContent
    }
    
    func addFooterView() {
        let footerView = Bundle.main.loadNibNamed("ArticleFooterView", owner: self, options: nil)?[0] as! ArticleFooterView
        footerView.frame = CGRect(x: 0, y: 0, width: screenWidth, height: 486)
        
        footerView.separatorHeight.constant = 0.6
        
        if let type = currentArticle?.mealType, let price = currentArticle?.mealPrice {
            footerView.mealTypeLabel.text = type
            footerView.mealPriceLabel.text = "HK$ \(price)"
        }
        
        if let name = currentArticle?.restaurantName, let address = currentArticle?.restaurantAddress {
            footerView.restaurantNameLabel.text = name
            footerView.restaurantAddressLabel.text = address
        }
        
        if let lat = currentArticle?.restaurantLatitude, let lng = currentArticle?.restaurantLongitude {
            let location = CLLocation(latitude: lat, longitude: lng)
            let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate, 250.0, 250.0)
            footerView.mapView.setRegion(coordinateRegion, animated: false)
            
            let pin = MKPointAnnotation()
            pin.coordinate = location.coordinate
            footerView.mapView.addAnnotation(pin)
        }
        
        tableView.tableFooterView = footerView
    }
    
    
    func addArticleMenu() {
        if articleMenu == nil {
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let menuView = Bundle.main.loadNibNamed("ArticleMenuView", owner: self, options: nil)?[0] as! ArticleMenuView
            menuView.frame = CGRect(x: 0, y: screenHeight - 70, width: screenWidth, height: 70)
            menuView.blurView.layer.cornerRadius = 3
            menuView.blurView.layer.masksToBounds = true
            
            appDelegate.window?.addSubview(menuView)
            menuView.slideInFromBottom()
            
            articleMenu = menuView
        }
    }
    
    func hideArticleMenu(_ menu: UIView) {
        if !articleMenuHidden {
            UIView.animate(withDuration: 0.3, delay: 0.0, options: UIViewAnimationOptions(), animations: {
                menu.frame = CGRect(x: 0, y: self.screenHeight, width: self.screenWidth, height: 70)
                }, completion: { finished in
                    self.articleMenuHidden = true
            })
        }
    }
    
    func unhideArticleMenu(_ menu: UIView) {
        if articleMenuHidden {
            UIView.animate(withDuration: 0.3, delay: 0.0, options: UIViewAnimationOptions(), animations: {
                menu.frame = CGRect(x: 0, y: self.screenHeight - 70, width: self.screenWidth, height: 70)
                }, completion: { finished in
                    self.articleMenuHidden = false
            })
        }
    }
    
    func removeArticleMenu() {
        if let menu = articleMenu {
            menu.removeFromSuperview()
            self.articleMenu = nil
        }
    }
    
    
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cellForRow: UITableViewCell!
        
        if (indexPath as NSIndexPath).row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CoverPhotoCell", for: indexPath) as! CoverPhotoTableViewCell
            
            if let imageName = currentArticle?.coverPhoto {
                cell.coverImageView.image = UIImage(named: imageName)
            }
            
            cellForRow = cell
            
        } else if (indexPath as NSIndexPath).row == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "MainContentCell", for: indexPath) as! MainContentTableViewCell
            cell.titleLabel.text = currentArticle?.title
            
            cell.contentLabel.textAlignment = .left
            if let text = currentArticle?.mainContent {
                cell.contentLabel.attributedText = attributedContentFromText(text)
            }
            
            cellForRow = cell
            
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "SubContentCell", for: indexPath) as! SubContentTableViewCell
            
            if let article = currentArticle {
                let subContent = article.subContents[(indexPath as NSIndexPath).row - 2]
                
                if let width = subContent.photoWidth, let height = subContent.photoHeight {
                    let heightRatio = height / width
                    cell.subImageViewHeight.constant = screenWidth * heightRatio
                }
                
                if let imageName = subContent.photo {
                    cell.subImageView.image = UIImage(named: imageName)
                }
                
                cell.subContentLabel.textAlignment = .left
                if let text = subContent.text {
                    cell.subContentLabel.attributedText = attributedContentFromText(text)
                }
                
            }
            
            cellForRow = cell
        }
        
        return cellForRow
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let article = currentArticle {
            return 2 + article.subContents.count
        } else {
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if (indexPath as NSIndexPath).row == 0 {
            if let width = currentArticle?.coverPhotoWidth, let height = currentArticle?.coverPhotoHeight {
                let heightRatio = height / width
                return screenWidth * heightRatio
            }
        }
        return UITableViewAutomaticDimension
    }
}
