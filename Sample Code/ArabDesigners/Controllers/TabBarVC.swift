//
//  TabBarVC.swift
//  ArabDesigners
//
//  Created by Shiv Charan Panjeta < shiv@ozvid.com > on 02/02/2019.
//  Copyright © 2019 OZVID Technologies Pvt. Ltd. < www.ozvid.com >. All rights reserved.
//


import UIKit

class TabBarVC: UITabBarController, UITabBarControllerDelegate {
    
    //MARK:- Variables
    var deviceToken = String(), access_Token = String()
    
    //MARK:-
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.delegate   = self
        UITabBar.appearance().tintColor     = UIColor.init(red: 255/255.0, green: 101/255.0, blue: 0/255.0, alpha: 1.0)
        if #available(iOS 10.0, *) {
            self.tabBar.unselectedItemTintColor = UIColor.black
        } else {
            // Fallback on earlier versions
        }
    }
    
    //MARK :-
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {      
        if let identifier = viewController.restorationIdentifier, identifier == "ProfileVC" {
            if let accessToken = UserDefaults.standard.object(forKey: "access-token") as? String {
                if accessToken != "" {
                    access_Token = accessToken
                    self.tabBarController?.selectedIndex = 4
                }else {
                    Proxy.shared.rootToVC(identifier: "SigninVC")
                    Proxy.shared.displayStatusCodeAlert(AlertValue.firstlogin)
               }
            } else {
                Proxy.shared.rootToVC(identifier: "SigninVC")
            }
            return true
        }
        return true
    }

}
