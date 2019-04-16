//
//  ProductDetailVC.swift
//  ArabDesigners
//
//  Created by Shiv Charan Panjeta < shiv@ozvid.com > on 02/02/2019.
//  Copyright © 2019 OZVID Technologies Pvt. Ltd. < www.ozvid.com >. All rights reserved.
//

import UIKit

class ProductDetailVC: UIViewController {
    
    //MARK:- Outlets
    
    @IBOutlet weak var lblProductPrice: UILabel!
    @IBOutlet var lblProductName: UILabel!
    @IBOutlet var lblProductDesigner: UILabel!
    @IBOutlet var lblProductTitle: UILabel!
    @IBOutlet var productBrandName: UILabel!
    @IBOutlet var lblDescription: UILabel!
    @IBOutlet var lblprice: UILabel!
    @IBOutlet var lblName: UILabel!
    
    @IBOutlet var btnProductSize: UIButton!
    @IBOutlet var btnFav: UIButton!
    @IBOutlet var btnDelivery: UIButton!
    @IBOutlet var btnDesignedBy: UIButton!
    @IBOutlet var btnProductColour: UIButton!
    
    @IBOutlet var pageControl: UIPageControl!
    @IBOutlet var clctnvwImages: UICollectionView!
    @IBOutlet var vwColor: UIView!
    
    @IBOutlet weak var btnAddToBag: UIButton!
    @IBOutlet weak var btnLike: UIButton!
    @IBOutlet weak var btnBag: UIButton!
    @IBOutlet weak var btnAddToWishList: UIButton!
    @IBOutlet weak var deliverTF: UITextField!
    
    @IBOutlet weak var countLB: UILabel!
    @IBOutlet weak var discountedPriceLB: UILabel!
    @IBOutlet weak var moreProductsCV: UICollectionView!
    
    //MARK:- Variable
    var objProductDetailVM  = ProductDetailVM()
    var ProductId       = Int()
    var cameFrom        = String()
    var imageCounter    = 1
    
    let pickerView      = UIPickerView()
    
    //MARK: - ViewLifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = true
        
        if cameFrom == "Cart" {
            btnAddToWishList.setTitle("Remove from Wishlist".localized, for: .normal)
        }
        
        objProductDetailVM.getProductDetial(ProductId: ProductId) {
            
            self.showProductDataDetails()
            
            self.pageControl.numberOfPages = self.objProductDetailVM.objProductDetialModel.productImagesArray.count
            self.clctnvwImages.reloadData()
            self.moreProductsCV.reloadData()
            
            if self.objProductDetailVM.objProductDetialModel.maincategory_type == PostType.TYPE_READYTOWEAR {
                self.btnDelivery.isHidden    = false
                self.deliverTF.isHidden      = false
            }
            else {
                self.btnDelivery.isHidden    = true
                self.deliverTF.isHidden      = true
            }
        }
        passSizeIdAndProductColorObj    = self
        passProductColorObj             = self
        
