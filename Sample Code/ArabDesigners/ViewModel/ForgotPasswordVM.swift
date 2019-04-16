//
//  ForgotPasswordVM.swift
//  ArabDesigners
//
//  Created by Shiv Charan Panjeta < shiv@ozvid.com > on 2/25/19.
//  Copyright © 2019 OZVID Technologies Pvt. Ltd. < www.ozvid.com >. All rights reserved.
//
//

import Foundation
class ForgotPasswordVM {
    
    //MARK:- Variables
    var email = String()
    
    //MARK:- Signup Api
    func forgotPasswordApi(_ completion:@escaping() -> Void) {
        let param = [
            "User[email]"           : email
            ]  as [String:AnyObject]
        
        WebServiceProxy.shared.postData("\(Apis.KServerUrl)\(Apis.KForgotPassword)", params: param, showIndicator: true, completion: { (JSON) in
            if JSON["status"] as! Int == 200 {
                
                Proxy.shared.displayStatusCodeAlert(JSON["success"] as? String ?? "Please check your email to reset your password!")
                completion()
            } else {
                Proxy.shared.displayStatusCodeAlert(JSON["error"] as? String ?? "Error".localized)
            }
        })
    }
}
