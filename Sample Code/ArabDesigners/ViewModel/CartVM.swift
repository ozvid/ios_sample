//
//  CartVM.swift
//  ArabDesigners
//
//  Created by Shiv Charan Panjeta < shiv@ozvid.com > on 11/02/2019.
//  Copyright © 2019 OZVID Technologies Pvt. Ltd. < www.ozvid.com >. All rights reserved.
//

import UIKit
import Kingfisher
class CartVM: NSObject {
    
    //MARK: - Variables
    
    var arrayWishlistAndShoppingListModel = [WishlistAndShoppingListModel]()
    var objAddCartListModel = AddCartListModel()
    var pageCount   = Int()
    var currentPage = Int()
    
    //MARK: - Promocode
    var promoCode       = String()
    var isPromoApplied  = false
    var appliedValue    = 0
    
    //MARK: - Handle getWishList
    
    func getWhisList(_ completion:@escaping() -> Void) {
        
        WebServiceProxy.shared.getData("\(Apis.KServerUrl)\(Apis.KWishList)?page=\(currentPage)", showIndicator: true, completion: { (JSON) in
            
            if JSON["status"] as! Int == 200 {
                
                if self.currentPage == 0 {
                    self.arrayWishlistAndShoppingListModel = []
                }
                if let metaDict = JSON["_meta"] as? NSDictionary {
                    self.pageCount = metaDict["pageCount"] as? Int ?? 0
                }
                
                if let listArray =  JSON["list"] as? NSArray {
                    for i in 0..<listArray.count {
                        if let dict = listArray[i] as? NSDictionary {
                            
                            let objWishlistAndShoppingListModel     = WishlistAndShoppingListModel()
                            objWishlistAndShoppingListModel.getWishlistAndShoppingList(detail: dict)
                            self.arrayWishlistAndShoppingListModel.append(objWishlistAndShoppingListModel)
                        }
                    }
                }
            }
            else {
                Proxy.shared.displayStatusCodeAlert(JSON["error"] as? String ?? "Error".localized)
            }
            completion()
        })
    }
    
    // MARK : Handle removeWhisList
    func removeWishListItem(productId:Int, _ completion:@escaping() -> Void) {
        
        WebServiceProxy.shared.getData("\(Apis.KServerUrl)\(Apis.KRemoveWishListItem)\(productId)", showIndicator: true, completion: { (JSON) in
            if JSON["status"] as! Int == 200 {
                if let msg = JSON["message"] as? String{
                    Proxy.shared.displayStatusCodeAlert(msg)
                }
                
            }  else {
                Proxy.shared.displayStatusCodeAlert(JSON["error"] as? String ?? "Error".localized)
            }
            completion()
        })
    }
    
    // MARK : Handle getAdd Cart Product
    func getAddCartProduct(_ completion:@escaping(_ isSucess: Bool) -> Void) {
        
        WebServiceProxy.shared.getData("\(Apis.KServerUrl)\(Apis.KGetAllCartItem)?page=\(currentPage)", showIndicator: true, completion: { (JSON) in
            
            if JSON["status"] as! Int == 200 {
                if let dict =  JSON["detail"] as? NSDictionary {
                    self.objAddCartListModel.getAddCartList(detail: dict)
                }
                
                if let price = JSON["cart_total"] as? String {
                    self.objAddCartListModel.cartTotal = price
                }
                if let price = JSON["cart_total"] as? Int {
                    self.objAddCartListModel.cartTotal = "\(price)"
                }
                if let price = JSON["cart_total"] as? Double {
                    self.objAddCartListModel.cartTotal = "\(price)"
                }
                
                if let shippingCost     = JSON["shipping_cost"] as? String {
                    self.objAddCartListModel.shippingCost = shippingCost
                }
                else if let shippingCost     = JSON["shipping_cost"] as? Int {
                    self.objAddCartListModel.shippingCost = "\(shippingCost)"
                }
                else if let shippingCost     = JSON["shipping_cost"] as? Float {
                    self.objAddCartListModel.shippingCost = "\(shippingCost)"
                }
                
                completion(true)
            }
            else {
                completion(false)
                Proxy.shared.displayStatusCodeAlert(JSON["error"] as? String ?? "Error".localized)
            }
        })
    }
    //MARK: - Handle Delete Cart Product
    func removeCartItem(api: String, productId:Int, _ completion:@escaping() -> Void) {
        
        WebServiceProxy.shared.getData("\(Apis.KServerUrl)\(api)\(productId)", showIndicator: true, completion: { (JSON) in
            if JSON["status"] as! Int == 200 {
                if let msg = JSON["message"] as? String{
                    Proxy.shared.displayStatusCodeAlert(msg)
                }
                
            }  else {
                Proxy.shared.displayStatusCodeAlert(JSON["error"] as? String ?? "Error".localized)
            }
            completion()
        })
    }
    
