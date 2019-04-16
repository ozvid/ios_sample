//
//  NotificationVM.swift
//  ArabDesigners
//
//  Created by Shiv Charan Panjeta < shiv@ozvid.com > on 11/02/2019.
//  Copyright © 2019 OZVID Technologies Pvt. Ltd. < www.ozvid.com >. All rights reserved.
//

import UIKit

class NotificationVM: NSObject {
    
    
    var arrayNotificationModel  = [NotificationModel]()
    var pageCount = 0, currentPage = 0
    
    // MARK : Handle ProductS
    func getNotificationList(_ completion:@escaping() -> Void) {
        WebServiceProxy.shared.getData("\(Apis.KServerUrl)\(Apis.KAllNotification)?page=\(currentPage)", showIndicator: true, completion: { (JSON) in
            if JSON["status"] as! Int == 200 {
                
                if self.currentPage == 0 {
                    self.arrayNotificationModel = []
                }
                if let metaDict = JSON["_meta"] as? NSDictionary {
                    self.pageCount = metaDict["pageCount"] as? Int ?? 0
                }
                
                if let listArray =  JSON["list"] as? NSArray {
                    if listArray.count > 0 {
                        for i in 0..<listArray.count {
                            if let dict = listArray[i] as? NSDictionary {
                                let objNotificationModel = NotificationModel()
                                objNotificationModel.getNotificationList(detail: dict)
                                self.arrayNotificationModel.append(objNotificationModel)
                            }
                        }
                    }else{
                        Proxy.shared.displayStatusCodeAlert(AlertValue.noNotification)
                    }
                }
                completion()
            }  else {
                Proxy.shared.displayStatusCodeAlert(JSON["error"] as? String ?? "Error".localized)
            }
        })
    }
}

extension NotificationVC:  UITableViewDelegate, UITableViewDataSource {
    
    //MARK:- TableView Delegate
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return objNotificationVM.arrayNotificationModel.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        let cell    = tableView.dequeueReusableCell(withIdentifier: "NotificationTVC", for: indexPath) as! NotificationTVC
        
        let detialDict              = objNotificationVM.arrayNotificationModel[indexPath.row]
        cell.lblNotification.text   = detialDict.titleStr
        cell.lblDescription.text    = detialDict.descriptionStr
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        tableView.estimatedRowHeight    = 50
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
       
        if indexPath.row == objNotificationVM.arrayNotificationModel.count - 1 {
        
            if  objNotificationVM.currentPage + 1  < objNotificationVM.pageCount {
                
                objNotificationVM.currentPage =  objNotificationVM.currentPage + 1
                objNotificationVM.getNotificationList {
                    self.tblvwNotification.reloadData()
                }
            }
        }
    }
}

