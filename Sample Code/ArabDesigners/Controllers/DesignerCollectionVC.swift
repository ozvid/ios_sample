//
//  DesignerCollectionVC.swift
//  ArabDesigners
//
//  Created by Shiv Charan Panjeta < shiv@ozvid.com > on 11/02/2019.
//  Copyright © 2019 OZVID Technologies Pvt. Ltd. < www.ozvid.com >. All rights reserved.
//

import UIKit

class DesignerCollectionVC: UIViewController {

    
    //MARK:- Outlets
    
    @IBOutlet weak var descriptionLB: UILabel!
    @IBOutlet weak var nameLB: UILabel!
    @IBOutlet weak var designerIMG: UIImageView!
    
    @IBOutlet weak var lblHeaderTitle: UILabel!
    @IBOutlet var btnAddToCart: UIButton!
    @IBOutlet var clctnvwProducts: UICollectionView!
    @IBOutlet weak var countLB: UILabel!
  
    @IBOutlet weak var designerCollectiveSV: UIScrollView!
    @IBOutlet weak var designerDetailsV: UIView!
    
    //MARK:-
    var objDesignerCollectionVM = DesignerCollectionVM()
    var designerId = Int()
    var designerName = String()
    
    var selectedModel   = AllDesignersModel()
    
    @IBOutlet weak var lineReadMore: UIView!
    @IBOutlet weak var btnReadMore: UIButton!
    
    //@IBOutlet weak var contentHeightConst: NSLayoutConstraint!
    //MARK: - ViewLifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        btnAddToCart.isHidden = true
        lblHeaderTitle.text = designerName
        
        nameLB.text         = selectedModel.designerName
        descriptionLB.text  = selectedModel.descriptionStr
        designerIMG.sd_setImage(with: URL(string: selectedModel.image_file),placeholderImage: UIImage(named: "DUMMY_IMG"))
        
        if selectedModel.descriptionStr.count < 50 {
            lineReadMore.isHidden   = true
            btnReadMore.isHidden    = true
        }
     }
    
    //MARK: -
    override func viewWillAppear(_ animated: Bool) {
      
        self.tabBarController?.tabBar.isHidden  = true
      
        countLB.isHidden    = userModelObj.cartItemCount == 0 ? true : false
        countLB.text        = "\(userModelObj.cartItemCount)"
        
        objDesignerCollectionVM.currentPage     = 0
        objDesignerCollectionVM.getProductList(ProductId: designerId) {
            self.clctnvwProducts.reloadData()
            
           // self.contentHeightConst.constant = self.designerCollectiveSV.frame.size.height + self.designerDetailsV.frame.size.height
        }
    }
    
    //MARK:- Button Action
    @IBAction func actionBack(_ sender: UIButton) {
        Proxy.shared.popToBackVC(isAnimate: true, currentViewController: self)
    }
    
    @IBAction func actionCart(_ sender: UIButton) {
        
        if Proxy.shared.accessTokenNil() == "" {
            Proxy.shared.rootToVC(identifier: "SigninVC")
            Proxy.shared.displayStatusCodeAlert(AlertValue.firstlogin)
        }else{
            let gotoCartVc = storyBoard.instantiateViewController(withIdentifier: "CartVC") as! CartVC
            gotoCartVc.focusBtn = true
            self.navigationController?.pushViewController(gotoCartVc, animated: true)
        }
    }
    
    @IBAction func actionAddToCart(_ sender: UIButton) {
        
        Proxy.shared.pushToNextVC(identifier: "CartVC", isAnimate: true, currentViewController: self, title: "")
    }
    
    @IBAction func actionReadMore(_ sender: Any) {
        
        customAlert.customAlert(currentViewController: self, titleVal: selectedModel.designerName, message: selectedModel.descriptionStr)
    }
}
extension DesignerCollectionVC: CustomAlertViewDelegate {
    
    func cancelButtonTapped() {
        self.dismiss(animated: true, completion: nil)
    }
}
