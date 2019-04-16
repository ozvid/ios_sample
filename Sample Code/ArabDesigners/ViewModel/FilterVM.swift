//
//  FilterVM.swift
//  Bella
//
//  Created by Shiv Charan Panjeta < shiv@ozvid.com > on 19/11/18.
//  Copyright © 2019 OZVID Technologies Pvt. Ltd. < www.ozvid.com >. All rights reserved.
//

import UIKit

class FilterVM: NSObject {
    
    //MARK:- Variables
    var colorArr   = [FilterColor]()
   // var arrList    = [CategoryDetail]()
    var totalPage =  Int()
    var currentPage = 0
    var startPrice,endPrice,categoryId : Int!
    var colorId = String()
    
    
    //MARK:- Get Colors Api
    func getColorsApi(_ completion:@escaping() -> Void) {
        WebServiceProxy.shared.getData("\(Apis.KServerUrl)\(Apis.KProductColor)", showIndicator: true, completion: { (JSON) in
            if JSON["status"] as! Int == 200 {
                if let resposeArr = JSON["list"] as? NSArray {
                    for index in 0..<resposeArr.count {
                        let colorModel = FilterColor()
                        if let listDict = resposeArr[index] as? NSDictionary {
                            colorModel.getData(listDict)
                        }
                       // colorModel.getData(resposeArr[index] as! NSDictionary)
                        self.colorArr.append(colorModel)
                    }
                }
                completion()
            } else {
                   Proxy.shared.displayStatusCodeAlert(JSON["error"] as? String ?? "Error".localized)
            }
        })
    }
}


