//
//  SearchVM.swift
//  ArabDesigners
//
//  Created by Shiv Charan Panjeta < shiv@ozvid.com > on  3/13/19.
//  Copyright © 2019 OZVID Technologies Pvt. Ltd. < www.ozvid.com >. All rights reserved.
//

import Foundation

class SearchVM  {
    var arrayProductListModel = [ProductListModel]()
    var pageCount = Int()
    var currentPage = Int()
    
    func addWhisList(ProductId:Int, _ completion:@escaping() -> Void) {
        WebServiceProxy.shared.getData("\(Apis.KServerUrl)\(Apis.KAddWishlist)\(ProductId)", showIndicator: true, completion: { (JSON) in
            if JSON["status"] as! Int == 200 {
                if let msg = JSON["message"] as? String {
                    Proxy.shared.displayStatusCodeAlert(msg)
                }
                completion()
            }  else {
                Proxy.shared.displayStatusCodeAlert(JSON["error"] as? String ?? "Error".localized)
            }
        })
     }
    
    // MARK : Handle Search
    func searchProductList(searchText:String, _ completion:@escaping() -> Void) {
        
        var url     = "\(Apis.KServerUrl)\(Apis.KAllProductSearch)\(searchText)&page=\(currentPage)"
        url         = url.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
        
        WebServiceProxy.shared.getData(url, showIndicator: true, completion: { (JSON) in
            if JSON["status"] as! Int == 200 {
                
                if self.currentPage == 0 {
                    self.arrayProductListModel = []
                }
                if let metaDict = JSON["_meta"] as? NSDictionary {
                    self.pageCount = metaDict["pageCount"] as? Int ?? 0
                }
                if let listArray =  JSON["list"] as? NSArray {
                    if listArray.count > 0 {
                        for i in 0..<listArray.count {
                            if let dict = listArray[i] as? NSDictionary {
                                let objProductListModel = ProductListModel()
                                objProductListModel.getProductListModel(detail: dict)
                                self.arrayProductListModel.append(objProductListModel)
                            }
                        }
                    } else {
                        Proxy.shared.displayStatusCodeAlert(AlertValue.noProduct)
                    }
                }
                completion()
            }  else {
                Proxy.shared.displayStatusCodeAlert(JSON["error"] as? String ?? "Error".localized)
            }
        })
    }
}
extension SearchVC: UISearchBarDelegate {
    
    //MARK:- Search Bar Delegate
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = true
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        searchCollVW.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        objSearchVM.currentPage = 0
        objSearchVM.searchProductList(searchText: searchBar.text!) {
            self.searchCollVW.reloadData()
        }
    }
 
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text  = ""
        searchBar.resignFirstResponder()
        searchBar.showsCancelButton     = false
    }
}
extension SearchVC: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    //MARK:- CollectionView Delegate
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return objSearchVM.arrayProductListModel.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectiveProductsCVC", for: indexPath) as! CollectiveProductsCVC
        
        let dictProductList = objSearchVM.arrayProductListModel[indexPath.row]
        
        cell.lblName.text   = dictProductList.titleProduct
        cell.imgvwProduct.sd_setImage(with: URL(string: dictProductList.ProductImage),placeholderImage: UIImage(named: "DUMMY_IMG"))
        cell.lblprice.text  = "SAR \(dictProductList.productRawPrice)"//dictProductList.productprice
        
        cell.discountedPriceLB.text = ""
        if dictProductList.productDiscount != "" {
            
            let attributeString: NSMutableAttributedString =  NSMutableAttributedString(string: dictProductList.productprice)
            attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 2, range: NSMakeRange(0, attributeString.length))
            
            cell.lblprice.attributedText    = attributeString
            cell.discountedPriceLB.text     = "SAR \(dictProductList.productDiscount)"
        }
        
        
        cell.btnAddToCart.tag = indexPath.row
        cell.btnAddToCart.addTarget(self, action: #selector(btnAddToCart(_:)), for: .touchUpInside)
        cell.btnAddToCart.setImage(dictProductList.favourite == 0 ? UIImage(named: "icn_heart_notselected")  : UIImage(named: "icn_heart_selected") , for: .normal)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.size.width/2 - 5, height: 255)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let dictProductList = objSearchVM.arrayProductListModel[indexPath.row]
        let gotoProductDetailVC = storyBoard.instantiateViewController(withIdentifier: "ProductDetailVC") as! ProductDetailVC
        gotoProductDetailVC.ProductId = dictProductList.idCategory
        self.navigationController?.pushViewController(gotoProductDetailVC, animated: true)
        
    }
    //Mark:- BtnAddToCart
    @objc func btnAddToCart(_ sender:UIButton){
        if Proxy.shared.accessTokenNil() == "" {
            Proxy.shared.displayStatusCodeAlert(AlertValue.firstlogin)
        }else{
        let model = objSearchVM.arrayProductListModel[sender.tag]
        objSearchVM.addWhisList(ProductId: model.idCategory) {
            if model.favourite == 0{
                model.favourite =  1
            }else{
                model.favourite =  0
            }
            self.searchCollVW.reloadData()
        }
        }
        
    }
}
