//
//  DrawerCell.swift
//  Yumiz
//
//  Created by Shiv Charan Panjeta < shiv@ozvid.com > on 28/06/18.
//  Copyright © 2019 OZVID Technologies Pvt. Ltd. < www.ozvid.com >. All rights reserved.
//

import UIKit

class DrawerCell: UITableViewCell {
    //MARK: -
    
    @IBOutlet weak var itemNameLB: UILabel!
    
    //MARK: -
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
