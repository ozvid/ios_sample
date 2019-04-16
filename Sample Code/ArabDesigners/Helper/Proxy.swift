//
//  Proxy.swift
//  ArabDesigners
//
//  Created by Shiv Charan Panjeta < shiv@ozvid.com > on 02/02/2019.
//  Copyright © 2019 OZVID Technologies Pvt. Ltd. < www.ozvid.com >. All rights reserved.
//

import UIKit
import AVFoundation
import AVKit
import Photos
import NVActivityIndicatorView

let KAppDelegate    = UIApplication.shared.delegate as! AppDelegate
let storyBoard      = UIStoryboard(name: "Main", bundle: nil)
let objAJProgressView = AJProgressView()

class Proxy {
    static var shared: Proxy {
        return Proxy()
    }
    fileprivate init(){}
    
    //MARK:- Common Methods
    func getDeviceToken() -> String {
        var deviceTokken =  ""
        if UserDefaults.standard.object(forKey: "device_token") == nil {
            deviceTokken = "00000000055"
        } else {
            deviceTokken = UserDefaults.standard.object(forKey: "device_token")! as! String
        }
        return deviceTokken
    }
    
    func accessTokenNil() -> String {
        if let accessToken = UserDefaults.standard.object(forKey: "access-token") as? String {
            return accessToken
        } else {
            return ""
        }
    }
    
    //MARK:- Push Method
    func pushToNextVC(identifier:String, isAnimate:Bool, currentViewController: UIViewController, title: String) {
        let pushControllerObj   = storyBoard.instantiateViewController(withIdentifier: identifier)
        pushControllerObj.title = title
        currentViewController.navigationController?.pushViewController(pushControllerObj, animated: isAnimate)
    }
    
    func presentVC(identifier:String, isAnimate:Bool, currentViewController: UIViewController, title: String) {
        let presentControllerObj = storyBoard.instantiateViewController(withIdentifier: identifier)
        presentControllerObj.title = title
        currentViewController.navigationController?.present(presentControllerObj, animated: true, completion: nil)
    }
    
    func presentRootVC(identifier:String, isAnimate:Bool, currentViewController: UIViewController) {
        let preasentControllerObj = storyBoard.instantiateViewController(withIdentifier: identifier)
        currentViewController.present(preasentControllerObj, animated: true, completion: nil)
    }
    //MARK:- Pop Method
    func popToBackVC(isAnimate:Bool , currentViewController: UIViewController) {
        currentViewController.navigationController?.popViewController(animated: true)
    }
    
    func rootToVC(identifier:String) {
        let rootControllerObj = storyBoard.instantiateViewController(withIdentifier: identifier)
        KAppDelegate.window!.rootViewController = rootControllerObj
    }
    
    //MARK:- Check Valid Email Method
    func isValidEmail(_ testStr:String) -> Bool  {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
        return (testStr.range(of: emailRegEx, options:.regularExpression) != nil)
    }
    
    func isValidInput(_ Input:String) -> Bool {
        let characterset = CharacterSet(charactersIn: "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLKMNOPQRSTUVWXYZ ")
        if Input.rangeOfCharacter(from: characterset.inverted) != nil {
            Proxy.shared.displayStatusCodeAlert(AlertValue.validName)
            return false
        } else {
            return true
        }
    }
    //MARK:- Check Valid Password Method
    func isValidPassword(_ testStr:String) -> Bool {
        let capitalLetterRegEx  = ".*[A-Za-z]+.*"
        let texttest = NSPredicate(format:"SELF MATCHES %@", capitalLetterRegEx)
        let capitalresult = texttest.evaluate(with: testStr)
        
        let numberRegEx  = ".*[0-9]+.*"
        let texttest1 = NSPredicate(format:"SELF MATCHES %@", numberRegEx)
        let numberresult = texttest1.evaluate(with: testStr)
        
        //        let specialCharacterRegEx  = ".*[!&^%$#@()*/]+.*"
        //        let texttest2 = NSPredicate(format:"SELF MATCHES %@", specialCharacterRegEx)
        //        let specialresult = texttest2.evaluate(with: testStr)
        
        let eightRegEx  = ".{8,}"
        let texttest3 = NSPredicate(format:"SELF MATCHES %@", eightRegEx)
        let eightresult = texttest3.evaluate(with: testStr)
        return  capitalresult && numberresult && eightresult
    }
    
//    //MARK:- Append Array
//    func appendArrayValue(arr : [AnyObject]) -> String {
//        var keyStr           = String()
//        var keyStringCombine = String()
//        for i in 0 ..< arr.count  {
//            if let object = arr[i] as? FilterColor {
//                keyStr = "\(object.id!)"
//                if keyStringCombine.count > 0 {
//                    keyStringCombine = "\(keyStringCombine),\(keyStr)"
//                } else{
//                    keyStringCombine = "\(keyStr)"
//                }
//            }else if let object = arr[i] as? ProductDetialModel {
//                keyStr = "\(object.favId!)"
//                if keyStringCombine.count > 0 {
//                    keyStringCombine = "\(keyStringCombine),\(keyStr)"
//                } else{
//                    keyStringCombine = "\(keyStr)"
//                }
//            }
//        }
//        return keyStringCombine
//    }
    //Mark: Play Videos
    func playVideo(_ videoStr:String) {
       
        let videoURL = URL(string: videoStr)
        let player = AVPlayer(url: videoURL!)
        let playerViewController = AVPlayerViewController()
       
        playerViewController.player = player
       
        KAppDelegate.window?.rootViewController?.present(playerViewController, animated: true) {
            playerViewController.player!.play()
        }
    }
    
