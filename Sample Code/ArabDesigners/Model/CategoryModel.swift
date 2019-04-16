//
//  CategoryModel.swift
//  ArabDesigners
//
//  Created by Shiv Charan Panjeta < shiv@ozvid.com > on  2/21/19.
//  Copyright © 2019 OZVID Technologies Pvt. Ltd. < www.ozvid.com >. All rights reserved.
//

import Foundation
import UIKit

//Mark:- Banner Images
class BannerCategoryModel {
    
    var bannerImage = String()
    
    func getBannerCategory(detail: NSDictionary) {
        bannerImage        = detail["image"] as? String ?? ""
    }
}
//Mark:- Main category
class MainCategoryModel {
    
    var titleCategory = String(),categoryImage = String()
    var idCategory = Int()
    
    func getMainCategory(detail: NSDictionary) {
        idCategory           = detail["id"] as? Int ?? 0
        titleCategory        = detail["title"] as? String ?? ""
        categoryImage        = detail["image"] as? String ?? ""
    }
}

//Mark:- Women&Men Category
class WomenMenCategoryModel {
    
    var titleCategory = String(),categoryImage = String()
    var idCategory = Int()
    
    func getWomenMenCategory(detail: NSDictionary) {
        idCategory           = detail["id"] as? Int ?? 0
        titleCategory        = detail["title"] as? String ?? ""
        categoryImage        = detail["image"] as? String ?? ""
    }
}
//Mark:-  ProductModel
class ProductBrandModel {
    
    var titleCategory = String(),brandProductImage = String()
    var idCategory = Int()
    
    func getProductBrandList(detail: NSDictionary) {
        idCategory          = detail["id"] as? Int ?? 0
        titleCategory        = detail["title"] as? String ?? ""
        brandProductImage        = detail["image"] as? String ?? ""
    }
}
//Mark:-  ProductListModel
class ProductListModel {
    
    var titleProduct = String(), ProductImage = String(), productDescription = String(), productprice = String(), productRawPrice = String(), productDiscount   = String()
    var idCategory = Int()
    var favourite = Int()
    
    func getProductListModel(detail: NSDictionary) {
        
        idCategory          = detail["id"] as? Int ?? 0
        favourite           = detail["wishlist_added"] as? Int ?? 0
        titleProduct        = detail["title"] as? String ?? ""
        ProductImage        = detail["image"] as? String ?? ""
        productDescription  = detail["description"] as? String ?? ""
        productRawPrice     = detail["raw_price"] as? String ?? ""
        productDiscount     = detail["discount"] as? String ?? ""
        
        if let price = detail["price"] as? String {
            productprice = price
        }
        if let price = detail["price"] as? Int {
            productprice = "\(price)"
        }
        if let price = detail["price"] as? Double {
            productprice = "\(price)"
        }
        
        let discountVal = Float(productDiscount) ?? 0.00
        let totalPice   = Float(productRawPrice)!
        
        if discountVal > 0 {
            let discountedPrice     = totalPice * discountVal/100
            productDiscount         = "\(totalPice - discountedPrice)"
        }
        else {
            productDiscount         = ""
        }
    }
}
//Mark:-  ProductListModel
class ProductDetialModel {
    
    var titleProduct = String(),ProductImage = String(),brandName = String(),productDescription = String(),productprice = String(),productSize = String(),productDesignerName = String()
    var idCategory      = Int(), productSizeId = Int(), productColorId = Int(), wishListAdded = Int()
    var productColor    = UIColor()
    var productImagesArray  = [ProductImagesModel]()
    var maincategory_type   = Int()
    var video_file          = String(), productRawPrice = String(), productDiscount   = String()
    
    var arrayProductListModel = [ProductListModel]()
    
