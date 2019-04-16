//
//  ProductDetailVM.swift
//  ArabDesigners
//
//  Created by Shiv Charan Panjeta < shiv@ozvid.com > on 11/02/2019.
//  Copyright © 2019 OZVID Technologies Pvt. Ltd. < www.ozvid.com >. All rights reserved.
//


import UIKit
import Kingfisher
import AVKit
import AVFoundation
import Lightbox

class ProductDetailVM: NSObject {
    
    var avPlayer: AVPlayer?
    var avPlayerViewConroller: AVPlayerViewController?
    var avPlayerLayer: AVPlayerLayer?
    
    var objProductDetialModel = ProductDetialModel()
    
    //MARK: - Handle ProductDetial
    func getProductDetial(ProductId:Int, _ completion:@escaping() -> Void) {
        
        WebServiceProxy.shared.getData("\(Apis.KServerUrl)\(Apis.KProductDetial)\(ProductId)", showIndicator: true, completion: { (JSON) in
            
            if JSON["status"] as! Int == 200 {
                
                if let detialDict =  JSON["detail"] as? NSDictionary {
                    self.objProductDetialModel.getProductDetialModel(detail: detialDict)
                }
                completion()
            } else {
                Proxy.shared.displayStatusCodeAlert(JSON["error"] as? String ?? "Error".localized)
            }
        })
    }
    
    // MARK : - Handle Whislist
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
    
    //MARK:- AddToBagProduct Api
    func addToBagProduct(isReadyToWear: Bool, deliverTime: String, _ completion:@escaping() -> Void) {
        let param = [
            "CartItem[product_id]"       : objProductDetialModel.idCategory,
            "CartItem[color_id]"         : objProductDetialModel.productColorId,
            "CartItem[size_id]"          : objProductDetialModel.productSizeId ,
            "CartItem[quantity]"         : 1,
            "CartItem[is_ready]"         : isReadyToWear == true ? 1 : 0,
            "CartItem[deliver_time]"     : deliverTime
            
            ]  as [String:AnyObject]
        WebServiceProxy.shared.postData("\(Apis.KServerUrl)\(Apis.KAddCartProduct)", params: param, showIndicator: true, completion: { (JSON) in
            if JSON["status"] as! Int == 200 {
                
                if let msg =  JSON["message"] as? String {
                    Proxy.shared.displayStatusCodeAlert(msg)
                }
                completion()
            } else {
                Proxy.shared.displayStatusCodeAlert(JSON["error"] as? String ?? "Error".localized)
            }
        })
    }
}

extension ProductDetailVC: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    //MARK:- CollectionView Delegate
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if collectionView == moreProductsCV {
            return objProductDetailVM.objProductDetialModel.arrayProductListModel.count
        }
        else {
            
            if objProductDetailVM.objProductDetialModel.video_file != "" {
                return objProductDetailVM.objProductDetialModel.productImagesArray.count + 1
            }
            else {
                return objProductDetailVM.objProductDetialModel.productImagesArray.count
            }
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == moreProductsCV {
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MoreProductsCVC", for: indexPath) as! MoreProductsCVC
            
            let dictProductList = objProductDetailVM.objProductDetialModel.arrayProductListModel[indexPath.row]
            
            cell.lblName.text   = dictProductList.titleProduct
            cell.imgvwProduct.sd_setImage(with: URL(string: dictProductList.ProductImage),placeholderImage: UIImage(named: "DUMMY_IMG"))
            cell.lblprice.text  =  dictProductList.productprice

            cell.btnAddToCart.isHidden  = true
            
            //            cell.btnAddToCart.setImage(dictProductList.favourite == 0 ? UIImage(named: "icn_heart_notselected")  : UIImage(named: "icn_heart_selected") , for: .normal)
//            cell.btnAddToCart.tag = indexPath.row
//            cell.btnAddToCart.addTarget(self, action: #selector(btnAddToCart(_:)), for: .touchUpInside)
            return cell
        }
        else {
            let cell        = collectionView.dequeueReusableCell(withReuseIdentifier: "ProductImagesCVC", for: indexPath) as! ProductImagesCVC
            
            if indexPath.row < objProductDetailVM.objProductDetialModel.productImagesArray.count {
                
                cell.layer.backgroundColor  = UIColor.white.cgColor
                let dictDetial  = objProductDetailVM.objProductDetialModel.productImagesArray[indexPath.row]
                cell.imgvwProduct.kf.setImage(with: URL(string : dictDetial.ProductImage), placeholder: UIImage(named: "DUMMY_IMG"))
                cell.imgvwProduct.isHidden  = false
            }
            else {
                let videoURL = URL(string: objProductDetailVM.objProductDetialModel.video_file)
                
                let player      = AVPlayer(url:videoURL!)
                let av          = AVPlayerViewController()
                av.player       = player
                av.view.frame   = cell.contentView.bounds// whatever
                
                self.addChild(av)
                cell.contentView.addSubview(av.view)
            }
            return cell
        }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == moreProductsCV {
            return CGSize(width: collectionView.frame.size.width/2 - 5, height: 220)
        }
        else {
            return CGSize(width: collectionView.frame.size.width, height: collectionView.frame.size.height)
        }
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if collectionView == moreProductsCV {
            
            let dictProductList = objProductDetailVM.objProductDetialModel.arrayProductListModel[indexPath.row]
            let gotoProductDetailVC = storyBoard.instantiateViewController(withIdentifier: "ProductDetailVC") as! ProductDetailVC
            gotoProductDetailVC.ProductId = dictProductList.idCategory
            self.navigationController?.pushViewController(gotoProductDetailVC, animated: true)
            
        }
        else {
            if indexPath.row < objProductDetailVM.objProductDetialModel.productImagesArray.count {
               
                let dictDetial  = objProductDetailVM.objProductDetialModel.productImagesArray[indexPath.row]
                
                let images = [
                    LightboxImage(imageURL: URL.init(string: dictDetial.ProductImage)!)
                ]
                
                // Create an instance of LightboxController.
                let controller = LightboxController(images: images)
                
                // Set delegates.
                controller.pageDelegate = self
                controller.dismissalDelegate = self
                
                // Use dynamic background.
                controller.dynamicBackground = true
                
                // Present your controller.
                present(controller, animated: true, completion: nil)
            }
        }
    }
}
extension ProductDetailVC: UIScrollViewDelegate,PassSizeIdAndProductColor,PassProductColor {
    
