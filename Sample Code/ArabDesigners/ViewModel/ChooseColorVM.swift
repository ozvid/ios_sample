//
//  ChooseColorVM.swift
//  ArabDesigners
//
//  Created by Shiv Charan Panjeta < shiv@ozvid.com > on 11/02/2019.
//  Copyright © 2019 OZVID Technologies Pvt. Ltd. < www.ozvid.com >. All rights reserved.
//

import UIKit

class ChooseColorVM: NSObject {
  
   
    var selectSizeId = Int()
    var productColor = UIColor()
    var productColorId = Int()
    var arrayProductSizeModel = [ProductSizeModel]()
    var arrayProductColorModel = [ProductColorModel]()
    var pageCount = Int()
    var currentPage = Int()
    
    // MARK : Hande productSizeList
    func getProductSizeList(productId : Int, _ completion:@escaping() -> Void) {
        WebServiceProxy.shared.getData("\(Apis.KServerUrl)\(Apis.KProductSize)\(productId)&page=\(currentPage)", showIndicator: true, completion: { (JSON) in
            if JSON["status"] as! Int == 200 {
                if let metaDict = JSON["_meta"] as? NSDictionary {
                    self.pageCount = metaDict["pageCount"] as? Int ?? 0
                }
                if self.currentPage == 0 {
                    self.arrayProductSizeModel = []
                }
                if let listArray =  JSON["list"] as? NSArray {
                    for i in 0..<listArray.count {
                        if let dict = listArray[i] as? NSDictionary {
                            let objProductSizeModel = ProductSizeModel()
                            objProductSizeModel.getProductSize(detail: dict)
                            self.arrayProductSizeModel.append(objProductSizeModel)
                        }
                      
                    }
                  }
                  completion()
                }  else {
                Proxy.shared.displayStatusCodeAlert(JSON["error"] as? String ?? "Error".localized)
            }
        })
    }
    // MARK : Hande getProductColorList
    func getProductColorList(productId : Int, _ completion:@escaping() -> Void) {
        WebServiceProxy.shared.getData("\(Apis.KServerUrl)\(Apis.KProductColor)\(productId)&page=\(currentPage)", showIndicator: true, completion: { (JSON) in
            if JSON["status"] as! Int == 200 {
                if let metaDict = JSON["_meta"] as? NSDictionary {
                    self.pageCount = metaDict["pageCount"] as? Int ?? 0
                }
                if self.currentPage == 0 {
                    self.arrayProductColorModel = []
                }
                if let listArray =  JSON["list"] as? NSArray {
                    for i in 0..<listArray.count {
                        if let dict = listArray[i] as? NSDictionary {
                            let objProductColorModel = ProductColorModel()
                            objProductColorModel.getProductColor(detail: dict)
                            self.arrayProductColorModel.append(objProductColorModel)
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

extension ChooseColorVC: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    //MARK:- CollectionView Delegate
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

        if collectionView == cltnvwColors {
            return colorModelObj.arrayProductColorModel.count
        }
        else {
            return colorModelObj.arrayProductSizeModel.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == cltnvwColors {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ColorOptionCVC", for: indexPath) as! ColorOptionCVC
            let productColorDict = colorModelObj.arrayProductColorModel[indexPath.row]
            cell.vwColor.backgroundColor = productColorDict.productColor
             if colorModelObj.arrayProductColorModel[indexPath.row].productColorId == colorModelObj.productColorId {
               cell.vwColorSelected.isHidden = false
             }else{
             cell.vwColorSelected.isHidden = true
            }
            return cell
         }
        else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SizeOptionCVC", for: indexPath) as! SizeOptionCVC
            
            let productSizeDict = colorModelObj.arrayProductSizeModel[indexPath.row]
            cell.lblSize.text   = productSizeDict.ProductSize
            if colorModelObj.arrayProductSizeModel[indexPath.row].productSizeId == colorModelObj.selectSizeId {
              cell.viewSize.backgroundColor =  UIColor.lightGray
            }else{
              cell.viewSize.backgroundColor = UIColor.clear
            }
            cell.notAvalIMG.isHidden    = true
            
//            if indexPath.row    == 2 {
//                cell.notAvalIMG.isHidden    = false
//            }
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
       
        if collectionView == cltnvwColors {
          
            return CGSize(width: 50, height: 50)
        }
        else {
              return CGSize(width: 50, height: 50)
          //  return CGSize(width: collectionView.frame.size.width/8, height: 50)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == cltnvwColors{
            if colorModelObj.arrayProductColorModel.count > 0 {
                let productColorDict = colorModelObj.arrayProductColorModel[indexPath.row]
                passProductColorObj?.passSelectedColor(colorIdProduct: productColorDict.productColorId ,productColor : productColorDict.productColor)
                colorModelObj.productColorId = productColorDict.productColorId
                cltnvwColors.reloadData()
            }
        }else{
            if colorModelObj.arrayProductSizeModel.count > 0 {
                let productSizeDict = colorModelObj.arrayProductSizeModel[indexPath.row]
                passSizeIdAndProductColorObj?.passSelectedSizeAndColor(sizeIdProduct: productSizeDict.productSizeId, productSize: productSizeDict.ProductSize)
                colorModelObj.selectSizeId = productSizeDict.productSizeId
                clctnvwSize.reloadData()
            }
        }
    }
}
