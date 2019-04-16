//
//  HomeVC.swift
//  ArabDesigners
//
//  Created by Shiv Charan Panjeta < shiv@ozvid.com > on 02/02/2019.
//  Copyright © 2019 OZVID Technologies Pvt. Ltd. < www.ozvid.com >. All rights reserved.
//

import UIKit
import SWRevealViewController

class HomeVC: UIViewController, SWRevealViewControllerDelegate {
    
    //MARK:- Outlets
    @IBOutlet var clctnvwProducts: UICollectionView!
    @IBOutlet var tblvwCategory: UITableView!
    @IBOutlet var pageControle: UIPageControl!
    @IBOutlet var vwSearch: UIView!
    
    //MARK: - Variable
    var objHomeVM   = HomeVM()
    var slideTimer  = Timer()
    var imageCounter    = 1
    
    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        userModelObj.typeCategory   = 1
        objHomeVM.currentPage       = 0
        
        objHomeVM.getBannerCategoriesList {
            
            self.pageControle.numberOfPages = self.objHomeVM.arrayBannerCategoryModel.count
            self.clctnvwProducts.reloadData()
            self.slideTimer.invalidate()
            
            if self.objHomeVM.arrayBannerCategoryModel.count > 0 {
                self.slideTimer = Timer.scheduledTimer(timeInterval: 4, target: self, selector: #selector(self.autoScroll), userInfo: nil, repeats: true)
            }
        }
        
        objHomeVM.getMainCategoriesList {
            self.tblvwCategory.reloadData()
        }
        
        self.tabBarController?.tabBar.isHidden = false
        vwSearch.isHidden = true
        
        //Notification Handling when app is terminated
        if KAppDelegate.isAppLaunchFromNotification {
            
            KAppDelegate.isAppLaunchFromNotification    = false
            KAppDelegate.manageNotificationsClicks(withContoller: self, and: KAppDelegate.notificationDataDictionary)
        }
        
        if KAppDelegate.isStartedFromLink {
            KAppDelegate.isStartedFromLink  = false
            
            let productArr = KAppDelegate.productLink.components(separatedBy: "id=")
            
            if productArr.count > 1 {
                let productId = Int(productArr[1]) ?? 0
                
                if productId != 0 {
                    let gotoProductDetailVC = storyBoard.instantiateViewController(withIdentifier: "ProductDetailVC") as! ProductDetailVC
                    gotoProductDetailVC.ProductId = Int(productId)
                    self.navigationController?.pushViewController(gotoProductDetailVC, animated: true)
                }
            }
        }
    }
    
    //MARK:- Button Action
    @IBAction func actionNotification(_ sender: UIButton) {
        
        //Proxy.shared.displayStatusCodeAlert(AlertValue.noImplement)
        if Proxy.shared.accessTokenNil() == "" {
            Proxy.shared.displayStatusCodeAlert(AlertValue.firstlogin)
        }
        else {
            Proxy.shared.pushToNextVC(identifier: "NotificationVC", isAnimate: true, currentViewController: self, title: "")
        }
    }
    
    @IBAction func actionSearch(_ sender: UIButton) {
        Proxy.shared.pushToNextVC(identifier: "SearchVC", isAnimate: true, currentViewController: self, title: "")
        
    }
    @IBAction func actionDrawer(_ sender: Any) {
        
        revealViewController().delegate = self
        if (revealViewController()) != nil {
            view.addGestureRecognizer(revealViewController().panGestureRecognizer())
            view.addGestureRecognizer(revealViewController().tapGestureRecognizer())
        }
        if userModelObj.appLanguage    == "ar" {
            self.revealViewController()?.rightRevealToggle(animated:true)
        } else {
            self.revealViewController().revealToggle(animated: true)
        }
        
    }
    
    //MARK: Timer Method
    @objc func autoScroll() {
        
        if imageCounter < objHomeVM.arrayBannerCategoryModel.count {
            
            let indexPath = IndexPath(row: imageCounter, section: 0)
            
            clctnvwProducts.scrollToItem(at: indexPath, at: UICollectionView.ScrollPosition(), animated: true)
            pageControle.currentPage = imageCounter
            imageCounter += 1
        }
        else {
            if objHomeVM.arrayBannerCategoryModel.count == 1 {
                
            }
            else {
                imageCounter    = 0
                let indexPath   = IndexPath(row: imageCounter, section: 0)
                clctnvwProducts.scrollToItem(at: indexPath, at: UICollectionView.ScrollPosition(), animated: true)
                pageControle.currentPage = imageCounter
            }
        }
    }
    
    //MARK: - DrawerDelegates
    
    func revealController(_ revealController: SWRevealViewController!, willMoveTo position: FrontViewPosition) {
        
        if position == .left {
            
            tblvwCategory.isUserInteractionEnabled  = true
            revealViewController().frontViewController.view.alpha   = 1
            self.tabBarController?.tabBar.isUserInteractionEnabled  = true
        }
        if position == .right {
            
            tblvwCategory.isUserInteractionEnabled  = false
            revealViewController().frontViewController.view.alpha   = 0.9
            self.tabBarController?.tabBar.isUserInteractionEnabled  = false
        }
    }
}
