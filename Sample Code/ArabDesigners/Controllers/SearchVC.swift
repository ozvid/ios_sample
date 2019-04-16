//
//  SearchVC.swift
//  ArabDesigners
//
//  Created by Shiv Charan Panjeta < shiv@ozvid.com > on 3/13/19.
//  Copyright © 2019 OZVID Technologies Pvt. Ltd. < www.ozvid.com >. All rights reserved.
//

import UIKit

class SearchVC: UIViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var searchCollVW: UICollectionView!
    
    
    var objSearchVM = SearchVM()
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
    }
    override func viewWillAppear(_ animated: Bool) {
          self.tabBarController?.tabBar.isHidden = true
    }
    
    @IBAction func btnBackAction(_ sender: Any) {
        Proxy.shared.popToBackVC(isAnimate: true, currentViewController: self)
    }
}

