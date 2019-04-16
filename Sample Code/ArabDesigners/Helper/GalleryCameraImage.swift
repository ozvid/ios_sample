//
//  GalleryCameraImage.swift
//  ArabDesigners
//
//  Created by Shiv Charan Panjeta < shiv@ozvid.com > on 02/02/2019.
//  Copyright © 2019 OZVID Technologies Pvt. Ltd. < www.ozvid.com >. All rights reserved.
//

import UIKit
import Foundation
import AVFoundation
import CropViewController

protocol PassImageDelegate {
    func passSelectedimage(selectImage: UIImage)
}

class GalleryCameraImage: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate, TOCropViewControllerDelegate {
    
    //MARK:- variable Decleration
    var ImagePicker     = UIImagePickerController()
    var imageTapped     = Int()
    var clickImage      = UIImage()
    var currentController   = UIViewController()
    var profileDelete       = Bool()
    
    //MARK: -
    
    var delegate: PassImageDelegate?

    //MARK: -
    
    func customActionSheet(_ deleteProfile: Bool,controller: UIViewController) {
        profileDelete   = deleteProfile
        currentController = controller
        if AVCaptureDevice.authorizationStatus(for: .video) ==  .authorized {
            self.callCamera()
        } else {
            AVCaptureDevice.requestAccess(for: .video, completionHandler: { (granted: Bool) in
                if granted {
                    self.callCamera()
                } else {
                    self.presentCameraSettings()
                }
            })
        }
    }
    
    func presentCameraSettings() {
        let alertController = UIAlertController(title: AlertValue.cammeraNotAccess, message: AlertValue.openSettingCamera, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: AlertValue.cancel, style: .default))
        alertController.addAction(UIAlertAction(title: AlertValue.setting, style: .cancel) { _ in
            if let url = URL(string: UIApplication.openSettingsURLString) {
                if #available(iOS 10.0, *) {
                    UIApplication.shared.open(url, options: [:], completionHandler:nil)
                } else {
                    UIApplication.shared.openURL(url)
                }
            }
        })
        if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiom.pad ){
            if let popoverController = alertController.popoverPresentationController {
                popoverController.sourceView =  currentController.view
                popoverController.sourceRect = CGRect(x: currentController.view.bounds.midX, y: currentController.view.bounds.midY, width: 0, height: 0)
            }
            currentController.present(alertController, animated: true, completion: nil)
            
        } else{
            currentController.present(alertController, animated: true, completion: nil)
        }
    }
    
    func callCamera() {
        let myActionSheet = UIAlertController()
        let deleteAction = UIAlertAction(title: AlertValue.deletePhoto, style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
           
            self.deleteProfileApi {
                self.delegate?.passSelectedimage(selectImage: UIImage(named: "default_user")!)
                self.currentController.dismiss(animated: true, completion: nil)
            }
        })
        let galleryAction = UIAlertAction(title: AlertValue.gallery, style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            self.openGallary()
        })
        let cmaeraAction = UIAlertAction(title: AlertValue.camera, style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            self.openCamera()
        })
        let cancelAction = UIAlertAction(title: AlertValue.cancel, style: .cancel, handler: {
            (alert: UIAlertAction!) -> Void in
        })
        if profileDelete {
            myActionSheet.addAction(deleteAction)
        }
        myActionSheet.addAction(galleryAction)
        myActionSheet.addAction(cmaeraAction)
        myActionSheet.addAction(cancelAction)
        if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiom.pad) {
            if let popoverController = myActionSheet.popoverPresentationController {
                popoverController.sourceView =  KAppDelegate.window?.rootViewController?.view
                popoverController.sourceRect = CGRect(x: currentController.view.bounds.midX, y:  currentController.view.bounds.midY, width: 0, height: 0)
            }
            currentController.present(myActionSheet, animated: true, completion: nil)
        } else {
            currentController.present(myActionSheet, animated: true, completion: nil)
        }
    }
    
    //MARK:- Open Image Camera
    func openCamera() {
        DispatchQueue.main.async {
            if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerController.SourceType.camera)) {
                self.ImagePicker.sourceType = UIImagePickerController.SourceType.camera
                self.ImagePicker.delegate = self
                self.ImagePicker.allowsEditing = false
                self.currentController.present(self.ImagePicker, animated: true, completion: nil)
            } else {
                let alert = UIAlertController(title: AlertValue.alert, message: AlertValue.cameraNotSupport, preferredStyle: UIAlertController.Style.alert)
                let okAction = UIAlertAction(title: AlertValue.ok, style: UIAlertAction.Style.default, handler: nil)
                alert.addAction(okAction)
                self.currentController.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    //MARK:- Open Image Gallery
    func openGallary() {
        ImagePicker.delegate = self
        ImagePicker.allowsEditing = false
        ImagePicker.sourceType = .photoLibrary
        currentController.present(ImagePicker, animated: true, completion: nil)
    }
    
    @objc func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        DispatchQueue.main.async {
            let objImagePick: UIImage = (info[UIImagePickerController.InfoKey.originalImage.rawValue] as! UIImage)
            self.setSelectedimage(objImagePick)
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    //MARK:- Selectedimage
    func setSelectedimage(_ image: UIImage) {
        clickImage = image
        let cropViewController = TOCropViewController(croppingStyle: .default, image: clickImage)
        cropViewController.delegate = self
        currentController.present(cropViewController, animated: true, completion: nil)
    }
    
    //MARK:-CropViewController Delegate
    internal func cropViewController(_ cropViewController: TOCropViewController, didCropTo image: UIImage, with cropRect: CGRect, angle: Int) {
        
        delegate?.passSelectedimage(selectImage: image)
        cropViewController.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        currentController.dismiss(animated: true, completion: nil)
    }
    
    //MARK:- DeleteProfile Api Method
    func deleteProfileApi(_ completion:@escaping() -> Void) {
//        WebServiceProxy.shared.postData("\(Apis.KServerUrl)\(Apis.KDeletProfileImage)\(userModelObj.id)&access-token=\(Proxy.shared.accessTokenNil())", params: nil, showIndicator: true, completion: { (JSON) in
//            if JSON["status"] as! Int == 200 {
//                
//                completion()
//            }
//            else {
//                Proxy.shared.displayStatusCodeAlert(JSON["error"] as? String ?? "Error")
//            }
//        })
        completion()
    }
}
