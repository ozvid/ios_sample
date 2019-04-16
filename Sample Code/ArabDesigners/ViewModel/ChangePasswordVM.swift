//
//  ChangePasswordVM.swift
//  ArabDesigners
//
//  Created by Shiv Charan Panjeta < shiv@ozvid.com > on 2/25/19.
//  Copyright © 2019 OZVID Technologies Pvt. Ltd. < www.ozvid.com >. All rights reserved.
//

import Foundation
import UIKit
class ChangePasswordVM {
    
    
    
    //MARK:- Variables
    var Password = String() ,confirmPassword = String()
  
    //MARK:- changePassword Api
    func changePasswordApi(_ completion:@escaping() -> Void) {
        let param = [
            "User[newPassword]"         : Password,
            "User[confirm_password]"    : confirmPassword
            ]  as [String:AnyObject]
        WebServiceProxy.shared.postData("\(Apis.KServerUrl)\(Apis.KChangePassword)", params: param, showIndicator: true, completion: { (JSON) in
            if JSON["status"] as! Int == 200 {
                if let msg = JSON["msg"] as? String{
                   Proxy.shared.displayStatusCodeAlert(msg)
                }
                completion()
            } else {
                Proxy.shared.displayStatusCodeAlert(JSON["error"] as? String ?? "Error".localized)
            }
        })
    }
}
extension ChangePasswordVC: UITextFieldDelegate{
    
    func validateDataAndHitAPI() {
        if txtNewPassword.isBlank {
            Proxy.shared.displayStatusCodeAlert(AlertValue.newPassword)
        } else if Proxy.shared.isValidPassword(txtNewPassword.text!) == false {
            Proxy.shared.displayStatusCodeAlert(AlertValue.validPassword)
        } else if txtConfirmPassword.isBlank {
            Proxy.shared.displayStatusCodeAlert(AlertValue.confirmPassword)
        } else if txtNewPassword.text! != txtConfirmPassword.text! {
            Proxy.shared.displayStatusCodeAlert(AlertValue.confirmPassword)
        } else {
            objChangePasswordVM.confirmPassword = txtConfirmPassword.text!
             objChangePasswordVM.Password = txtNewPassword.text!
            objChangePasswordVM.changePasswordApi {
              Proxy.shared.popToBackVC(isAnimate: true, currentViewController: self)
            }
        }
    }
}
