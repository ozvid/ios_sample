//
//  ChangeLanguageVC.swift
//  ArabDesigners
//
//  Created by ShivCharan Panjeta - https://ozvid.com on 02/02/2019.
//  Copyright © 2019 OZVID Technologies Pvt. Ltd. < www.ozvid.com >. All rights reserved.
//

import UIKit

class ChangeLanguageVC: UIViewController {

    // MARK: - Properties
    
    @IBOutlet weak var btnEnglish: UIButton!
    @IBOutlet weak var btnArabic: UIButton!
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()

        if let language = UserDefaults.standard.object(forKey: "Language") as? String {
            if language == "ar" {
                setButtonLayout(btnArabic)
            }
            else {
                setButtonLayout(btnEnglish)
            }
        } else {
            setButtonLayout(btnEnglish)
        }        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden  = true
    }
    //MARK: - UIButtonActions
    
    @IBAction func actionLanguage(_ sender: Any) {
        Proxy.shared.popToBackVC(isAnimate: true, currentViewController: self)
    }
    
    @IBAction func actionEnglish(_ sender: Any) {
        setButtonLayout(btnEnglish)
        UIView.appearance().semanticContentAttribute = .forceLeftToRight
        UserDefaults.standard.set("en", forKey:"Language")
        UserDefaults.standard.synchronize()
        
        userModelObj.appLanguage    = "en"
        
        Proxy.shared.rootToVC(identifier: "TabBarVC")
    }
    
    @IBAction func actionArabic(_ sender: Any) {
        setButtonLayout(btnArabic)
        UIView.appearance().semanticContentAttribute = .forceRightToLeft
        UserDefaults.standard.set("ar", forKey:"Language")
        UserDefaults.standard.synchronize()
        
        userModelObj.appLanguage    = "ar"
        
        Proxy.shared.rootToVC(identifier: "TabBarVC")
    }
    
    
    //MARK: - CustomMethods
    
    func setButtonLayout(_ sender: UIButton) -> Void {
        
        btnArabic.isSelected    = false
        btnEnglish.isSelected   = false
        
        btnArabic.layer.backgroundColor     = UIColor.white.cgColor
        btnEnglish.layer.backgroundColor    = UIColor.white.cgColor
        
        sender.isSelected       = true
        sender.layer.backgroundColor    = UIColor.black.cgColor
        
    }
    // MARK: - E.O.F
    
}
