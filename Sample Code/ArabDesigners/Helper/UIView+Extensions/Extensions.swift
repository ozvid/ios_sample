//
//  Extensions.swift
//  ArabDesigners
//
//  Created by Shiv Charan Panjeta < shiv@ozvid.com > on 02/02/2019.
//  Copyright © 2019 OZVID Technologies Pvt. Ltd. < www.ozvid.com >. All rights reserved.
//
import Foundation
import UIKit

//MARK: - GetTopMostViewController
extension UIViewController {
    func topMostViewController() -> UIViewController {
        if self.presentedViewController == nil {
            return self
        }
        if let navigation = self.presentedViewController as? UINavigationController {
            return (navigation.visibleViewController?.topMostViewController())!
        }
        if let tab = self.presentedViewController as? UITabBarController {
            if let selectedTab = tab.selectedViewController {
                return selectedTab.topMostViewController()
            }
            return tab.topMostViewController()
        }
        return self.presentedViewController!.topMostViewController()
    }
}

extension UIApplication {
    func topMostViewController() -> UIViewController? {
        return self.keyWindow?.rootViewController?.topMostViewController()
    }
}


//MARK:-
extension UITextField {
    var isBlank : Bool {
        return (self.text?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)!
    }
    var trimmedValue : String {
        return (self.text?.trimmingCharacters(in: .whitespacesAndNewlines))!
    }
    func setPlaceHolderColor(txtString: String){
        self.attributedPlaceholder = NSAttributedString(string: txtString, attributes: [NSAttributedString.Key.foregroundColor : UIColor.black])
        
    }
    
    func goToNextTextFeild(nextTextFeild:UITextField){
        self.resignFirstResponder()
        nextTextFeild.becomeFirstResponder()
    }
    
}

extension UIColor {
    convenience init(hex: String) {
        let scanner = Scanner(string: hex)
        scanner.scanLocation = 0
        
        var rgbValue: UInt64 = 0
        
        scanner.scanHexInt64(&rgbValue)
        
        let r = (rgbValue & 0xff0000) >> 16
        let g = (rgbValue & 0xff00) >> 8
        let b = rgbValue & 0xff
        
        self.init(
            red: CGFloat(r) / 0xff,
            green: CGFloat(g) / 0xff,
            blue: CGFloat(b) / 0xff, alpha: 1
        )
    }
}

extension String {
    func getAttributedStringWithDifferentFontSize( text : String , fontStyle : String, fontSize : CGFloat, color : UIColor) -> NSAttributedString {
        let attributedString = NSMutableAttributedString(string: text)
        attributedString.addAttribute(NSAttributedString.Key.font, value: UIFont(name: fontStyle, size: fontSize), range: NSMakeRange(0, attributedString.length))
        attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: color, range: NSMakeRange(0, attributedString.length))
        
        return attributedString
    }
    
    var htmlToAttributedString: NSAttributedString? {
        guard let data = data(using: .utf8) else { return NSAttributedString() }
        do {
            return try NSAttributedString(data: data, options: [NSAttributedString.DocumentReadingOptionKey.documentType:  NSAttributedString.DocumentType.html], documentAttributes: nil)
        } catch {
            return NSAttributedString()
        }
    }
    
    var htmlToString: String {
        return htmlToAttributedString?.string ?? ""
    }
    
}


//MARK: - LanguageTranslations

extension UITextField {
    
    open override func awakeFromNib() {
        super.awakeFromNib()
        if let language = UserDefaults.standard.object(forKey: "Language") as? String {
            UserDefaults.standard.set(language, forKey:"Language")
            UserDefaults.standard.synchronize()
            
            if self.textAlignment != .center {
                if language == "en" {
                    self.textAlignment = .left
                }else {
                    self.textAlignment = .right
                }
            }
        }
        else{
            UserDefaults.standard.set("en", forKey:"Language")
            UserDefaults.standard.synchronize()
            if self.textAlignment != .center {
                self.textAlignment = .right
            }
        }
    }
}
extension UITabBarController {
    
    open override func awakeFromNib() {
        
        super.awakeFromNib()
        if userModelObj.appLanguage == "en" {
            UIView.appearance().semanticContentAttribute = .forceLeftToRight
        }
        else {
            UIView.appearance().semanticContentAttribute = .forceRightToLeft
        }
    }
}
extension UIViewController {
    
    open override func awakeFromNib() {
        
        super.awakeFromNib()
        
        if userModelObj.appLanguage == "en" {
            UIView.appearance().semanticContentAttribute = .forceLeftToRight
        }
        else {
            UIView.appearance().semanticContentAttribute = .forceRightToLeft
        }
    }
}

extension UIButton {
    
    open override func awakeFromNib() {
        super.awakeFromNib()
        
        if userModelObj.appLanguage == "ar" {
            self.imageView?.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        }
    }
}


//extension NSAttributedString {
//
//    convenience init?(withLocalizedHTMLString: String) {
//
//        guard let stringData = withLocalizedHTMLString.data(using: String.Encoding.utf8) else {
//            return nil
//        }
//
//        let options: [NSAttributedString.DocumentReadingOptionKey: Any] = [
//            NSAttributedString.DocumentReadingOptionKey.documentType: NSAttributedString.DocumentType.html as Any,
//            NSAttributedString.DocumentReadingOptionKey.characterEncoding: String.Encoding.utf8.rawValue
//        ]
//
//        try? self.init(data: stringData, options: options, documentAttributes: nil)
//    }
//}
