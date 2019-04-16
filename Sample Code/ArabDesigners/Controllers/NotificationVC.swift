//
//  NotificationVC.swift
//  ArabDesigners
//
//  Created by Shiv Charan Panjeta < shiv@ozvid.com > on 04/02/2019.
//  Copyright © 2019 OZVID Technologies Pvt. Ltd. < www.ozvid.com >. All rights reserved.
//

import UIKit

class NotificationVC: UIViewController {
    
    //MARK:- Outlet
    @IBOutlet var tblvwNotification: UITableView!
    
    var  objNotificationVM  = NotificationVM()
    
    //MARK:-
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        objNotificationVM.currentPage = 0
        objNotificationVM.getNotificationList {
            self.tblvwNotification.reloadData()
        }
        self.tabBarController?.tabBar.isHidden = true
    }
    
    //MARK:- Button Action
    @IBAction func actionBack(_ sender: UIButton) {
        Proxy.shared.popToBackVC(isAnimate: true, currentViewController: self)
    }
}
