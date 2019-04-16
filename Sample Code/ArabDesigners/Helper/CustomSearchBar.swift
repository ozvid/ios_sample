//
//  CustomSearchBar.swift
//  ArabDesigners
//
//  Created by Shiv Charan Panjeta < shiv@ozvid.com > on 05/02/2019.
//  Copyright © 2019 OZVID Technologies Pvt. Ltd. < www.ozvid.com >. All rights reserved.
//

import UIKit

class CustomSearchBar: UISearchBar {
    
    override func draw(_ rect: CGRect) {
        
        clearBackgroundColor()
        self.setImage(UIImage.init(named: "ic_menu") , for: .search , state: .normal)
        
        let textFieldInsideSearchBar    = self.value(forKey: "searchField") as! UITextField
        textFieldInsideSearchBar.font   = UIFont(name: "Roboto-Regular", size: 14)
        
        if let textfield    = self.value(forKey: "searchField") as? UITextField {
            textfield.layer.cornerRadius   = textfield.frame.size.height/2.0
            
            if let backgroundview = textfield.subviews.first {
                // Rounded corner
                backgroundview.layer.cornerRadius   = backgroundview.frame.size.height/2.0
                backgroundview.clipsToBounds        = true
            }
        }
    }
    private func clearBackgroundColor() {
        for view in self.subviews {
            view.backgroundColor    = UIColor.clear
            for subview in view.subviews {
                subview.backgroundColor = UIColor.clear
            }
        }
    }
}