    func updateCartItem( cartProductId:Int, quantity: String, _ completion:@escaping() -> Void) {
        
        let param = ["CartItem[quantity]": quantity]
        
        WebServiceProxy.shared.postData("\(Apis.KServerUrl)\(Apis.kEditCartItem)\(cartProductId)", params: param as Dictionary<String, AnyObject>, showIndicator: true) { (JSON) in
            
            if JSON["status"] as! Int == 200 {
                if let msg = JSON["message"] as? String{
                    Proxy.shared.displayStatusCodeAlert(msg)
                }
                
            }  else {
                Proxy.shared.displayStatusCodeAlert(JSON["error"] as? String ?? "Error".localized)
            }
            completion()
        }
    }
    
    //MARK: - Handle Promo Code
    func applyPromoCodeApi(promoCode:String, _ completion:@escaping() -> Void) {
        
        WebServiceProxy.shared.getData("\(Apis.KServerUrl)\(Apis.kAddPromo)\(promoCode)", showIndicator: true, completion: { (JSON) in
            if JSON["status"] as! Int == 200 {
                if let msg = JSON["message"] as? String{
                    Proxy.shared.displayStatusCodeAlert(msg)
                }
                if let detailsDict = JSON["detail"] as? NSDictionary {
                    
                    self.isPromoApplied  = true
                    self.appliedValue    = detailsDict["discount"] as? Int ?? Int(detailsDict["discount"] as? String ?? "0") ?? 0
                }
                
            }  else {
                Proxy.shared.displayStatusCodeAlert(JSON["error"] as? String ?? "Error".localized)
            }
            completion()
        })
    }

}

extension CartVC: UITableViewDelegate, UITableViewDataSource {
    
