//
//  DrawerVM.swift
//  ArabDesigners
//
//  Created by ShivCharan Panjeta - https://ozvid.com on 02/02/2019.
//  Copyright © 2019 OZVID Technologies Pvt. Ltd. < www.ozvid.com >. All rights reserved.
//

import UIKit

class DrawerVM: NSObject {

}

extension DrawerVC {
    
    //MARK: -
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 0 {
            return 1
        }
        else if section == 2 {
            return 2
        }
        return arrMenuItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell    = tableView.dequeueReusableCell(withIdentifier: "DrawerCell") as! DrawerCell
        cell.selectionStyle    = .none
        
        if indexPath.section    == 0 {
            cell.itemNameLB.text    = "HOME".localized
            cell.itemNameLB.textColor           = UIColor.black
        }
        else if indexPath.section   == 1 {
            cell.itemNameLB.textColor   = UIColor.black
            cell.itemNameLB.text        = arrMenuItems[indexPath.row].titleStr.capitalized
        }
        else {
            if indexPath.row    == 0 {
                cell.itemNameLB.text        = "CHANGE LANGUAGE".localized
                cell.itemNameLB.textColor   = UIColor.black
            }
            else {
                if Proxy.shared.accessTokenNil() == "" {
                    cell.itemNameLB.text    = "LOGIN".localized
                }
                else {
                    cell.itemNameLB.text    = "LOGOUT".localized
                }
                cell.itemNameLB.textColor           = UIColor.init(red: 255/255.0, green: 101/255.0, blue: 0/255.0, alpha: 1.0)
            }
        }
        cell.contentView.backgroundColor    = UIColor.white
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if indexPath.section    == 0 {
            return 50
        }
        else {
            tableView.estimatedRowHeight    = 50
            return UITableView.automaticDimension
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.section    == 0 {
            (self.revealViewController().frontViewController! as! UITabBarController).selectedIndex = 0
            self.revealViewController().setFrontViewPosition(.left, animated: true)
        }
        else if indexPath.section   == 1 {
            goToView("PrivacyContentVC", with: arrMenuItems[indexPath.row].titleStr.capitalized, withSelected: indexPath.row)
        }
        else {
            
            if indexPath.row    == 0 {
                moveToView()
            }
            else {
                if Proxy.shared.accessTokenNil() == "" {
                    Proxy.shared.rootToVC(identifier: "SigninVC")
                }
                else {
                    actionLogout()
                }
            }
        }
        
        tblDrawer.reloadData()
    }
    
    //MARK: - Custom Methods
    func actionLogout() -> Void {
        
        let alert               = UIAlertController(title: nil, message: "Do you really want to logout?".localized, preferredStyle: UIAlertController.Style.actionSheet)
        let LogoutAction        = UIAlertAction(title: "Logout", style: UIAlertAction.Style.destructive, handler:{ (action: UIAlertAction!) in
            
            UserDefaults.standard.set(nil, forKey: "access-token")
            UserDefaults.standard.synchronize()
            
            let view    = self.storyboard?.instantiateViewController(withIdentifier: "SignupVC")
            self.view.window?.rootViewController    = view
            
        })
        alert.addAction(LogoutAction)
        let cancelAction        = UIAlertAction(title:"Cancel", style:UIAlertAction.Style.default, handler:{ (action: UIAlertAction!) in
            
        })
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)
    }
    
}