        countLB.isHidden    = userModelObj.cartItemCount == 0 ? true : false
        countLB.text        = "\(userModelObj.cartItemCount)"
    }
    
    
    
    //MARK:- UIButtonAction
    @IBAction func actionFavorite(_ sender: UIButton) {
        if Proxy.shared.accessTokenNil() == "" {
            Proxy.shared.rootToVC(identifier: "SigninVC")
            Proxy.shared.displayStatusCodeAlert(AlertValue.firstlogin)
        }else{
            let gotoCartVc = storyBoard.instantiateViewController(withIdentifier: "CartVC") as! CartVC
            gotoCartVc.focusBtn = false
            self.navigationController?.pushViewController(gotoCartVc, animated: true)
        }
    }
    
    @IBAction func actionCart(_ sender: UIButton) {
        
        if Proxy.shared.accessTokenNil() == "" {
            Proxy.shared.rootToVC(identifier: "SigninVC")
            Proxy.shared.displayStatusCodeAlert(AlertValue.firstlogin)
        } else {
            let gotoCartVc = storyBoard.instantiateViewController(withIdentifier: "CartVC") as! CartVC
            gotoCartVc.focusBtn = true
            self.navigationController?.pushViewController(gotoCartVc, animated: true)
        }
        
    }
    @IBAction func actionback(_ sender: UIButton) {
        Proxy.shared.popToBackVC(isAnimate: true, currentViewController: self)
    }
    
    @IBAction func actionDesignedBy(_ sender: UIButton) {
        Proxy.shared.pushToNextVC(identifier: "OtherProfileVC", isAnimate: true, currentViewController: self, title: "")
    }
    @IBAction func btnActionFav(_ sender: Any) {
        if Proxy.shared.accessTokenNil() == "" {
            Proxy.shared.displayStatusCodeAlert(AlertValue.firstlogin)
        }
        else {
            objProductDetailVM.addWhisList(ProductId: objProductDetailVM.objProductDetialModel.idCategory) {
                self.objProductDetailVM.getProductDetial(ProductId: self.ProductId){
                    self.showProductDataDetails()
                }
            }
        }
    }
    
    @IBAction func actionSelectColor(_ sender: UIButton) {
        
        let gotoChooseColor = storyBoard.instantiateViewController(withIdentifier: "ChooseColorVC")as! ChooseColorVC
        gotoChooseColor.productId                   = objProductDetailVM.objProductDetialModel.idCategory
        gotoChooseColor.colorModelObj.selectSizeId  = objProductDetailVM.objProductDetialModel.productSizeId
        gotoChooseColor.colorModelObj.productColor  = objProductDetailVM.objProductDetialModel.productColor
        gotoChooseColor.colorModelObj.productColorId    = objProductDetailVM.objProductDetialModel.productColorId
        
        self.present(gotoChooseColor, animated: true, completion: nil)
    }
    
    @IBAction func btnActionProductSize(_ sender: Any) {
        
        let gotoChooseSize = storyBoard.instantiateViewController(withIdentifier: "ChooseColorVC")as! ChooseColorVC
        gotoChooseSize.productId                    = objProductDetailVM.objProductDetialModel.idCategory
        gotoChooseSize.colorModelObj.selectSizeId   = objProductDetailVM.objProductDetialModel.productSizeId
        gotoChooseSize.colorModelObj.productColor   = objProductDetailVM.objProductDetialModel.productColor
        gotoChooseSize.colorModelObj.productColorId = objProductDetailVM.objProductDetialModel.productColorId
        
        self.present(gotoChooseSize, animated: true, completion: nil)
    }
    
    @IBAction func actionSizeGuide(_ sender: UIButton) {
        Proxy.shared.pushToNextVC(identifier: "SizeVC", isAnimate: true, currentViewController: self, title: "")
    }
    
    @IBAction func actionDelivery(_ sender: UIButton) {
        
        sender.isSelected   = !sender.isSelected
    }
    
    @IBAction func actionShare(_ sender: UIButton) {
        
        if objProductDetailVM.objProductDetialModel.productImagesArray.count > 0 {
            
            let shareItems:Array    = ["\(Apis.KShareLink)\(ProductId)", objProductDetailVM.objProductDetialModel.titleProduct]
            
            let activityViewController:UIActivityViewController = UIActivityViewController(activityItems: shareItems, applicationActivities: nil)
            self.present(activityViewController, animated: true, completion: nil)
        }
    }
    
    @IBAction func actionAddToCart(_ sender: UIButton) {
        
        if self.btnDelivery.isSelected {
            if deliverTF.text == "" {
                Proxy.shared.displayStatusCodeAlert("Please select delivery Time")
                return
            }
        }
        else {
            
            if Proxy.shared.accessTokenNil() == "" {
                Proxy.shared.rootToVC(identifier: "SigninVC")
                Proxy.shared.displayStatusCodeAlert(AlertValue.firstlogin)
            }
            else {
                objProductDetailVM.addToBagProduct(isReadyToWear: btnDelivery.isSelected, deliverTime: deliverTF.text!) {
                    
                    if self.cameFrom == "Cart" {
                        Proxy.shared.popToBackVC(isAnimate: true, currentViewController: self)
                    }
                    else {
                        let gotoCartVc      = storyBoard.instantiateViewController(withIdentifier: "CartVC") as! CartVC
                        gotoCartVc.focusBtn = true
                        self.navigationController?.pushViewController(gotoCartVc, animated: true)
                    }
                }
            }
        }
    }
    
    @IBAction func actionAddToWishlist(_ sender: UIButton) {
        
        if Proxy.shared.accessTokenNil() == "" {
            Proxy.shared.rootToVC(identifier: "SigninVC")
            Proxy.shared.displayStatusCodeAlert(AlertValue.firstlogin)
        }
        else {
            if cameFrom == "Cart" {
                let objCartVM   = CartVM()
                objCartVM.removeWishListItem(productId: ProductId) {
                    Proxy.shared.popToBackVC(isAnimate: true, currentViewController: self)
                }
            }
            else {
                btnActionFav(sender)
            }
        }
    }
    
    @IBAction func actionChat(_ sender: Any) {
        Proxy.shared.pushToNextVC(identifier: "ChatVC", isAnimate: true, currentViewController: self, title:
            "")
    }
}

extension ProductDetailVC: UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
        if textField    == deliverTF {
            
            textField.inputView = self.pickerView
            
            pickerView.dataSource = self
            pickerView.delegate = self
        
        }
        return true
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 19
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return "Delivery \(row+3) Hours"
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        deliverTF.text = "(Delivery \(row+3) Hours)"
    }
}


