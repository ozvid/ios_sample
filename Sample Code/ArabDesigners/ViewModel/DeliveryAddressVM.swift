//
//  DeliveryAddressVM.swift
//  ArabDesigners
//
//  Created by Shiv Charan Panjeta < shiv@ozvid.com > on 13/03/19.
//  Copyright © 2019 OZVID Technologies Pvt. Ltd. < www.ozvid.com >. All rights reserved.
//
//

import UIKit

class DeliveryAddressVM: NSObject {
    
    var pickerView  = UIPickerView()
    
    //MARK:- AddToBagProduct Api
    func checkOutApi(_ completion:@escaping() -> Void) {
        
        let discount            = Float(objAddressModel.promoDiscount)!
        let promoCodeDiscount   = (Float(objAddressModel.totalPrice)! * discount) / 100
        
        /**
        Amount After Discount is used to Pay the Discounted Amount Using Paytabs SDK
        */
        
        let param = [
            "Order[final_amount]"       : objAddressModel.amountToPay,
            "Order[user_name]"          : objAddressModel.name,
            "Order[user_address]"       : objAddressModel.address,
            "Order[user_country]"       : objAddressModel.userCountry,
            "Order[user_contact]"       : objAddressModel.contactNo,
            "Order[user_email]"         : objAddressModel.email,
            "Order[user_city]"          : objAddressModel.city,
            "Order[user_zipcode]"       : objAddressModel.zipCode,
            "Order[latitude]"           : objAddressModel.user_latitude,
            "Order[longitude]"          : objAddressModel.user_longitude,
            "Order[future_saved]"       : objAddressModel.futureSaved,
            "Order[user_state]"         : objAddressModel.state,
            "Order[delivery_type]"      : objAddressModel.deliveryType,
            "Order[shipping_cost]"      : objAddressModel.shippingCost,
            "Order[promocode]"          : objAddressModel.appliedPromoCode,
            "Order[discount]"           : "\(promoCodeDiscount)"
            ]  as [String: String]
        
        WebServiceProxy.shared.postData("\(Apis.KServerUrl)\(Apis.KCheckout)", params: param as Dictionary<String, AnyObject>, showIndicator: true, completion: { (JSON) in
            
            if JSON["status"] as! Int == 200 {
                
                if let detialDict = JSON["detail"] as? NSDictionary {
                    objAllOrderListModel = AllOrderListModel()
                    objAllOrderListModel.getAllOrderList(detail: detialDict)
                }
                if let msg =  JSON["message"] as? String {
                    Proxy.shared.displayStatusCodeAlert(msg)
                }
                completion()
            }
            else {
                Proxy.shared.displayStatusCodeAlert(JSON["error"] as? String ?? "Error".localized)
            }
        })
    }
    
    func getUserAddressDetails(_ completion:@escaping() -> Void) {
        
        let urlStr  = "\(Apis.KServerUrl)\(Apis.kGetUserAddress)"
        WebServiceProxy.shared.getData(urlStr, showIndicator: true) { (JSON) in
            
            if JSON["status"] as! Int == 200 {
                
                if let detailsDict  = JSON["details"] as? NSDictionary {
                    objAddressModel.setUpUserAddress(details: detailsDict)
                }
                completion()
            }
        }
    }
}
extension DeliveryAddressVC : UITextFieldDelegate {
    
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if textField    == txtfldAddress {
            if string.isEmpty {
                return true
            }
            let alphaNumericRegEx = "[a-zA-Z0-9 ]"
            let predicate = NSPredicate(format:"SELF MATCHES %@", alphaNumericRegEx)
            return predicate.evaluate(with: string)
        }
        return true
    }
    
}
extension DeliveryAddressVC: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
        if textField    == txtCountry {
            
            textField.inputView = objDeliveryAddressVM.pickerView
            
            objDeliveryAddressVM.pickerView.dataSource = self
            objDeliveryAddressVM.pickerView.delegate = self
            
        }
        return true
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return countryList.count
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return countryList[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        txtCountry.text = (IsoCountryCodes.searchByName(countryList[row]))?.alpha3 ?? ""
        objAddressModel.userCountry     = (IsoCountryCodes.searchByName(countryList[row]))?.alpha3 ?? ""
    }
}
