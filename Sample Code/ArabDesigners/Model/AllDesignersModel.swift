//
//  AllDesignersModel.swift
//  ArabDesigners
//
//  Created by Shiv Charan Panjeta < shiv@ozvid.com > on 3/4/19.
//  Copyright © 2019 OZVID Technologies Pvt. Ltd. < www.ozvid.com >. All rights reserved.
//

import Foundation

class AllDesignersModel {
    
    var designerName    = String()
    var designerId      = Int()
    var descriptionStr  = String()
    var image_file      = String()
    
    func getAllDesignersList(detail: NSDictionary) {
      
        designerName    = detail["full_name"] as? String ?? ""
        designerId      = detail["id"] as? Int ?? 0
        descriptionStr  = detail["description"] as? String ?? ""
        image_file      = detail["image_file"] as? String ?? ""
    }
}
class FilterColor {
    
    var title,colorCode : String!
    var id: Int!
    
    func getData(_ detail: NSDictionary) {
        title       = detail["title"] as? String ?? ""
        colorCode   = detail["color_code"] as? String ?? ""
        id          = detail["id"] as? Int ?? 0
    }
}

var filterObj = Filter()
class Filter {
    
    var startPrice,endPrice,categoryId : Int!
    var colorId = String()
    var categoryName = String()
    var isFilterApplied = Bool()
    var colorArr = NSMutableArray()
    var colorIdArr = NSMutableArray()
    
}
