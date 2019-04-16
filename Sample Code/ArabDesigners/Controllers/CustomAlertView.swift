//
//  CustomAlertView.swift
//  CustomAlertView
//
//  Created by Shiv Charan Panjeta < shiv@ozvid.com > on 16/3/17.
//  Copyright © 2019 OZVID Technologies Pvt. Ltd. < www.ozvid.com >. All rights reserved.
//

import UIKit

class CustomAlertView: UIViewController {
    
    @IBOutlet weak var alertView: UIView!
    
    @IBOutlet weak var titleLB: UILabel!
    @IBOutlet weak var descriptionLB: UILabel!
    
    @IBOutlet weak var closeBtn: UIButton!
    
    //MARK: -
    var delegate: CustomAlertViewDelegate?
    
    var titleVal        = String()
    var message         = String()

    //MARK: - ViewLifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        descriptionLB.text              = message
        descriptionLB.textAlignment     = .center
        
        titleLB.text        = titleVal
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupView()
        animateView()
    }
    
    //MARK: - ViewSetup
    
    func setupView() {
        alertView.layer.cornerRadius = 4
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.4)
    }
    
    func animateView() {
        
        alertView.alpha = 0;
        self.alertView.frame.origin.y = self.alertView.frame.origin.y + 50
        UIView.animate(withDuration: 0.4, animations: { () -> Void in
            self.alertView.alpha = 1.0;
            self.alertView.frame.origin.y = self.alertView.frame.origin.y - 50
        })
    }
    
    @IBAction func onTapCancelButton(_ sender: Any) {
        
        delegate?.cancelButtonTapped()
        self.dismiss(animated: true, completion: nil)
    }
}