    //MARK: -
    func getProductDetialModel(detail: NSDictionary) {
        
        if let subCategoryDetial = detail["Subcategory"] as? NSDictionary {
            brandName       = subCategoryDetial["title"] as? String ?? ""
        }
        
        idCategory          = detail["id"] as? Int ?? 0
        wishListAdded       = detail["wishlist_added"] as? Int ?? 0
        titleProduct        = detail["title"] as? String ?? ""
        productColorId      = detail["description"] as? Int ?? 0
        maincategory_type   = detail["maincategory_type"] as? Int ?? Int(detail["maincategory_type"] as? String ?? "0") ?? 0
        
        productRawPrice     = detail["raw_price"] as? String ?? ""
        productDiscount     = detail["discount"] as? String ?? ""
        
        //Mark:- size Handling
        if let productSizeDetial  = detail["size"] as? NSDictionary {
            
            if let productSizes  = productSizeDetial["size2"] as? Int {
                productSize = "\(productSizes)"
            } else {
                productSize    = productSizeDetial["size2"] as? String ?? ""
            }
            productSizeId    = productSizeDetial["id"] as? Int ?? 0
        }
        
        productDescription  = detail["description"] as? String ?? ""
        
        //Mark: - Designer Handling
        if let productDesignerDetial  = detail["designer"] as? NSDictionary {
            productDesignerName    = productDesignerDetial["full_name"] as? String ?? ""
        }
        //Mark: - Color Handling
        if let productColorDetial  = detail["color"] as? NSDictionary {
            
            //productColor  = UIColor(hex: productColorDetial["title"] as! String)
            productColor = UIColor(hexString: productColorDetial["title"] as! String)
            productColorId    = productColorDetial["id"] as? Int ?? 0
        }
        
        if let price = detail["price"] as? String {
            productprice = price
        }
        if let price = detail["price"] as? Int {
            productprice = "\(price)"
        }
        if let price = detail["price"] as? Double {
            productprice = "\(price)"
        }
        
        let discountVal = Float(productDiscount) ?? 0.00
        let totalPice   = Float(productRawPrice)!
        
        if discountVal > 0{
            let discountedPrice     = totalPice * discountVal/100
            productDiscount         = "\(totalPice - discountedPrice)"
        }
        else {
            productDiscount         = ""
        }
        productImagesArray = []
      
        if let productImagesArray =  detail["images"] as? NSArray {
            
            for i in 0..<productImagesArray.count {
                if let dict = productImagesArray[i] as? NSDictionary {
                
                    let objProductImagesModel = ProductImagesModel()
                    objProductImagesModel.getProductImages(detail: dict)
                    self.productImagesArray.append(objProductImagesModel)
                }
            }
        }
        
        if let similarProductsDict  = detail["similar_products"] as? NSDictionary {
            
            if let similarProductsArr   = similarProductsDict["list"] as? NSArray {
                for i in 0..<similarProductsArr.count {
                    if let dict = similarProductsArr[i] as? NSDictionary {
                        let objProductListModel = ProductListModel()
                        objProductListModel.getProductListModel(detail: dict)
                        self.arrayProductListModel.append(objProductListModel)
                    }
                }
            }
        }
        video_file  = detail["video_file"] as? String ?? ""
    }
}
//Mark: - ProductImages Model 
class ProductImagesModel {
    var ProductImage = String()
    func getProductImages(detail: NSDictionary) {
        ProductImage  = detail["file"] as? String ?? ""
    }
}

//Mark: - ProductSize
class ProductSizeModel {
    var ProductSize = String()
    var productSizeId = Int()
    
    func getProductSize(detail: NSDictionary) {
        
        
        if let productSizeDetial  = detail["Size"] as? NSDictionary {
            
            if let productSizes  = productSizeDetial["size2"] as? Int {
                ProductSize = "\(productSizes)"
            }else{
                ProductSize    = productSizeDetial["size2"] as? String ?? ""
            }
            productSizeId    = productSizeDetial["id"] as? Int ?? 0
        }
    }
}
//Mark: - ProductSize
class ProductColorModel {
    var productColor = UIColor()
    var productColorId = Int()
    
    func getProductColor(detail: NSDictionary) {
        
        if let productColorDetial  = detail["Color"] as? NSDictionary {
            
            //productColor     =   UIColor(hex: productColorDetial["title"] as! String)
            
            productColor = UIColor(hexString: productColorDetial["title"] as! String)
            productColorId    = productColorDetial["id"] as? Int ?? 0
        }
    }
}
//MArk: Size Model
class CategorySizeModel {
    
    var sizeProduct = String() ,compareSizeProduct = String()
    func getCategorySize(detail: NSDictionary) {
        
        if let productSize =  detail["size1"] as? Int {
            sizeProduct = "\(productSize)"
        }else {
            sizeProduct  = detail["size1"] as? String ?? ""
        }
        
        if let productSizeCompare =  detail["size2"] as? Int {
            compareSizeProduct = "\(productSizeCompare)"
        }else {
            compareSizeProduct  = detail["size2"] as? String ?? ""
        }
    }
}



extension UIColor {
    convenience init(hexString: String) {
        let hex = hexString.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int = UInt32()
        Scanner(string: hex).scanHexInt32(&int)
        let a, r, g, b: UInt32
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(red: CGFloat(r) / 255, green: CGFloat(g) / 255, blue: CGFloat(b) / 255, alpha: CGFloat(a) / 255)
    }
}
