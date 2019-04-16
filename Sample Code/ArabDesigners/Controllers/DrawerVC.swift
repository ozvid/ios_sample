//
//  DrawerVC.swift
//  Arab Designers
//
//  Created by ShivCharan Panjeta - https://ozvid.com on 02/02/2019.
//  Copyright © 2019 OZVID Technologies Pvt. Ltd. < www.ozvid.com >. All rights reserved.
//

import UIKit
import SafariServices

class DrawerVC: UIViewController , UITableViewDelegate, UITableViewDataSource, SFSafariViewControllerDelegate {
    
    //MARK:- Outlets
    @IBOutlet weak var tblDrawer: UITableView!
    
    //MARK:- Variables
    var arrMenuItems    = [DrawerModel]()
    
    //MARK: - LifeCycleMethods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.revealViewController().rearViewRevealWidth = self.view.frame.size.width - 80
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        apiCalltoGetListOfPages()
        tblDrawer.reloadData()
    }
    
    //MARK: - CustomMethods
    
    func apiCalltoGetListOfPages() -> Void {
        
        WebServiceProxy.shared.getData("\(Apis.KServerUrl)\(Apis.kGetAllPages)", showIndicator: true, completion: { (JSON) in
            if JSON["status"] as! Int == 200 {
                self.arrMenuItems    = [DrawerModel]()
                if let listArray =  JSON["list"] as? NSArray {
                    for index in 0..<listArray.count {
                       
                        if let dict = listArray[index] as? NSDictionary {
                            
                            let objDrawerModel      = DrawerModel()
                            objDrawerModel.getDrawerItems(detail: dict)
                            self.arrMenuItems.append(objDrawerModel)
                        }
                    }
                    self.tblDrawer.reloadData()
                }
            }
            else {
                Proxy.shared.displayStatusCodeAlert(JSON["error"] as? String ?? "Error".localized)
            }
        })
    }
    
    func goToView(_ viewC : String, with titleStr: String, withSelected index : Int) -> Void {
        
        let view            = self.storyboard?.instantiateViewController(withIdentifier: viewC) as! PrivacyContentVC
        view.title          = titleStr
        view.objDrawerModel = arrMenuItems[index]
        
        let fnc     = ((self.revealViewController().frontViewController! as! UITabBarController).selectedViewController!) as! UINavigationController
        fnc.pushViewController(view, animated: true)
        self.revealViewController().setFrontViewPosition(.left, animated: true)
    }
    
    func moveToView() -> Void {
        
        let view            = self.storyboard?.instantiateViewController(withIdentifier: "ChangeLanguageVC") as! ChangeLanguageVC
        
        let fnc     = ((self.revealViewController().frontViewController! as! UITabBarController).selectedViewController!) as! UINavigationController
        fnc.pushViewController(view, animated: true)
        self.revealViewController().setFrontViewPosition(.left, animated: true)
        
    }
    
    // MARK: -
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
}