    //MARK:- TableView Delegate
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if focusBtn == true {
            return objCartVM.objAddCartListModel.arrayCartItem.count
        } else {
            return objCartVM.arrayWishlistAndShoppingListModel.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell                    = tableView.dequeueReusableCell(withIdentifier: "CartItemsTVC", for: indexPath) as! CartItemsTVC
        cell.selectionStyle         = .none
        
        cell.btnRemoveWishListItem.tag  = indexPath.row
        
        if focusBtn == true {
            if objCartVM.objAddCartListModel.arrayCartItem.count > 0 {
                
                let dictDetial      = objCartVM.objAddCartListModel.arrayCartItem[indexPath.row]
                
                cell.lblSize.text   = "Size: \(dictDetial.productSize)"
                cell.lblPrice.text  = "SAR \(Float(dictDetial.productDiscount)! * Float(dictDetial.productQuantity))"
                cell.lblProductName.text    = dictDetial.titleProduct
                
                cell.lblQuantity.text       = " \("Quantity:".localized) \(dictDetial.productQuantity)"
                cell.imgvwProduct.kf.setImage(with: URL(string : dictDetial.ProductImage), placeholder: UIImage(named: "DUMMY_IMG"))
                cell.uiVwColor.backgroundColor  = dictDetial.productColor
                
                cell.btnRemoveWishListItem.tag  = indexPath.row
                cell.btnRemoveWishListItem.setTitle("Remove or move to Wishlist".localized, for: .normal)
                cell.btnRemoveWishListItem.addTarget(self, action: #selector(btnRemoveWishListItem(_:)), for: .touchUpInside)
                
                cell.btnAddToCart.isHidden  = true
                cell.btnPlus.isHidden       = false
                cell.btnMinus.isHidden      = false
                
                cell.btnPlus.tag    = indexPath.row
                cell.btnPlus.addTarget(self, action: #selector(btnIncreaseQuantity(_:)), for: .touchUpInside)
                
                cell.btnMinus.tag    = indexPath.row
                cell.btnMinus.addTarget(self, action: #selector(btnDecreaseQuantity(_:)), for: .touchUpInside)
                
            }
        } else {
            
            if objCartVM.arrayWishlistAndShoppingListModel.count > 0 {
            
                let dictDetial = objCartVM.arrayWishlistAndShoppingListModel[indexPath.row]
                
                cell.lblSize.text       = "Size: \(dictDetial.productSize)"
                //cell.lblPrice.text      = dictDetial.productprice
                cell.lblPrice.text      = "SAR \(dictDetial.productDiscount)"
                
                cell.lblProductName.text    = dictDetial.titleProduct
                cell.lblQuantity.text       = " \("Quanity:".localized) \(dictDetial.productQuantity)"
                
                
                cell.imgvwProduct.kf.setImage(with: URL(string : dictDetial.ProductImage), placeholder: UIImage(named: "DUMMY_IMG"))
                cell.uiVwColor.backgroundColor = dictDetial.productColor
                cell.btnRemoveWishListItem.tag = indexPath.row
                cell.btnRemoveWishListItem.setTitle("Remove from Wishlist".localized, for: .normal)
                cell.btnRemoveWishListItem.addTarget(self, action: #selector(btnRemoveWishListItem(_:)), for: .touchUpInside)
                
                cell.btnPlus.isHidden       = true
                cell.btnMinus.isHidden      = true
                
                cell.btnAddToCart.isHidden  = false
                cell.btnAddToCart.tag       = indexPath.row
                cell.btnAddToCart.isHidden  = false
                cell.btnAddToCart.addTarget(self, action: #selector(addToCart(_:)), for: .touchUpInside)
                
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        tableView.estimatedRowHeight    = 250
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        
        if !isWishlist {
            let view  = tableView.dequeueReusableCell(withIdentifier: "CartFooterTVC") as! CartFooterTVC
           
            if  objCartVM.objAddCartListModel.arrayCartItem.count == 0 {
               
                view.lblTotalPriceItem.text     = "SAR \(0.0)"
                view.lblTotalPrice.text         = "SAR \(0.0)"
                view.lblShippingCharges.text    = "SAR \(0.0)"
                view.lblPriceSaving.text        = "\("You're Saving:".localized) SAR\(0.0)"
                
            } else {
                
                var totalPriceOfCart = Float()
                
                for index in 0..<objCartVM.objAddCartListModel.arrayCartItem.count {
                    
                    let dict      = objCartVM.objAddCartListModel.arrayCartItem[index]
                    totalPriceOfCart    = totalPriceOfCart + (Float(Float(dict.productDiscount)! * Float(dict.productQuantity)))
                }
                objCartVM.objAddCartListModel.cartTotal = "\(totalPriceOfCart)"
                                
                let shippingCost        = Float(objCartVM.objAddCartListModel.shippingCost)!
                let promoCodeDiscount   = (Float(objCartVM.objAddCartListModel.cartTotal)! * Float(objCartVM.appliedValue)) / 100
                
                view.lblTotalPriceItem.text     = "SAR \(objCartVM.objAddCartListModel.cartTotal)"
                view.lblTotalPrice.text         = "SAR \(Float(objCartVM.objAddCartListModel.cartTotal)! - promoCodeDiscount + shippingCost)"
                objCartVM.objAddCartListModel.totalAmountToPay  = "\(Float(objCartVM.objAddCartListModel.cartTotal)! - promoCodeDiscount + shippingCost)"
                
                view.lblShippingCharges.text    = "SAR \(shippingCost)"
                view.lblPriceSaving.text        = "\("You're Saving:".localized) SAR \(promoCodeDiscount)"
            }
            
            view.txtFldPromoCode.text   = objCartVM.promoCode
            view.btnPromoCode.addTarget(self, action: #selector(btnPromo(_:)), for: .touchUpInside)
            
            return view
        }
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        
        if !isWishlist {
            tableView.estimatedSectionFooterHeight  = 200
            return UITableView.automaticDimension
        }
        return 0.1
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.1
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       
        if let indexPaths = tableView.indexPathsForSelectedRows {
            for indexPath in indexPaths {
                tableView.deselectRow(at: indexPath, animated: true)
            }
        }
    }
    
    //MARK: -
    @objc func btnPromo(_ sender:UIButton){
        
        self.view.endEditing(true)
        objCartVM.isPromoApplied  = false
        objCartVM.appliedValue    = 0
        
        if !objCartVM.promoCode.isEmpty {
            objCartVM.applyPromoCodeApi(promoCode: objCartVM.promoCode) {
                self.tblvwCartItems.reloadData()
            }
        }
    }
    
    @objc func addToCartWishlist(_ sender:UIButton){
        Proxy.shared.displayStatusCodeAlert(AlertValue.noImplement)
    }
    
    @objc func addToCart (_ sender:UIButton) {
        
        let dict        = objCartVM.arrayWishlistAndShoppingListModel[sender.tag]
        
        let view        = storyBoard.instantiateViewController(withIdentifier: "ProductDetailVC") as! ProductDetailVC
        view.ProductId  = dict.idCategory
        view.cameFrom   = "Cart"
        self.navigationController?.pushViewController(view, animated: true)
    }
    
    //MARK: - UIButtonActions
    @objc func btnRemoveWishListItem(_ sender:UIButton){
        
        if focusBtn == true {
            actionRemoveOrMove(tag: sender.tag)
        }
        else {
            let model = objCartVM.arrayWishlistAndShoppingListModel[sender.tag]
            objCartVM.removeWishListItem(productId: model.idCategory) {
                self.objCartVM.currentPage  = 0
                self.objCartVM.getWhisList {
                    self.noItemsLB.text     =  "\(self.objCartVM.arrayWishlistAndShoppingListModel.count) items in your Wish List"
                    self.tblvwCartItems.reloadData()
                }
            }
        }
    }
    
    @objc func btnIncreaseQuantity(_ sender: UIButton){
        let dict = objCartVM.objAddCartListModel.arrayCartItem[sender.tag]
       
        var prevQunatity = dict.productQuantity
        prevQunatity = prevQunatity + 1
        
        if prevQunatity <= 10 {
            updateQuantity(cartItemID: dict.idCategory, quantity: "\(prevQunatity)")
        }
    }
    
    @objc func btnDecreaseQuantity(_ sender: UIButton){
        let dict = objCartVM.objAddCartListModel.arrayCartItem[sender.tag]
        
        var prevQunatity = dict.productQuantity
        prevQunatity = prevQunatity - 1
        
        if prevQunatity >= 1 {
            updateQuantity(cartItemID: dict.idCategory, quantity: "\(prevQunatity)")
        }
    }
    
    func updateQuantity(cartItemID: Int, quantity: String) -> Void {
        
        objCartVM.updateCartItem(cartProductId: cartItemID, quantity: quantity) {
            
            self.objCartVM.objAddCartListModel.arrayCartItem    = [CartItems]()
            self.tblvwCartItems.reloadData()
            
            self.objCartVM.getAddCartProduct({ (isSuccess) in
                userModelObj.cartItemCount  = self.objCartVM.objAddCartListModel.arrayCartItem.count
                
                self.noItemsLB.text         =  "\(self.objCartVM.objAddCartListModel.arrayCartItem.count) \("items in your Shopping Bag".localized)"
                self.btnCheckout.isHidden   = self.objCartVM.objAddCartListModel.arrayCartItem.count > 0 ? false : true
                self.tblvwCartItems.reloadData()
            })
        }
    }
    
    //MARK: - Custom Methods
    func actionRemoveOrMove( tag : Int) -> Void {
        
        let model = self.objCartVM.objAddCartListModel.arrayCartItem[tag]
        let alert               = UIAlertController(title: "Remove or move to Wishlist".localized, message: nil, preferredStyle: UIAlertController.Style.actionSheet)
        let removeAction        = UIAlertAction(title: "Remove".localized, style: UIAlertAction.Style.default, handler:{ (action: UIAlertAction!) in
            
            self.objCartVM.removeCartItem(api: Apis.KDeleteCartItem,productId:model.idCategory) {
                self.objCartVM.objAddCartListModel.arrayCartItem    = [CartItems]()
                self.tblvwCartItems.reloadData()
                
                self.objCartVM.getAddCartProduct({ (isSuccess) in
                    userModelObj.cartItemCount  = self.objCartVM.objAddCartListModel.arrayCartItem.count
                    
                    self.noItemsLB.text         =  "\(self.objCartVM.objAddCartListModel.arrayCartItem.count) \("items in your Shopping Bag".localized)"
                    self.btnCheckout.isHidden   = self.objCartVM.objAddCartListModel.arrayCartItem.count > 0 ? false : true
                    self.tblvwCartItems.reloadData()
                })
            }
        })
        alert.addAction(removeAction)
        let moveAction        = UIAlertAction(title:"Move to WishList".localized, style:UIAlertAction.Style.default, handler:{ (action: UIAlertAction!) in
            
            self.objCartVM.removeCartItem(api: Apis.kMoveToWishlist, productId:model.idCategory) {
                
                self.objCartVM.objAddCartListModel.arrayCartItem    = [CartItems]()
                self.tblvwCartItems.reloadData()
                
                self.objCartVM.getAddCartProduct({ (isSuccess) in
                    userModelObj.cartItemCount  = self.objCartVM.objAddCartListModel.arrayCartItem.count
                    
                    self.noItemsLB.text         =  "\(self.objCartVM.objAddCartListModel.arrayCartItem.count) \("items in your Shopping Bag".localized)"
                    self.btnCheckout.isHidden   = self.objCartVM.objAddCartListModel.arrayCartItem.count > 0 ? false : true
                    self.tblvwCartItems.reloadData()
                })
            }
        })
        alert.addAction(moveAction)
        
        let cancelAction        = UIAlertAction(title:"Cancel".localized, style:UIAlertAction.Style.cancel, handler:{ (action: UIAlertAction!) in
            
        })
        alert.addAction(cancelAction)
        alert.view.tintColor    = UIColor.black
        self.present(alert, animated: true, completion: nil)
    }
    
}


extension CartVC: UITextFieldDelegate{
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        objCartVM.promoCode     = textField.text!
        self.tblvwCartItems.reloadData()
        
//        objCartVM.getAddCartProduct({ (isSuccess) in
//            self.noItemsLB.text  =  "\(self.objCartVM.objAddCartListModel.arrayCartItem.count) items in your Shopping Bag"
//            self.tblvwCartItems.reloadData()
//        })
    }
}
