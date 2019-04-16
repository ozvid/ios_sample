//
//  FilterVC.swift
//  Bella
//
//  Created by Shiv Charan Panjeta < shiv@ozvid.com > on 19/11/18.
//  Copyright © 2019 OZVID Technologies Pvt. Ltd. < www.ozvid.com >. All rights reserved.
//


import UIKit
import TTRangeSlider

class FilterVC: UIViewController,TTRangeSliderDelegate,UITextFieldDelegate{
    
    //MARK:- Outlets
    
    @IBOutlet var rangeSliderPrice: TTRangeSlider!
    //MARK:- Variables
    var minPriceValue = Float()
    var maxPriceValue = Float()
    let filterModelObj = FilterVM()
    
    //MARK:-
    override func viewDidLoad() {
        super.viewDidLoad()
        let formatter = NumberFormatter()
        formatter.numberStyle = .none
        rangeSliderPrice.delegate = self
        rangeSliderPrice.labelPosition = .below
        rangeSliderPrice.numberFormatterOverride = formatter
        rangeSliderPrice.handleDiameter = 20
        filterModelObj.startPrice = Int(rangeSliderPrice.minValue)
        filterModelObj.endPrice   = Int(rangeSliderPrice.maxValue)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = true
    }
    
    
    //MARK:- RangeSlider Delegate
    func rangeSlider(_ sender: TTRangeSlider!, didChangeSelectedMinimumValue selectedMinimum: Float, andMaximumValue selectedMaximum: Float) {
        filterModelObj.startPrice = Int(selectedMinimum)
        filterModelObj.endPrice   = Int(selectedMaximum)
    }
    
    //MARK:- Button Action
    @IBAction func actionClose(_ sender: Any) {
        Proxy.shared.popToBackVC(isAnimate: true, currentViewController: self)
    }
    
    @IBAction func actioNApply(_ sender: Any) {
        let dict = ["startPrice":self.filterModelObj.startPrice,"endPrice":self.filterModelObj.endPrice,"color":self.filterModelObj.colorId,"category":self.filterModelObj.categoryId,"from":"filter"] as [String : Any]
        NotificationCenter.default.post(name: NSNotification.Name("ApplyFilter"), object: nil, userInfo: dict)
        Proxy.shared.popToBackVC(isAnimate: true, currentViewController: self)
        //filterObj.startPrice = self.filterModelObj.startPrice
        //filterObj.endPrice   = self.filterModelObj.endPrice
        //filterObj.isFilterApplied = true
    }
    
    @IBAction func actionRemove(_ sender: UIButton) {
        // NotificationCenter.default.post(name: NSNotification.Name("RemoveFilter"), object: nil, userInfo: nil)
        Proxy.shared.popToBackVC(isAnimate: true, currentViewController: self)
        filterObj.startPrice = 1
        filterObj.endPrice   = 900000
        filterObj.isFilterApplied = false
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
