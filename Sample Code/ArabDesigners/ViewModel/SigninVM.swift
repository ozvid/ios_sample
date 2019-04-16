//
//  SigninVM.swift
//  ArabDesigners
//
//  Created by Shiv Charan Panjeta < shiv@ozvid.com > on 02/02/2019.
//  Copyright © 2019 OZVID Technologies Pvt. Ltd. < www.ozvid.com >. All rights reserved.
//

import UIKit

class SigninVM: NSObject {
    
    //MARK:- Variables
    var email = String(), password = String(), deviceToken = String()
    
    //MARK:- Login Api
    func loginApi(_ completion:@escaping() -> Void) {
        let param = [
            "LoginForm[username]"       : email,
            "LoginForm[password]"       : password,
            "LoginForm[device_token]"   : "\(Proxy.shared.getDeviceToken())" ,
            "LoginForm[device_type]"    : "2" ,
            "LoginForm[device_name]"    : UIDevice.current.name
            ]  as [String:AnyObject]
        WebServiceProxy.shared.postData("\(Apis.KServerUrl)\(Apis.KLogin)", params: param, showIndicator: true, completion: { (JSON) in
            if JSON["status"] as! Int == 200 {
                Proxy.shared.displayStatusCodeAlert(AlertValue.login)
                if let detailDict = JSON["user_detail"] as? NSDictionary
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
    
    func socialLoginApi (withParameterDict dict: [String:AnyObject] ,_ completion:@escaping() -> Void) {
        
        WebServiceProxy.shared.postData("\(Apis.KServerUrl)\(Apis.ksocialLogin)", params: dict, showIndicator: true, completion: { (JSON) in
            
            if let jsonStatus = JSON["status"] as? Int {
                if jsonStatus == 200 {
                    if let detailDict = JSON["detail"] as? NSDictionary
                    {
                        if let accessToken = detailDict["access_token"] as? String {
                            
                            UserDefaults.standard.set(accessToken, forKey: "access-token")
                            UserDefaults.standard.synchronize()
                        }
                        userModelObj.setUserWith(detail: detailDict)
                    }
                    completion()
                }else{
                    Proxy.shared.displayStatusCodeAlert(JSON["error"] as? String ?? "Error".localized)
                }
            }
            else {
                Proxy.shared.displayStatusCodeAlert("Error with Facebook Login!!")
            }
        })
    }
}

