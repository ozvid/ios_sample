//
//  ProfileVM.swift
//  ArabDesigners
//
//  Created by Shiv Charan Panjeta < shiv@ozvid.com > on 11/02/2019..
//  Copyright © 2019 OZVID Technologies Pvt. Ltd. < www.ozvid.com >. All rights reserved.
//

import UIKit
import SDWebImage

class ProfileVM: NSObject {
    
    //MARK: -
    var userProfilePic: UIImage?
    var userName        = String()
    var contactNumber   = String()
    var openImageVal            = Bool()
    var arrayAllOrderListModel  = [AllOrderListModel]()
    
    var pageCount   = 0
    var currentPage = 0
    
    
    //MARK: -- UpdateProfileAPI --
    func updateProfileApi(_ completion:@escaping() -> Void) {
        
        let apiUrl = "\(Apis.KServerUrl)\(Apis.KUpdateProfile)\(userModelObj.id)"
        
        
        var paramImg : [String: UIImage] = [:]
        var paramDict   = [String: Any]()
        
        if userProfilePic != nil {
            paramImg        = ["User[profile_file]": userProfilePic!]
        }
        paramDict   = ["User[full_name]": userName, "User[contact_no]]": contactNumber]
        WebServiceProxy.shared.uploadImage(paramDict as [String : AnyObject], parametersImage: paramImg, addImageUrl: apiUrl, showIndicator: true, completion: { (json) in
            
            if json["status"] as? Int == 200 {
                if let detailDict = json["detail"] as? NSDictionary{
                    userModelObj.setUserWith(detail: detailDict)
                }
                completion()
            } else {
                Proxy.shared.displayStatusCodeAlert(json["error"] as? String ?? "Error".localized)
            }
        })
    }
    
    // MARK : Hande Brand List
    func getAllOrderList(_ completion:@escaping() -> Void) {
        
        WebServiceProxy.shared.getData("\(Apis.KServerUrl)\(Apis.KOrderList)?page=\(currentPage)", showIndicator: true, completion: { (JSON) in
            
            if JSON["status"] as! Int == 200 {
                
                if let metaDict = JSON["_meta"] as? NSDictionary {
                    self.pageCount = metaDict["pageCount"] as? Int ?? 0
                }
                if self.currentPage == 0 {
                    self.arrayAllOrderListModel     = []
                }
                if let listArray =  JSON["list"] as? NSArray {
                    
                    for i in 0..<listArray.count {
                        
                        if let dict = listArray[i] as? NSDictionary {
                            
                            let objAllOrderListModel = AllOrderListModel()
                            objAllOrderListModel.getAllOrderList(detail: dict)
                            self.arrayAllOrderListModel.append(objAllOrderListModel)
                        }
                    }
                }
                completion()
            }  else {
                Proxy.shared.displayStatusCodeAlert(JSON["error"] as? String ?? "Error".localized)
            }
        })
    }
}

extension ProfileVC: UITableViewDelegate, UITableViewDataSource {
    
    //MARK:- TableView Delegate
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return objProfileVM.arrayAllOrderListModel.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell            = tableView.dequeueReusableCell(withIdentifier: "OrdersTVC", for: indexPath) as! OrdersTVC
        cell.selectionStyle = .none
        
        let dictOrder           = objProfileVM.arrayAllOrderListModel[indexPath.row]
        cell.lblPrice.text      = "SAR \(dictOrder.productFinalAmount)"
        cell.lblOrderNo.text    = "OrderNo: \(dictOrder.idCategory)"
        cell.lblCount.text      = "\(dictOrder.ordeCount)"
        
        cell.lblDate.text       = "\(Proxy.shared.UTCToLocalDate(date: dictOrder.orderDate, inputDateFormat: "yyyy-MM-dd HH:mm:ss", outputFormat: "MMM dd, yyyy"))"
        
        if dictOrder.arrayCartItem.count > 0 {
            cell.imgvwProduct.sd_setImage(with: URL(string: dictOrder.arrayCartItem[0].ProductImage),placeholderImage: UIImage(named: "DUMMY_IMG"))
        }
        
        switch dictOrder.orderStatus {
        case OrderState.STATE_PENDING.rawValue:
            
            cell.lblOrderStatus.text = "Order Pending".localized
        case OrderState.STATE_ACCEPTED.rawValue:
            
            cell.lblOrderStatus.text = "Order Accepted".localized
        case OrderState.STATE_SHIPPED.rawValue:
            
            cell.lblOrderStatus.text = "Order Shipped".localized
        case OrderState.STATE_OUT_OF_DELIVERED.rawValue:
            
            cell.lblOrderStatus.text = "Order Out For Delivery".localized
        case OrderState.STATE_DELIVERED.rawValue:
            
            cell.lblOrderStatus.text = "Order Delivered".localized
        case OrderState.STATE_CANCELED.rawValue:
            
            cell.lblOrderStatus.text = "Order Cancelled".localized
        case OrderState.STATE_PAYMENT_PENDING.rawValue:
            
            cell.lblOrderStatus.text = "Order Payment Pending".localized
        default:
            break
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let dictOrder = objProfileVM.arrayAllOrderListModel[indexPath.row]
        
        switch dictOrder.orderStatus {
        case  OrderState.STATE_PAYMENT_PENDING.rawValue,OrderState.STATE_CANCELED.rawValue:
            break
        default:
            let gotoOrderTrackVc = storyBoard.instantiateViewController(withIdentifier: "TrackOrderVC") as! TrackOrderVC
            gotoOrderTrackVc.orderId    = dictOrder.idCategory
            gotoOrderTrackVc.title      = "Orders"
            gotoOrderTrackVc.arrOrderItems  = dictOrder.arrayCartItem
            self.navigationController?.pushViewController(gotoOrderTrackVc, animated: true)
        }
    }
    
    
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        if indexPath.row ==  objProfileVM.arrayAllOrderListModel.count - 1 {
            
            if  objProfileVM.currentPage + 1  < objProfileVM.pageCount {
                
                objProfileVM.currentPage =  objProfileVM.currentPage + 1
                objProfileVM.getAllOrderList {
                    self.tblvwOrders.reloadData()
                }
            }
        }
    }
}
