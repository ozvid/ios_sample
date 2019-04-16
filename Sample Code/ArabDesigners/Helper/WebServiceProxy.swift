//
//  WebServiceProxy.swift
//  ArabDesigners
//
//  Created by Shiv Charan Panjeta < shiv@ozvid.com > on 02/02/2019.
//  Copyright © 2019 OZVID Technologies Pvt. Ltd. < www.ozvid.com >. All rights reserved.
//


import UIKit
import Foundation
import Alamofire

class WebServiceProxy {
    static var shared: WebServiceProxy {
        return WebServiceProxy()
    }
    fileprivate init(){}
    
    
    //MARK:- API Interaction
    func postData(_ urlStr: String, params: Dictionary<String, AnyObject>? = nil, showIndicator: Bool, completion: @escaping (_ response: NSDictionary) -> Void) {
        if NetworkReachabilityManager()!.isReachable {
            if showIndicator {
                Proxy.shared.showActivityIndicator()
            }
            
            if AppInfo.showLogs {
                debugPrint("URL: ",urlStr)
                debugPrint("Params: ", params)
            }
            
            request(urlStr, method: .post, parameters: params, encoding: URLEncoding.httpBody, headers:["Authorization": "Bearer \(Proxy.shared.accessTokenNil())","User-Agent":"\(AppInfo.UserAgent)","language":"\(userModelObj.appLanguage)"])
                .responseJSON { response in
                    Proxy.shared.hideActivityIndicator()
                    if response.data != nil && response.result.error == nil {
                        if response.response?.statusCode == 200 {
                            if let JSON = response.result.value as? NSDictionary {
                                if AppInfo.showLogs {
                                    debugPrint("JSON", JSON)
                                }
                                completion(JSON)
                                
                            } else {
                                Proxy.shared.hideActivityIndicator()
                                Proxy.shared.displayStatusCodeAlert("No response found")
                            }
                        }else if response.response?.statusCode == 400 {
                            if let JSON = response.result.value as? NSDictionary {
                                if AppInfo.showLogs {
                                    debugPrint("JSON", JSON)
                                }
                                completion(JSON)
                                
                            } else {
                                Proxy.shared.hideActivityIndicator()
                                Proxy.shared.displayStatusCodeAlert("No response found")
                            }
                        } else {
                            if response.data != nil{
                                debugPrint(NSString(data: response.data!, encoding: String.Encoding.utf8.rawValue)!)
                            }
                            self.statusHandler(response.response, data: response.data, error: response.result.error as NSError?)
                        }
                    } else {
                        if response.data != nil{
                            debugPrint(NSString(data: response.data!, encoding: String.Encoding.utf8.rawValue)!)
                            Proxy.shared.displayStatusCodeAlert("No response found")
                        }
                        self.statusHandler(response.response, data: response.data, error: response.result.error as NSError?)
                    }
            }
        } else {
            Proxy.shared.hideActivityIndicator()
            Proxy.shared.openSettingApp()
        }
    }
    
    func getData(_ urlStr: String, showIndicator: Bool, completion: @escaping (_ responseDict: NSDictionary) -> Void) {
        
        if NetworkReachabilityManager()!.isReachable {
            if showIndicator {
                Proxy.shared.showActivityIndicator()
            }
            if AppInfo.showLogs {
                debugPrint("URL: ",urlStr)
                debugPrint(["Authorization": "Bearer \(Proxy.shared.accessTokenNil())","User-Agent":"\(AppInfo.UserAgent)","language":"\(userModelObj.appLanguage)"])
            }
            request(urlStr, method: .get, parameters: nil, encoding: JSONEncoding.default, headers:["Authorization": "Bearer \(Proxy.shared.accessTokenNil())","User-Agent":"\(AppInfo.UserAgent)","language":"\(userModelObj.appLanguage)"])
                .responseJSON { response in
                    Proxy.shared.hideActivityIndicator()
                    if response.data != nil && response.result.error == nil {
                        if response.response?.statusCode == 200 {
                            if let JSON = response.result.value as? NSDictionary {
                                if AppInfo.showLogs {
                                    debugPrint("JSON", JSON)
                                }
                                completion(JSON)
                            } else {
                                
                                Proxy.shared.displayStatusCodeAlert("Error: Unable to get response from server")
                            }
                        } else {
                            if response.data != nil{
                                debugPrint(NSString(data: response.data!, encoding: String.Encoding.utf8.rawValue)!)
                            }
                            self.statusHandler(response.response, data: response.data, error: response.result.error as NSError?)
                        }
                    } else {
                        if response.data != nil {
                            debugPrint(NSString(data: response.data!, encoding: String.Encoding.utf8.rawValue)!)
                        }
                        self.statusHandler(response.response, data: response.data, error: response.result.error as NSError?)
                    }
            }
        } else {
            Proxy.shared.hideActivityIndicator()
            Proxy.shared.openSettingApp()
        }
    }
    
