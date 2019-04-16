//
//  CornerRounded.swift
//  ArabDesigners
//
//  Created by Shiv Charan Panjeta < shiv@ozvid.com > on 02/02/2019.
//  Copyright © 2019 OZVID Technologies Pvt. Ltd. < www.ozvid.com >. All rights reserved.
//

import Foundation
import UIKit

class CornerRounded: UIView {
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        updateCornerRadius()
    }
    
    @IBInspectable var rounded: Bool = false {
        didSet {
            updateCornerRadius()
        }
    }
    
    func updateCornerRadius() {
        layer.cornerRadius = rounded ? frame.size.height / 2 : 0
        
    }
    
}

class CornerBtnWithoutShadow: UIButton {
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        updateCornerRadius()
    }
    
    @IBInspectable var rounded: Bool = false {
        didSet {
            updateCornerRadius()
        }
    }
    
    func updateCornerRadius() {
        layer.cornerRadius = rounded ? frame.size.height / 2 : 0
        
    }
    
}

class CornerRoundedButton: UIButton {
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        updateCornerRadius()
        self.layer.shadowColor  = UIColor.darkGray.cgColor
        self.layer.shadowOffset     = CGSize(width: 3, height: 3)
        self.layer.shadowOpacity    = 0.4
        self.layer.shadowRadius     = 4.0
    }
    
    @IBInspectable var rounded: Bool = false {
        didSet {
            updateCornerRadius()
        }
    }
    
    func updateCornerRadius() {
        layer.cornerRadius = rounded ? 7 : 0
        
    }
    
}

class CornerRoundedImage: UIImageView {
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        updateCornerRadius()
        self.layer.cornerRadius = self.frame.height/2
        self.layer.shadowColor  = UIColor.darkGray.cgColor
        self.layer.shadowOffset     = CGSize(width: 3, height: 3)
        self.layer.shadowOpacity    = 0.4
        self.layer.shadowRadius     = 4.0
    }
    
    @IBInspectable var rounded: Bool = false {
        didSet {
            updateCornerRadius()
        }
    }
    
    func updateCornerRadius() {
        layer.cornerRadius = rounded ? frame.size.height / 2 : 0
        self.layer.cornerRadius = self.frame.height/2
        self.layer.shadowColor = UIColor.darkGray.cgColor
        self.layer.shadowOffset = CGSize(width: 3, height: 3)
        self.layer.shadowOpacity = 0.3
        self.layer.shadowRadius = 2.0
    }
    
}
