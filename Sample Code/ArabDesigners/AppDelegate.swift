//
//  AppDelegate.swift
//  ArabDesigners
//
//  Created by Shiv Charan Panjeta < shiv@ozvid.com > on 02/02/2019.
//   Copyright © 2019 OZVID Technologies Pvt. Ltd. < www.ozvid.com >. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
import UserNotifications
import UserNotificationsUI
import SWRevealViewController
import UserNotifications
import UserNotificationsUI
import FacebookCore
import FacebookLogin

//import GoogleMaps
//import GooglePlaces

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {
    
    var window: UIWindow?
    
    var isAppLaunchFromNotification = false
    var notificationDataDictionary  = NSDictionary()
    
    var isStartedFromLink   = false
    var productLink         = String()
    
    //MARK: -
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        setupKeys()
        generateDeviceToken(application)
        HandlePushFromDidLaunch(launchOptions)
        
        SDKApplicationDelegate.shared.application(application, didFinishLaunchingWithOptions: launchOptions)
        
        if let language = UserDefaults.standard.object(forKey: "Language") as? String {
            if language == "ar" {
                userModelObj.appLanguage    = "ar"
            }
            else {
                userModelObj.appLanguage    = "en"
            }
        } else {
            userModelObj.appLanguage    = "en"
        }
        
        Language.DoTheSwizzling()
        return true
    }
    
    func setupKeys() -> Void {
        
        IQKeyboardManager.shared.enableAutoToolbar  = true
        IQKeyboardManager.shared.enable             = true
        
        UserDefaults.standard.setValue(false, forKey: "_UIConstraintBasedLayoutLogUnsatisfiable")
    }
    
    
    func HandlePushFromDidLaunch(_ launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Void {
        
        let remoteNotif = launchOptions?[UIApplication.LaunchOptionsKey.remoteNotification] as? [String: Any]
        if remoteNotif != nil {
            isAppLaunchFromNotification     = true
        }
        else {
            isAppLaunchFromNotification     = false
        }
        
        //TODO: HandleUniversalLinks - WhenTerminated
        if let activityDic  = launchOptions?[UIApplication.LaunchOptionsKey.userActivityDictionary] as? NSDictionary {
            let activity    = activityDic["UIApplicationLaunchOptionsUserActivityKey"] as! NSUserActivity
            
            isStartedFromLink   = true
            productLink    = activity.webpageURL?.absoluteString ?? "No URL"
        }
    }
    
    //MARK: - Universal Links
    
    func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {
        
        //TODO: HandleUniversalLinks - WhenBackGround
        
        if userActivity.activityType == NSUserActivityTypeBrowsingWeb {
            
            let url = userActivity.webpageURL!
            isStartedFromLink   = true
            productLink         = url.absoluteString
            let visibleVC   = getCurrentController()
                
            let productArr = productLink.components(separatedBy: "id=")
            
            if productArr.count > 1 {
                let productId = Int(productArr[1]) ?? 0
                //(productLink.replacingOccurrences(of: Apis.KShareLink, with: "")) ?? 0
                if productId != 0 {
                    let gotoProductDetailVC         = storyBoard.instantiateViewController(withIdentifier: "ProductDetailVC") as! ProductDetailVC
                    gotoProductDetailVC.ProductId   = productId
                    visibleVC.navigationController?.pushViewController(gotoProductDetailVC, animated: true)
                }
            }
        }
        return true
    }
    
    //MARK: -
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        
        return SDKApplicationDelegate.shared.application(app, open: url, options: options)
    }
    
    //MARK: - GetDeviceToken
    
    func generateDeviceToken(_ application: UIApplication) -> Void {
        
        let center  = UNUserNotificationCenter.current()
        center.delegate = self
        center.requestAuthorization(options: [.sound, .alert, .badge]) { (granted, error) in
            if error == nil{
                DispatchQueue.main.async(execute: {
                    UIApplication.shared.registerForRemoteNotifications()
                })
            }
        }
    }
    
    func application(_ application: UIApplication,
                     didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let tokenParts = deviceToken.map { data -> String in
            return String(format: "%02.2hhx", data)
        }
        
        let token = tokenParts.joined()
        UserDefaults.standard.set(token, forKey: "device_token")
        
    }
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        
        print(error.localizedDescription)
    }
    
    //MARK: -
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        application.applicationIconBadgeNumber  = 0
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    //MARK: - NotificationDelegates
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, openSettingsFor notification: UNNotification?) {
        
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        let userInfo = notification.request.content.userInfo as NSDictionary
        notificationDataDictionary  = userInfo
        
        let visibleController   = getCurrentController()
        if KAppDelegate.isAppLaunchFromNotification == false {
            manageNotificationsWithoutClicks(withContoller: visibleController, and: userInfo)
        }
        completionHandler([.badge, .alert, .sound])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
        let userInfo = response.notification.request.content.userInfo as NSDictionary
        notificationDataDictionary  = userInfo
        
        let visibleVC   = getCurrentController()
        
        if KAppDelegate.isAppLaunchFromNotification == false {
            manageNotificationsClicks(withContoller: visibleVC, and: userInfo)
        }
        completionHandler()
    }
    
    //MARK: - GetCurrentController
    func getCurrentController() -> UIViewController {
        
        if let viewC    = UIApplication.shared.topMostViewController(), let revealViewC = viewC  as? SWRevealViewController, let tabCntrl = revealViewC.frontViewController as? TabBarVC, let navigationCntrl =  tabCntrl.selectedViewController as? UINavigationController {
            
            return navigationCntrl.visibleViewController!
        }
        else if let viewC   = UIApplication.shared.topMostViewController() {
            return viewC
        }
        return UIViewController()
    }
    
    //MARK: -
    
    func manageNotificationsClicks(withContoller controller : UIViewController, and userInfo: NSDictionary) -> Void {
        
        let actionType  = userInfo["action"] as? String ?? ""
        if actionType == PushNotificationTypes.TYPE_ORDER {
            
            if !controller.isKind(of: TrackOrderVC.self) {
                
                if let detailsDict = userInfo["detail"] as? NSDictionary {
                    let orderID     = detailsDict["model_id"] as? String ?? "\(detailsDict["model_id"] as? Int ?? 0)"
                    let pushControllerObj       = storyBoard.instantiateViewController(withIdentifier: "TrackOrderVC") as! TrackOrderVC
                    pushControllerObj.orderId   = Int(orderID)!
                    controller.navigationController?.pushViewController(pushControllerObj, animated: true)
                }
            } else {
                
                if let detailsDict = userInfo["detail"] as? NSDictionary {
                    let orderID     = detailsDict["model_id"] as? String ?? "\(detailsDict["model_id"] as? Int ?? 0)"
                    let orderDict:[String: String]     = ["orderID": orderID]
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "updateOrderDetails"), object: nil, userInfo: orderDict)
                }
            }
        }
        else if actionType == PushNotificationTypes.TYPE_CHAT {
            if !controller.isKind(of: ChatVC.self) {
                
                let pushControllerObj       = storyBoard.instantiateViewController(withIdentifier: "ChatVC") as! ChatVC
                controller.navigationController?.pushViewController(pushControllerObj, animated: true)
            }
            else {
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "updateChatDetails"), object: nil, userInfo: nil)
            }
        }
    }
    
    func manageNotificationsWithoutClicks(withContoller controller : UIViewController, and userInfo: NSDictionary) -> Void {
        
        let actionType  = userInfo["action"] as? String ?? ""
        if actionType == PushNotificationTypes.TYPE_ORDER {
            
            if controller.isKind(of: TrackOrderVC.self) {
                
                if let detailsDict = userInfo["detail"] as? NSDictionary {
                    let orderID     = detailsDict["model_id"] as? String ?? "\(detailsDict["model_id"] as? Int ?? 0)"
                    let orderDict:[String: String]     = ["orderID": orderID, "isFromPresent": "true"]
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "updateOrderDetails"), object: nil, userInfo: orderDict)
                }
            }
        }
        else if actionType == PushNotificationTypes.TYPE_CHAT{
            if controller.isKind(of: ChatVC.self) {
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "updateChatDetails"), object: nil, userInfo: nil)
            }
        }
    }
}
