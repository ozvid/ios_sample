//
//  OtherProfileVC.swift
//  ArabDesigners
//
//  Created by Shiv Charan Panjeta < shiv@ozvid.com > on 11/02/2019.
//  Copyright © 2019 OZVID Technologies Pvt. Ltd. < www.ozvid.com >. All rights reserved.
//

import UIKit

class OtherProfileVC: UIViewController {
    
    //MARK:- Outlets
    
    @IBOutlet var txtvwBio: UITextView!
    @IBOutlet var txtfldName: UITextField!
    @IBOutlet var vwDesignedClothes: UIView!
    @IBOutlet var btnDesignedClothes: UIButton!
    @IBOutlet var vwProfile: UIView!
    @IBOutlet var btnProfile: UIButton!
    @IBOutlet var lblAddress: UILabel!
    @IBOutlet var imgvwProfile: UIImageView!
    @IBOutlet var lblName: UILabel!
    
    //MARK:-
    override func viewDidLoad() {
        super.viewDidLoad()
    }
     
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = true
    }
    
    
    //MARK:- UIButtonAction
    @IBAction func actionDesignedClothes(_ sender: UIButton) {
   
    
    }
    @IBAction func actionProfile(_ sender: UIButton) {
    
    
    }
    @IBAction func actionBack(_ sender: UIButton) {
        Proxy.shared.popToBackVC(isAnimate: true, currentViewController: self)
    }
}
