//
//  HomeVM.swift
//  ArabDesigners
//
//  Created by Shiv Charan Panjeta < shiv@ozvid.com > on 02/02/2019.
//  Copyright © 2019 OZVID Technologies Pvt. Ltd. < www.ozvid.com >. All rights reserved.
//

import UIKit
import Kingfisher

class HomeVM: NSObject {
    
    var arrayMainCategoryModel = [MainCategoryModel]()
    var arrayBannerCategoryModel = [BannerCategoryModel]()
    var pageCount = 0
    var currentPage = 0
    
    // MARK : Hande CategoryBanner List
    func getBannerCategoriesList(_ completion:@escaping() -> Void) {
        
        WebServiceProxy.shared.getData("\(Apis.KServerUrl)\(Apis.KBannerCategoryList)\(currentPage)", showIndicator: true, completion: { (JSON) in
        
            if JSON["status"] as! Int == 200 {
            
                if let metaDict = JSON["_meta"] as? NSDictionary {
                    self.pageCount = metaDict["pageCount"] as? Int ?? 0
                }
                if self.currentPage == 0 {
                    self.arrayBannerCategoryModel = []
                }
                if let listArray =  JSON["list"] as? NSArray {
                    for i in 0..<listArray.count {
                        if let dict = listArray[i] as? NSDictionary {
                            let objBannerCategoryModel = BannerCategoryModel()
                            objBannerCategoryModel.getBannerCategory(detail: dict)
                            self.arrayBannerCategoryModel.append(objBannerCategoryModel)
                        }
                    }
                }
                completion()
            }  else {
                Proxy.shared.displayStatusCodeAlert(JSON["error"] as? String ?? "Error".localized)
            }
        })
    }
    
    // MARK : Hande CategoryList
    func getMainCategoriesList(_ completion:@escaping() -> Void) {
        WebServiceProxy.shared.getData("\(Apis.KServerUrl)\(Apis.KMainCategory)\(currentPage)", showIndicator: true, completion: { (JSON) in
       
            if JSON["status"] as! Int == 200 {
                if let metaDict = JSON["_meta"] as? NSDictionary {
                    self.pageCount = metaDict["pageCount"] as? Int ?? 0
                }
                if self.currentPage == 0 {
                    self.arrayMainCategoryModel = []
                }
                
                if let listArray =  JSON["list"] as? NSArray {
                    for i in 0..<listArray.count {
                        if let dict = listArray[i] as? NSDictionary {
                            let objMainCategoryModel = MainCategoryModel()
                            objMainCategoryModel.getMainCategory(detail: dict)
                            self.arrayMainCategoryModel.append(objMainCategoryModel)
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

extension HomeVC: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate {
    
    //MARK:- TableView Delegate
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return objHomeVM.arrayMainCategoryModel.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell    = tableView.dequeueReusableCell(withIdentifier: "CategoryTVC", for: indexPath) as! CategoryTVC
        cell.selectionStyle     = .none
        
        let dictCategoryMain  = objHomeVM.arrayMainCategoryModel[indexPath.row]
        cell.lblCategory.text = dictCategoryMain.titleCategory
        cell.imgvwCategory.kf.setImage(with: URL(string : dictCategoryMain.categoryImage), placeholder: UIImage(named: "DUMMY_LAND_IMG"))
        
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        tableView.estimatedRowHeight    = 160
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let categoryDict        = objHomeVM.arrayMainCategoryModel[indexPath.row]
        let gotoCollectivesVC   = storyBoard.instantiateViewController(withIdentifier: "CollectivesVC") as! CollectivesVC
        gotoCollectivesVC.productId = categoryDict.idCategory
        gotoCollectivesVC.typeId    = 2
        self.navigationController?.pushViewController(gotoCollectivesVC, animated: true)
    }
    
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        if indexPath.row ==  objHomeVM.arrayMainCategoryModel.count - 1 {
            
            if  objHomeVM.currentPage + 1  < objHomeVM.pageCount {
                
                objHomeVM.currentPage =  objHomeVM.currentPage + 1
                objHomeVM.getMainCategoriesList {
                    self.tblvwCategory.reloadData()
                }
            }
        }
    }
    
    //MARK:- CollectionView Delegate
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return objHomeVM.arrayBannerCategoryModel.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProductHomeCVC", for: indexPath) as! ProductHomeCVC
        let dictHeaderBanner = objHomeVM.arrayBannerCategoryModel[indexPath.row]
        cell.imgvwProduct.kf.setImage(with: URL(string : dictHeaderBanner.bannerImage), placeholder: UIImage(named: "DUMMY_LAND_IMG"))
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.size.width, height: collectionView.frame.size.height)
    }
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        
        if indexPath.row == objHomeVM.arrayBannerCategoryModel.count - 1 {
            
            if  objHomeVM.currentPage + 1  < objHomeVM.pageCount {
                
                objHomeVM.currentPage =  objHomeVM.currentPage + 1
                objHomeVM.getBannerCategoriesList {
                    self.clctnvwProducts.reloadData()
                }
            }
        }
        
    }
    //MARK: - ScrollView
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        pageControle.currentPage = Int(clctnvwProducts.contentOffset.x / clctnvwProducts.frame.size.width)
        // pageControle.currentPage = Int(objHomeVM.ar.contentOffset.x / clctnvwProducts.frame.size.width)
    }
    
}
