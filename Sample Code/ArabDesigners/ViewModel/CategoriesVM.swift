//
//  CategoriesVM.swift
//  ArabDesigners
//
//  Created by Shiv Charan Panjeta < shiv@ozvid.com > on19/02/2019.
//  Copyright © 2019 OZVID Technologies Pvt. Ltd. < www.ozvid.com >. All rights reserved.
//

import UIKit
import SDWebImage
class CategoriesVM: NSObject {
    
    
    var arrayProductBrandModel = [ProductBrandModel]()
    var arrayWomenMenCategoryModel = [WomenMenCategoryModel]()
    var pageCount = Int()
    var currentPage = Int()
    
    // MARK : Handle Women&Men
    func getWomenMenList(categoryId:Int, _ completion:@escaping() -> Void) {
        WebServiceProxy.shared.getData("\(Apis.KServerUrl)\(Apis.KWomenMenCategory)\(categoryId)&page=\(currentPage)", showIndicator: true, completion: { (JSON) in
            if JSON["status"] as! Int == 200 {
                
                if self.currentPage == 0 {
                    self.arrayWomenMenCategoryModel = []
                }
                if let metaDict = JSON["_meta"] as? NSDictionary {
                    self.pageCount = metaDict["pageCount"] as? Int ?? 0
                }
                
                if let listArray =  JSON["list"] as? NSArray {
                    for i in 0..<listArray.count {
                        if let dict = listArray[i] as? NSDictionary {
                            let objWomenMenCategoryModel = WomenMenCategoryModel()
                            objWomenMenCategoryModel.getWomenMenCategory(detail: dict)
                            self.arrayWomenMenCategoryModel.append(objWomenMenCategoryModel)
                        }
                        
                    }
                }
                completion()
            }  else {
                Proxy.shared.displayStatusCodeAlert(JSON["error"] as? String ?? "Error".localized)
            }
        })
    }
    // MARK : Hande Brand List
    func getCategoriesList(subCategoryId:Int ,_ completion:@escaping() -> Void) {
        WebServiceProxy.shared.getData("\(Apis.KServerUrl)\(Apis.KSubCategory)\(subCategoryId)&page=\(currentPage)", showIndicator: true, completion: { (JSON) in
            if JSON["status"] as! Int == 200 {
                if let metaDict = JSON["_meta"] as? NSDictionary {
                    self.pageCount = metaDict["pageCount"] as? Int ?? 0
                }
                if self.currentPage == 0 {
                    self.arrayProductBrandModel = []
                }
                if let listArray =  JSON["list"] as? NSArray {
                    for i in 0..<listArray.count {
                        if let dict = listArray[i] as? NSDictionary {
                            let objProductBrandModel = ProductBrandModel()
                            objProductBrandModel.getProductBrandList(detail: dict)
                            self.arrayProductBrandModel.append(objProductBrandModel)
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

extension CategoriesVC: UITableViewDelegate, UITableViewDataSource {
    
    //MARK:- TableView Delegate
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return objCategoriesVM.arrayWomenMenCategoryModel.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryTVC", for: indexPath) as! CategoryTVC
        let backgroundVw                = UIView(frame:cell.frame)
        backgroundVw.backgroundColor    = UIColor.orange
        cell.selectedBackgroundView     = backgroundVw
        if objCategoriesVM.arrayWomenMenCategoryModel.count > 0 {
            let dictWomenMenCategory = objCategoriesVM.arrayWomenMenCategoryModel[indexPath.row]
            cell.lblCategory.text = dictWomenMenCategory.titleCategory
            cell.imgvwCategory.sd_setImage(with: URL(string: dictWomenMenCategory.categoryImage),placeholderImage: UIImage(named: "DUMMY_IMG"))
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        tableView.estimatedRowHeight    = 150
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let dictWomenMenCategory = objCategoriesVM.arrayWomenMenCategoryModel[indexPath.row]
        if userModelObj.typeCategory == 2  {
            userModelObj.typeCategory = 2
        } else {
            userModelObj.typeCategory = 1
        }
        let gotoCollectivesVC = storyBoard.instantiateViewController(withIdentifier: "CollectivesVC") as! CollectivesVC
        gotoCollectivesVC.productId = dictWomenMenCategory.idCategory
        gotoCollectivesVC.typeId = 1
        self.navigationController?.pushViewController(gotoCollectivesVC, animated: true)
        
        
    }
}
extension CategoriesVC: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    //MARK:- CollectionView Delegate
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return  objCategoriesVM.arrayProductBrandModel.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CategryCVC", for: indexPath) as! CategryCVC
        let categoryDict = objCategoriesVM.arrayProductBrandModel[indexPath.row]
        cell.imgvwCategory.sd_setImage(with: URL(string: categoryDict.brandProductImage),placeholderImage: UIImage(named: "DUMMY_LAND_IMG"))
        cell.lblCategoryName.text = categoryDict.titleCategory
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.size.width/2 - 5, height: 260)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
         let categoryDict = objCategoriesVM.arrayProductBrandModel[indexPath.row]
        let gotoCollectivesVC = storyBoard.instantiateViewController(withIdentifier: "CollectivesVC") as! CollectivesVC
        gotoCollectivesVC.productId = categoryDict.idCategory
        self.navigationController?.pushViewController(gotoCollectivesVC, animated: true)
    }
}


