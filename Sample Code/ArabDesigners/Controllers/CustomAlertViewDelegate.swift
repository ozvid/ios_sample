
//
//  CustomAlertViewDelegate.swift
//  CustomAlertView
//
//  Created by Created by Shiv Charan Panjeta < shiv@ozvid.com > on 16/3/17.
//  Copyright © 2019 OZVID Technologies Pvt. Ltd. < www.ozvid.com >. All rights reserved.
//


protocol CustomAlertViewDelegate: class {
    func cancelButtonTapped()
}

import UIKit
var customAlert = CallCustomAlertView()

class CallCustomAlertView: UIViewController, CustomAlertViewDelegate {
    
    //MARK: - Controller
    var controller  = UIViewController()
    
    func cancelButtonTapped() {
        self.dismiss(animated: true, completion: nil)
    }
    
    //MARK:- Custom Alert
    func customAlert(currentViewController: UIViewController, titleVal: String, message: String) {
        
        let customAlert = storyBoard.instantiateViewController(withIdentifier: "CustomAlertID") as! CustomAlertView
        
        customAlert.modalPresentationStyle  = UIModalPresentationStyle.overCurrentContext
        customAlert.modalTransitionStyle    = UIModalTransitionStyle.crossDissolve
        customAlert.delegate = currentViewController as? CustomAlertViewDelegate
        customAlert.message     = message
        customAlert.titleVal    = titleVal
        
        currentViewController.present(customAlert, animated: true, completion: nil)
    }
}
