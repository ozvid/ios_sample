//
//  User.swift
//  ArabDesigners
//
//  Created by Shiv Charan Panjeta < shiv@ozvid.com > on 15/02/2019.
//  Copyright © 2019 OZVID Technologies Pvt. Ltd. < www.ozvid.com >. All rights reserved.
//

import Foundation

var userModelObj = User()

class User {
    
    var name = String(), email = String(), contactNo = String(), userProfile = String(), city = String(), zipCode = String(), address = String(), totalPrice = String()
    var id  = Int(), categoryId = Int(), typeCategory = Int(), deliveryType = Int()
    var cartItemCount   = 0
    
    var appLanguage     = "en"
    
    func setUserWith(detail: NSDictionary) {
        
        id                  = detail["id"] as? Int ?? 0
        name                = detail["full_name"] as? String ?? ""
        email               = detail["email"] as? String ?? ""
        contactNo           = detail["contact_no"] as? String ?? ""
        userProfile         = detail["profile_file"] as? String ?? ""
        cartItemCount       = detail["cart_count"] as? Int ?? Int(detail["cart_count"] as? String ?? "0") ?? 0
        
    }
}
