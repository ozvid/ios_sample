//
//  SizeVM.swift
//  ArabDesigners
//
//  Created by Shiv Charan Panjeta < shiv@ozvid.com > on 11/02/2019.
//  Copyright © 2019 OZVID Technologies Pvt. Ltd. < www.ozvid.com >. All rights reserved.
//

import UIKit

class SizeVM: NSObject {
    
    var arrayCategorySizeModel = [CategorySizeModel]()
    var pageCount = Int()
    var currentPage = Int()
    
    
    // MARK : Hande SizeList
    func getsizeList(_ completion:@escaping() -> Void) {
        WebServiceProxy.shared.getData("\(Apis.KServerUrl)\(Apis.KSizeList)\(currentPage)", showIndicator: true, completion: { (JSON) in
            if JSON["status"] as! Int == 200 {
                if let metaDict = JSON["_meta"] as? NSDictionary {
                    self.pageCount = metaDict["pageCount"] as? Int ?? 0
                }
                if let listArray =  JSON["list"] as? NSArray {
                    for i in 0..<listArray.count {
                        if let dict = listArray[i] as? NSDictionary {
                            let objCategorySizeModel = CategorySizeModel()
                            objCategorySizeModel.getCategorySize(detail: dict)
                            self.arrayCategorySizeModel.append(objCategorySizeModel)
                        }
                        completion()
                    }
                }
            }  else {
                Proxy.shared.displayStatusCodeAlert(JSON["error"] as? String ?? "Error".localized)
            }
        })
    }

}

extension SizeVC:  UITableViewDelegate, UITableViewDataSource {
    
    //MARK:- TableView Delegate
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return objSizeVM.arrayCategorySizeModel.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SizeTVC", for: indexPath) as! SizeTVC
        let sizeDict = objSizeVM.arrayCategorySizeModel[indexPath.row]
        cell.lblProductSize.text = "\(sizeDict.sizeProduct)"
        cell.lblCompareSize.text = "\(sizeDict.compareSizeProduct)"
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
 
}
