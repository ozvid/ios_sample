//
//  DesignerVM.swift
//  ArabDesigners
//
//  Created by Shiv Charan Panjeta < shiv@ozvid.com > on 20/02/19.
//  Copyright © 2019 OZVID Technologies Pvt. Ltd. < www.ozvid.com >. All rights reserved.
//

import UIKit

class DesignerVM: NSObject {
    
    var sections = ["A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z"]
    
    var arrayAllDesignersModel  = [AllDesignersModel]()
    var sortDictDesignerName    = NSMutableDictionary()
    var pageCount   = Int()
    var currentPage = Int()
    var sortedKeys  = [String]()
    
    // MARK: - HandeGetAllDesignerList
    func getAllDesignerList(_ completion:@escaping() -> Void) {
        
        WebServiceProxy.shared.getData("\(Apis.KServerUrl)\(Apis.KAllDesigner)\(currentPage)", showIndicator: true, completion: { (JSON) in
           
            if JSON["status"] as! Int == 200 {
                if let metaDict = JSON["_meta"] as? NSDictionary {
                    self.pageCount = metaDict["pageCount"] as? Int ?? 0
                }
                if self.currentPage == 0 {
                    self.arrayAllDesignersModel = []
                }
                if let listArray =  JSON["list"] as? NSArray {
                    for i in 0..<listArray.count {
                        if let dict = listArray[i] as? NSDictionary {
                            let objAllDesignersModel = AllDesignersModel()
                            objAllDesignersModel.getAllDesignersList(detail: dict)
                            self.arrayAllDesignersModel.append(objAllDesignersModel)
                        }
                    }
                }
                self.sortDictDesignerName.removeAllObjects()
                for index in 0..<self.arrayAllDesignersModel.count {
                    
                    let object = self.arrayAllDesignersModel[index]
                    if let character = object.designerName.components(separatedBy: " ")[0].capitalized.first {
                        if var innerArray = self.sortDictDesignerName["\(character)"] as? [AllDesignersModel] {
                            innerArray.append(object)
                            self.sortDictDesignerName["\(character)"] = innerArray
                        } else {
                            self.sortDictDesignerName["\(character)"] = [object]
                        }
                    }
                }
                let sorted = self.sortDictDesignerName.sorted {
                    ($0.key as! String) < ($1.key as! String)
                }
                self.sortedKeys = sorted.map{$0.key as! String}
                completion()
            } else {
                Proxy.shared.displayStatusCodeAlert(JSON["error"] as? String ?? "Error".localized)
            }
        })
    }
}

extension DesignerVC: UITableViewDelegate, UITableViewDataSource {
    
    //MARK:- UITableViewDelegates
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return objDesignerVM.sortedKeys.count // objDesignerVM.arrHeader.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String?
    {
        tableView.sectionIndexColor = UIColor.black
        return objDesignerVM.sortedKeys[section]
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (objDesignerVM.sortDictDesignerName[objDesignerVM.sortedKeys[section]] as! [AllDesignersModel]).count// sec.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell    = tableView.dequeueReusableCell(withIdentifier: "DesignersTVC", for: indexPath) as! DesignersTVC
        
        let ailment = (objDesignerVM.sortDictDesignerName[objDesignerVM.sortedKeys[indexPath.section]] as! [AllDesignersModel])[indexPath.row]
        cell.nameLB.text    = ailment.designerName
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let ailment                 = (objDesignerVM.sortDictDesignerName[objDesignerVM.sortedKeys[indexPath.section]] as! [AllDesignersModel])[indexPath.row]
        let gotoDesignerCollection  = storyBoard.instantiateViewController(withIdentifier: "DesignerCollectionVC") as! DesignerCollectionVC
        gotoDesignerCollection.designerId       = ailment.designerId
        gotoDesignerCollection.designerName     = ailment.designerName
        gotoDesignerCollection.selectedModel    = ailment
        
        self.navigationController?.pushViewController(gotoDesignerCollection, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return objDesignerVM.sections
    }
    
    func tableView(_ tableView: UITableView, sectionForSectionIndexTitle title: String, at index: Int) -> Int {
        return index
    }
}

