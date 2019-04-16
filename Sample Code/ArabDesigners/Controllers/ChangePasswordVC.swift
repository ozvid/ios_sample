//
//  ChangePasswordVC.swift
//  ArabDesigners
//
//  Created by Shiv Charan Panjeta < shiv@ozvid.com > on 2/25/19.
//  Copyright © 2019 OZVID Technologies Pvt. Ltd. < www.ozvid.com >. All rights reserved.
//

import UIKit

class ChangePasswordVC: UIViewController {
    
    //Mark- Outlet
    @IBOutlet weak var txtConfirmPassword: UITextField!
    @IBOutlet weak var txtNewPassword: UITextField!
    
    var objChangePasswordVM = ChangePasswordVM()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func viewWillAppear(_ animated: Bool) {
     self.tabBarController?.tabBar.isHidden = true
    }
    //Mark:- ActionBtn
    @IBAction func btnActionBack(_ sender: Any) {
        Proxy.shared.popToBackVC(isAnimate: true, currentViewController: self)
    }
    @IBAction func btnActionSubmit(_ sender: Any) {
        validateDataAndHitAPI()
    }
}
