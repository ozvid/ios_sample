//
//  TrackOrderVM.swift
//  ArabDesigners
//
//  Created by Shiv Charan Panjeta < shiv@ozvid.com > on 11/02/2019.
//  Copyright © 2019 OZVID Technologies Pvt. Ltd. < www.ozvid.com >. All rights reserved.
//

import UIKit

class TrackOrderVM: NSObject {
    
    var arrayAllOrderListModel = [AllOrderListModel]()
    var pageCount   = Int()
    var currentPage = Int()
    
    var orderStateIMGArr    = ["ordee_placed", "order_confirmend", "ic_order_shipped", "ic_out_of_delivery", "ic_delivered"]
    var orderStateArr       = ["Order Placed", "Order Confirmed", "Order Shipped", "Out for Delivery", "Delivered"]
    
    // MARK : Hande Brand List
    func getAllOrderList(orderId:Int,_ completion:@escaping() -> Void) {
        WebServiceProxy.shared.getData("\(Apis.KServerUrl)\(Apis.KOrderDetial)\(orderId)", showIndicator: true, completion: { (JSON) in
            if JSON["status"] as! Int == 200 {
                if let orderDict = JSON["detail"] as? NSDictionary{
                    objAllOrderListModel.getAllOrderList(detail: orderDict)
                }
                completion()
            }  else {
                Proxy.shared.displayStatusCodeAlert(JSON["error"] as? String ?? "Error".localized)
            }
        })
    }
}


extension TrackOrderVC:  UITableViewDelegate, UITableViewDataSource {
    
    //MARK:- UITableViewDelegate
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "OrderStatusTVC", for: indexPath) as! OrderStatusTVC
        cell.selectionStyle         = .none
        
        cell.lblStatus.text         = objTrackOrderVM.orderStateArr[indexPath.row]
        cell.lblDate.text           = ""
        
        cell.imgvwSelected.image        = UIImage(named: "ic_uncheck")
        cell.imgvwSelected.isHidden     = true
        
        cell.imgvwStateType.image       = cell.imgvwSelected.image?.withRenderingMode(.alwaysTemplate)
        cell.imgvwStateType.image       = UIImage(named: objTrackOrderVM.orderStateIMGArr[indexPath.row])
        
        cell.imgvwStateType.tintColor   = UIColor.lightGray
        cell.lblDate.textColor          = UIColor.lightGray
        cell.lblStatus.textColor        = UIColor.lightGray
        
        
        if objAllOrderListModel.arrStates.count > 0  {
            var arr = NSMutableArray()
            arr = (objAllOrderListModel.arrStates.filter({$0.orderStatus == indexPath.row + 1 }) as NSArray).mutableCopy() as! NSMutableArray
            
            if arr.count > 0 {
                let dict = arr[0] as! OrderStates
                cell.lblDate.text       = "\(Proxy.shared.UTCToLocalDate(date: dict.date, inputDateFormat: "yyyy-MM-dd HH:mm:ss", outputFormat: "dd MMMM, yyyy"))"
                //cell.imgvwSelected.image    = UIImage(named: "ic_tick")
                
                cell.imgvwStateType.tintColor   = UIColor.orange
                cell.lblDate.textColor          = UIColor.orange
                cell.lblStatus.textColor        = UIColor.orange
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
}