    //MARK: - ScrollView
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        self.pageControl.currentPage    = Int(self.clctnvwImages.contentOffset.x / self.clctnvwImages.frame.size.width)
    }
    
    //Mark: Get Productdetial
    func showProductDataDetails() {
        
        btnFav.setImage(objProductDetailVM.objProductDetialModel.wishListAdded == 0 ? UIImage(named: "icn_heart_notselected")  : UIImage(named: "icn_heart_selected") , for: .normal)
        
        lblProductDesigner.text     = "\("Designed By".localized) \(objProductDetailVM.objProductDetialModel.productDesignerName)"
        lblProductName.text         = objProductDetailVM.objProductDetialModel.titleProduct
        lblProductTitle.text        = objProductDetailVM.objProductDetialModel.titleProduct
        lblProductPrice.text        = objProductDetailVM.objProductDetialModel.productprice
        lblDescription.text         = objProductDetailVM.objProductDetialModel.productDescription
        productBrandName.text       = objProductDetailVM.objProductDetialModel.brandName
        btnProductColour.backgroundColor    = objProductDetailVM.objProductDetialModel.productColor
        
        lblProductPrice.text  = "SAR \(objProductDetailVM.objProductDetialModel.productRawPrice)"//dictProductList.productprice
        
        discountedPriceLB.text = ""
        if objProductDetailVM.objProductDetialModel.productDiscount != "" {
            
            let attributeString: NSMutableAttributedString =  NSMutableAttributedString(string: objProductDetailVM.objProductDetialModel.productprice)
            attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 2, range: NSMakeRange(0, attributeString.length))
            
            lblProductPrice.attributedText    = attributeString
            discountedPriceLB.text     = "SAR \(objProductDetailVM.objProductDetialModel.productDiscount)"
        }
        
        btnProductSize.setTitle("\("Selected Size:".localized) \(objProductDetailVM.objProductDetialModel.productSize)", for: .normal)
    }
    //Mark:- Size Protocol Handle Function
    func passSelectedSizeAndColor(sizeIdProduct: Int, productSize: String) {
        
        objProductDetailVM.objProductDetialModel.productSizeId  = sizeIdProduct
        objProductDetailVM.objProductDetialModel.productSize    = productSize
        btnProductSize.setTitle("\("Selected Size:".localized) \(objProductDetailVM.objProductDetialModel.productSize)", for: .normal)
    }
    
    //Mark:- Color Protocol Handle Function
    func passSelectedColor(colorIdProduct: Int, productColor: UIColor) {
        objProductDetailVM.objProductDetialModel.productColorId = colorIdProduct
        objProductDetailVM.objProductDetialModel.productColor = productColor
        btnProductColour.backgroundColor = objProductDetailVM.objProductDetialModel.productColor
    }
}

extension ProductDetailVC: LightboxControllerPageDelegate {
    
    func lightboxController(_ controller: LightboxController, didMoveToPage page: Int) {
        print(page)
    }
}
extension ProductDetailVC: LightboxControllerDismissalDelegate {
    
    func lightboxControllerWillDismiss(_ controller: LightboxController) {
        // ...
    }
}
