//
//  PrivacyContentVC.swift
//  ArabDesigners
//
//  Created by Shiv Charan Panjeta < shiv@ozvid.com > on 12/03/19.
//  Copyright © 2019 OZVID Technologies Pvt. Ltd. < www.ozvid.com >. All rights reserved.
//

import UIKit

class PrivacyContentVC: UIViewController {

    //MARK: -
    @IBOutlet weak var titleLB: UILabel!
    @IBOutlet weak var contentLB: UILabel!
    
    @IBOutlet weak var paymentSV: UIScrollView!
    
    //MARK: -
    var objDrawerModel  = DrawerModel()
    
    //MARK: - ViewLifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleLB.text    = objDrawerModel.titleStr.capitalized
        contentLB.text  = ""
        
        apiCalltoGetListOfPages()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden  = true
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden  = false
    }
    
    //MARK: - CustomMethods
    
    func apiCalltoGetListOfPages() -> Void {
        
        let urlStr  = "\(Apis.KServerUrl)\(Apis.kPages)\(objDrawerModel.idStr)"
        
        WebServiceProxy.shared.getData(urlStr, showIndicator: true, completion: { (JSON) in
           
            if JSON["status"] as! Int == 200 {
                if let detailsDict  = JSON["detail"] as? NSDictionary {
                    let htmlText = detailsDict["description"] as? String ?? ""
                    
                    guard let data = htmlText.data(using: String.Encoding.unicode) else { return }
                    
                    try? self.contentLB.attributedText =
                        NSAttributedString(data: data,
                                           options: [.documentType:NSAttributedString.DocumentType.html],
                                           documentAttributes: nil)
                    
                    self.contentLB.font = UIFont(name: Fonts.normal, size: 15)
                }
            }
            else {
                Proxy.shared.displayStatusCodeAlert(JSON["error"] as? String ?? "Error".localized)
            }
        })
    }
    
    //MARK: - UIButtonActions
    @IBAction func actionBack(_ sender: Any) {
        
        Proxy.shared.popToBackVC(isAnimate: true, currentViewController: self)
    }
}