    //MARK:- Display Alert
    func displayStatusCodeAlert(_ userMessage: String)
    {
        UIView.hr_setToastThemeColor(color: Colors.AppColor)
        KAppDelegate.window!.makeToast(message: userMessage)
    }
    
    //MARK:- Get Date
    func UTCToLocalDate(date:String, inputDateFormat:String, outputFormat:String) -> String {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = inputDateFormat
        let day = dateFormatter.date(from: date)
        dateFormatter.dateFormat = outputFormat
        if day == nil{
            return ""
        } else {
            return dateFormatter.string(from: day!)
        }
    }
    
    //MARK: - HANDLE ACTIVITY
    func showActivityIndicator() {
        
        objAJProgressView.imgLogo = UIImage(named:"ic_logo_login")!
        
        // Pass the color for the layer of progressView
        objAJProgressView.firstColor    = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
        
        // If you  want to have layer of animated colors you can also add second and third color
        objAJProgressView.secondColor   = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        objAJProgressView.thirdColor    = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        
        // Set duration to control the speed of progressView
        objAJProgressView.duration = 3.5
        
        // Set width of layer of progressView
        objAJProgressView.lineWidth = 5.0
        
        //Set backgroundColor of progressView
        objAJProgressView.bgColor =  UIColor.black.withAlphaComponent(0.25)
        
        //Get the status of progressView, if view is animating it will return true.
        _ = objAJProgressView.isAnimating
        
        //Use show() and hide() to manage progressView
        objAJProgressView.show()
        
        
      //  let activityData = ActivityData()
      //  NVActivityIndicatorPresenter.sharedInstance.startAnimating(activityData, nil)
    }
    
    func hideActivityIndicator()  {
        
        objAJProgressView.hide()
        
       // NVActivityIndicatorPresenter.sharedInstance.stopAnimating(nil)
    }
    
    func openSettingApp() {
        let settingAlert = UIAlertController(title: "Connection Problem", message: "Please check your internet connection", preferredStyle: UIAlertController.Style.alert)
        let okAction = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.default, handler: nil)
        settingAlert.addAction(okAction)
        let openSetting = UIAlertAction(title:"Settings", style:UIAlertAction.Style.default, handler:{ (action: UIAlertAction!) in
            let url:URL = URL(string: UIApplication.openSettingsURLString)!
            if #available(iOS 10, *) {
                UIApplication.shared.open(url, options: [:], completionHandler: {
                    (success) in })
            } else {
                guard UIApplication.shared.openURL(url) else {
                    Proxy.shared.displayStatusCodeAlert("Please Review your network settings")
                    return
                }
            }
        })
        settingAlert.addAction(openSetting)
        UIApplication.shared.keyWindow?.rootViewController?.present(settingAlert, animated: true, completion: nil)
    }
    func getDateAndTimeInStr (getDate:String, backendFormat:String, needDateFormat:String, needTimeFormat:String) -> (String,String) {
        
        if getDate != "" &&  getDate != "0000-00-00 00:00:00" {
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = backendFormat//"yyyy-MM-dd hh:mm a"
            let dateInStr = dateFormatter.date(from: getDate)
            
            let dateFormatter1 = DateFormatter()
            dateFormatter1.dateFormat = needDateFormat//"yyyy-MM-dd"
            let resultDateInStr = dateFormatter1.string(from: dateInStr!)
            
            dateFormatter1.dateFormat = needTimeFormat//"hh:mm a"
            let timeInStr = dateFormatter.date(from: getDate)
            let resultTimeInStr = dateFormatter1.string(from: timeInStr!)
            return (resultDateInStr,resultTimeInStr)
        } else {
            return ("","")
        }
    }
}
