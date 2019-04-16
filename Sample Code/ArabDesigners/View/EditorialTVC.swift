//
//  EditorialTVC.swift
//  ArabDesigners
//
//  Created by Shiv Charan Panjeta < shiv@ozvid.com > on 2/22/19.
//  Copyright © 2019 OZVID Technologies Pvt. Ltd. < www.ozvid.com >. All rights reserved.
//

import UIKit

class EditorialTVC: UITableViewCell {

    @IBOutlet weak var imgVwVideos: UIImageView!
    @IBOutlet weak var btnVideosStart: CornerRoundedButton!
    @IBOutlet weak var lblVideoTitle: UILabel!
    @IBOutlet weak var lblDescription: UILabel!
    
    @IBOutlet weak var imageHeightConst: NSLayoutConstraint!
    //MARK: -
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    @IBOutlet weak var lblTime: UILabel!
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}


