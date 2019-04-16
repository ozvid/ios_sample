//
//  DesignerVC.swift
//  ArabDesigners
//
//  Created by Shiv Charan Panjeta < shiv@ozvid.com > on 02/02/2019.
//  Copyright © 2019 OZVID Technologies Pvt. Ltd. < www.ozvid.com >. All rights reserved.
//

import UIKit
import SWRevealViewController

class DesignerVC: UIViewController, SWRevealViewControllerDelegate {
    
    //MARK: - IBOutlets
    
    @IBOutlet var tblDesigners: UITableView!
    @IBOutlet weak var countLB: UILabel!
    
    //MARK: - Variables
    let objDesignerVM   = DesignerVM()
    
    //MARK: - ViewMethods
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        countLB.isHidden    = userModelObj.cartItemCount == 0 ? true : false
        countLB.text        = "\(userModelObj.cartItemCount)"
        
        userModelObj.typeCategory   = 1
        objDesignerVM.arrayAllDesignersModel.removeAll()
        objDesignerVM.getAllDesignerList {
            self.tblDesigners.reloadData()
        }
        self.tabBarController?.tabBar.isHidden  = false
    }
    
    //MARK: - UIButtonActions
    
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
    
    @IBAction func actionCart(_ sender: Any) {
        if Proxy.shared.accessTokenNil() == "" {
            Proxy.shared.rootToVC(identifier: "SigninVC")
            Proxy.shared.displayStatusCodeAlert(AlertValue.firstlogin)
        }else{
            Proxy.shared.pushToNextVC(identifier: "CartVC", isAnimate: true, currentViewController: self, title: "")
        }
    }
    
    //MARK: - DrawerDelegates
    
    func revealController(_ revealController: SWRevealViewController!, willMoveTo position: FrontViewPosition) {
        
        if position == .left {
            
            tblDesigners.isUserInteractionEnabled  = true
            revealViewController().frontViewController.view.alpha   = 1
            self.tabBarController?.tabBar.isUserInteractionEnabled  = true
        }
        if position == .right {
            
            tblDesigners.isUserInteractionEnabled  = false
            revealViewController().frontViewController.view.alpha   = 0.9
            self.tabBarController?.tabBar.isUserInteractionEnabled  = false
        }
    }
    
    //MARK: - EOF
}

