//
//  CartItemsTVC.swift
//  ArabDesigners
//
//  Created by Shiv Charan Panjeta < shiv@ozvid.com > on 11/02/2019.
//  Copyright © 2019 OZVID Technologies Pvt. Ltd. < www.ozvid.com >. All rights reserved.
//

import UIKit

class CartItemsTVC: UITableViewCell {

    @IBOutlet weak var uiVwColor: UIView!
    
    //MARK:- Outlets
    @IBOutlet weak var lblColor: UILabel!
    @IBOutlet weak var lblQuantity: UILabel!
    @IBOutlet var lblPrice: UILabel!
    @IBOutlet var lblSize: UILabel!
    @IBOutlet var lblProductName: UILabel!
    @IBOutlet var imgvwProduct: UIImageView!
    @IBOutlet weak var btnAddToCart: UIButton!
    @IBOutlet weak var btnRemoveWishListItem: UIButton!
    
    
    @IBOutlet weak var btnPlus: UIButton!
    @IBOutlet weak var btnMinus: UIButton!
}
