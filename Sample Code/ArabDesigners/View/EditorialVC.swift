//
//  EditorialVC.swift
//  ArabDesigners
//
//  Created by ShivCharan Panjeta - https://ozvid.com/ on 2/22/19.
//  Copyright © 2019 Ozvid Technologies. All rights reserved.
//

import UIKit

class EditorialVC: UIViewController {
   
    @IBOutlet weak var lblHeaderTitle: UILabel!
    @IBOutlet weak var lblVideoTitle: UILabel!
    @IBOutlet weak var collVwEditorial: UICollectionView!
     @IBOutlet weak var tblVwEditorial: UITableView!
    
    
    
    //Mark:- Varriable
     var objEditorialVM  = EditorialVM()
    
    
     //var headerArray = ["LATEST","FASHION","BEAUTY","REPORTER"]
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
     override func viewWillAppear(_ animated: Bool) {
       userModelObj.categoryId = 1
        self.tabBarController?.tabBar.isHidden = false
        objEditorialVM.currentPage = 0
        objEditorialVM.getCategoryVideoList {
            self.collVwEditorial.reloadData()
            self.objEditorialVM.getVideoFilesList(categoryId: self.objEditorialVM.arrayCategoryVideoModel[0].videoCategoryId, {
                self.lblHeaderTitle.text = self.objEditorialVM.arrayVideoListModel[0].headerTitle
                self.lblVideoTitle.text = self.objEditorialVM.arrayVideoListModel[0].categoryVideoTitle
                self.tblVwEditorial.reloadData()
            })
        }
    }
}
