//
//  ProfileVC.swift
//  ArabDesigners
//
//  Created by Shiv Charan Panjeta < shiv@ozvid.com > on 02/02/2019.
//  Copyright © 2019 OZVID Technologies Pvt. Ltd. < www.ozvid.com >. All rights reserved.
//

import UIKit
import Kingfisher
import SWRevealViewController

class ProfileVC: UIViewController, SWRevealViewControllerDelegate {
    
    //MARK:- Outlets
    
    @IBOutlet var txtfldEmail: UITextField!
    @IBOutlet var txtfldNumber: UITextField!
    @IBOutlet var txtfldName: UITextField!
    @IBOutlet var tblvwOrders: UITableView!
    @IBOutlet var vwProfileOption: UIView!
    @IBOutlet var vwOrders: UIView!
    @IBOutlet var btnOrders: UIButton!
    @IBOutlet var vwProfile: UIView!
    @IBOutlet var btnProfile: UIButton!
    @IBOutlet var lblName: UILabel!
    @IBOutlet var lblAddress: UILabel!
    @IBOutlet var imgvwProfile: UIImageView!
    @IBOutlet weak var btnCamera: UIButton!
    @IBOutlet weak var btnUpdateProfile: UIButton!
    
    @IBOutlet weak var detailsPageIMG: UIImageView!
    //Mark: Varriable
    
    var objCustomPicker = GalleryCameraImage()
    var objProfileVM    = ProfileVM()
    
    //MARK: - ViewLifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        objCustomPicker.delegate = self
        if userModelObj.appLanguage == "ar" {
            detailsPageIMG.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        }        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        userModelObj.typeCategory = 1
        self.tabBarController?.tabBar.isHidden = false
        if objProfileVM.openImageVal == false {
            
            btnUpdateProfile.setImage( UIImage(named: "ic_edit"), for: .normal)
            changeView(btnProfile)
            updateUI()
            getUserData()
        } else {
            objProfileVM.openImageVal = false
        }
    }
    
    func changeView(_ sender: UIButton) {
        
        btnOrders.setTitleColor(UIColor.lightGray, for: .normal)
        btnProfile.setTitleColor(UIColor.lightGray, for: .normal)
        
        tblvwOrders.isHidden        = true
        vwProfileOption.isHidden    = true
        vwOrders.isHidden           = true
        vwProfile.isHidden          = true
        
        switch sender {
        case btnProfile:
            btnProfile.setTitleColor(UIColor.black, for: .normal)
            vwProfile.isHidden          = false
            vwProfileOption.isHidden    = false
            btnUpdateProfile.isHidden  = false
        case btnOrders:
            btnOrders.setTitleColor(UIColor.black, for: .normal)
            vwOrders.isHidden          = false
            tblvwOrders.isHidden       = false
            btnUpdateProfile.isHidden  = true
        default:
            break
        }
    }
    
    //MARK:- UIButtonAction
    @IBAction func actionOrders(_ sender: UIButton) {
        
        changeView(btnOrders)
        objProfileVM.currentPage = 0
        objProfileVM.getAllOrderList {
            self.tblvwOrders.reloadData()
        }
    }
    
    @IBAction func actionProfile(_ sender: UIButton) {
        changeView(btnProfile)
    }
    
    @IBAction func actionMenu(_ sender: UIButton) {
        self.tabBarController?.tabBar.isHidden = false
        
        revealViewController().delegate = self
        if (revealViewController()) != nil {
            view.addGestureRecognizer(revealViewController().panGestureRecognizer())
            view.addGestureRecognizer(revealViewController().tapGestureRecognizer())
        }
        if userModelObj.appLanguage    == "ar" {
            self.revealViewController()?.rightRevealToggle(animated:true)
        } else {
            self.revealViewController().revealToggle(animated: true)
        }
    }
    
    @IBAction func actionChangePassword(_ sender: UIButton) {
        
        Proxy.shared.pushToNextVC(identifier: "ChangePasswordVC", isAnimate: true, currentViewController: self, title: "")
    }
    
    @IBAction func actionChat(_ sender: Any) {
        Proxy.shared.pushToNextVC(identifier: "ChatVC", isAnimate: true, currentViewController: self, title:
            "")
    }
    
    @IBAction func btnActionCamera(_ sender: Any) {
        
        objProfileVM.openImageVal       = true
        objCustomPicker.customActionSheet(false, controller: self)
    }
    @IBAction func btnActionProfileUpdate(_ sender: Any) {
        
        if btnUpdateProfile!.currentImage ==  UIImage(named: "ic_edit") {
            btnUpdateProfile.setImage( UIImage(named: "ic_tick"), for: .normal)
            txtfldNumber.isUserInteractionEnabled =  true
            txtfldName.isUserInteractionEnabled =  true
            btnCamera.isUserInteractionEnabled =  true
            btnCamera.isHidden =  false
        }
        else {
            
            objProfileVM.userProfilePic = imgvwProfile.image
            objProfileVM.contactNumber = txtfldNumber.text!
            objProfileVM.userName    = txtfldName.text!
            objProfileVM.updateProfileApi {
                self.btnCamera.isHidden = true
                self.btnUpdateProfile.setImage( UIImage(named: "ic_edit"), for: .normal)
                self.getUserData()
                self.updateUI()
            }
        }
    }
    //MARK: - DrawerDelegates
    
    func revealController(_ revealController: SWRevealViewController!, willMoveTo position: FrontViewPosition) {
        
        if position == .left {
            revealViewController().frontViewController.view.alpha   = 1
            self.tabBarController?.tabBar.isUserInteractionEnabled  = true
        }
        if position == .right {
            revealViewController().frontViewController.view.alpha   = 0.9
            self.tabBarController?.tabBar.isUserInteractionEnabled  = false
        }
    }
}
extension ProfileVC: PassImageDelegate {
    
    func passSelectedimage(selectImage: UIImage) {
        
        objProfileVM.openImageVal = true
        imgvwProfile.image = selectImage
        objProfileVM.userProfilePic = imgvwProfile.image
    }
    //Mark:- UpdateUI
    func updateUI() {
        
        txtfldNumber.isUserInteractionEnabled =  false
        txtfldName.isUserInteractionEnabled =  false
        btnCamera.isUserInteractionEnabled =  false
        btnCamera.isHidden =  true
    }
    //Mark:- Get User Data
    func getUserData() {
        
        txtfldName.text! = userModelObj.name
        txtfldEmail.text = userModelObj.email
        txtfldNumber.text = userModelObj.contactNo
        lblName.text = userModelObj.name
        lblAddress.text = ""
        self.imgvwProfile.kf.setImage(with: URL(string : userModelObj.userProfile), placeholder: UIImage(named: "ic_profile-1"))
    }
}