    func uploadImage(_ parameters:[String:AnyObject], parametersImage:[String:UIImage], addImageUrl:String, showIndicator: Bool, completion:@escaping (_ completed: NSDictionary) -> Void) {
        
        if NetworkReachabilityManager()!.isReachable {
            
            if showIndicator {
                Proxy.shared.showActivityIndicator()
            }
            if AppInfo.showLogs {
                debugPrint("URL: ",addImageUrl)
            }
            Alamofire.upload(
                multipartFormData: { multipartFormData in
                    for (key, val) in parameters {
                        if key == "File[video_file]" {
                            if val != nil {
                                multipartFormData.append(val as! URL, withName: key, fileName: "video.mp4", mimeType: "video/mp4")
                            }
                        } else {
                            if val != nil {
                                multipartFormData.append(val.data(using:
                                    String.Encoding.utf8.rawValue)!, withName: key)
                            }
                        }
                    }
                    for (key, val) in parametersImage {
                        let timeStamp = Date().timeIntervalSince1970 * 1000
                        let fileName = "image\(timeStamp).png"
                        guard let imageData = val.jpegData(compressionQuality: 0.8)
                            else {
                                return
                        }
                        multipartFormData.append(imageData, withName: key, fileName: fileName , mimeType: "image/png")
                    }
            },
                to: addImageUrl,
                method:.post,
                headers:["Authorization": "Bearer \(Proxy.shared.accessTokenNil())","User-Agent":"\(AppInfo.UserAgent)","language":"\(userModelObj.appLanguage)"],
                encodingCompletion: { encodingResult in
                    switch encodingResult {
                    case .success(let upload, _, _):
                        upload.validate()
                        upload.responseJSON { response in
                            if AppInfo.showLogs {
                                debugPrint("URL: ",response )
                            }
                            Proxy.shared.hideActivityIndicator()
                            guard response.result.isSuccess else {
                                Proxy.shared.displayStatusCodeAlert(NSString(data: response.data!, encoding: String.Encoding.utf8.rawValue) as! String)
                                return
                            }
                            if let responseJSON = response.result.value as? NSDictionary{
                                completion(responseJSON)
                            }
                        }
                        
                    case .failure(let errorcoding):
                        debugPrint(errorcoding)
                        break
                    }
            }
            )
        } else {
            Proxy.shared.hideActivityIndicator()
            Proxy.shared.openSettingApp()
        }
    }
    
    // MARK:- Error Handling
    func statusHandler(_ response:HTTPURLResponse? , data:Data?, error:NSError?) {
        if let code = response?.statusCode {
            switch code {
            case 400:
                Proxy.shared.displayStatusCodeAlert(AlertValue.urlError)
            case 401:
                
                UserDefaults.standard.set("", forKey: "access-token")
                UserDefaults.standard.set("", forKey: "userId")
                UserDefaults.standard.set("", forKey: "roleId")
                UserDefaults.standard.synchronize()
                Proxy.shared.rootToVC(identifier: "SigninVC")
                //Proxy.shared.displayStatusCodeAlert("You must login first")
            case 403:
                UserDefaults.standard.set("", forKey: "access-token")
                UserDefaults.standard.set("", forKey: "roleId")
                UserDefaults.standard.set("", forKey: "userId")
                UserDefaults.standard.synchronize()
                Proxy.shared.rootToVC(identifier: "SigninVC")
                Proxy.shared.displayStatusCodeAlert(AlertValue.sessionError)
            case 404:
                Proxy.shared.displayStatusCodeAlert(AlertValue.urlNotExist)
            case 500:
                let myHTMLString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)!
                Proxy.shared.displayStatusCodeAlert(myHTMLString as String)
            case 408:
                Proxy.shared.displayStatusCodeAlert(AlertValue.serverError)
            default:
                let myHTMLString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)!
                Proxy.shared.displayStatusCodeAlert(myHTMLString as String)
            }
        } else {
            let myHTMLString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)!
            Proxy.shared.displayStatusCodeAlert(myHTMLString as String)
        }
        
        if let errorCode = error?.code {
            switch errorCode {
            default:
                break
                Proxy.shared.displayStatusCodeAlert(AlertValue.serverError)
            }
        }
    }
}
