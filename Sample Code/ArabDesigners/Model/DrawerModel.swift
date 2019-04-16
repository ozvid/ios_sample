//
//  DrawerModel.swift
//  ArabDesigners
//
//  Created by Shiv Charan Panjeta < shiv@ozvid.com > on 13/03/19.
//  Copyright © 2019 OZVID Technologies Pvt. Ltd. < www.ozvid.com >. All rights reserved.
//

import UIKit

class DrawerModel: NSObject {

    //MARK: - Variables
    var titleStr = String(), idStr = String()
   
    //MARK: -
    func getDrawerItems(detail: NSDictionary) {
        
        idStr           = detail["type"] as? String ?? "\(detail["type"] as? Int ?? 0)"
        titleStr        = detail["title"] as? String ?? ""
    }
}
