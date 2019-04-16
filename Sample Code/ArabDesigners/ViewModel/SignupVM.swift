//
//  SignupVM.swift
//  ArabDesigners
//
//  Created by Shiv Charan Panjeta < shiv@ozvid.com > on 02/02/2019.
//  Copyright © 2019 OZVID Technologies Pvt. Ltd. < www.ozvid.com >. All rights reserved.
//

import UIKit

class SignupVM: NSObject {
    
    //MARK:- Variables
    var name = String(), phoneNo = String(), email = String(), password = String()
   
    //MARK:- Signup Api
    func signupApi(_ completion:@escaping() -> Void) {
        let param = [
            "User[full_name]"       : name as AnyObject,
            "User[contact_no]"      : phoneNo as AnyObject,
            "User[email]"           : email ,
            "User[password]"        : password
            ]  as [String:AnyObject]
        
            WebServiceProxy.shared.postData("\(Apis.KServerUrl)\(Apis.KSignUp)", params: param, showIndicator: true, completion: { (JSON) in
                if JSON["status"] as! Int == 200 {
                    if let detailDict = JSON["detail"] as? NSDictionary
                    {
                        userModelObj.setUserWith(detail: detailDict)
                        if let id = detailDict["id"] as? Int {
                            UserDefaults.standard.set(id, forKey: "userId")
                            UserDefaults.standard.synchronize()
                        }
                        if let accessToken = detailDict["access_token"] as? String {
                            UserDefaults.standard.set(accessToken, forKey: "access-token")
                            UserDefaults.standard.synchronize()
                        }
                    }
                    completion()
                    
                } else {
                    Proxy.shared.displayStatusCodeAlert(JSON["error"] as? String ?? "Error".localized)
                }
            })
        }
}
