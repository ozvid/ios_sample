//
//  EditorialVM.swift
//  ArabDesigners
//
//  Created by Shiv Charan Panjeta < shiv@ozvid.com > on  3/11/19.
//  Copyright © 2019 OZVID Technologies Pvt. Ltd. < www.ozvid.com >. All rights reserved.
//

import Foundation
import UIKit
import Kingfisher
import Lightbox

class  EditorialVM {
    
    var arrayCategoryVideoModel = [CategoryVideoModel]()
    var arrayVideoListModel     = [VideoListModel]()
    var pageCount       = 0
    var currentPageNo   = 0
    
    var pageCountList       = 0
    var currentPageNoList   = 0
    
    var selectIndex     = 0
    
    //MARK: - Handle Designer Products
    func getCategoryVideoList(_ completion:@escaping() -> Void) {
        WebServiceProxy.shared.getData("\(Apis.KServerUrl)\(Apis.KVideosCategory)\(currentPageNo)", showIndicator: true, completion: { (JSON) in
            if JSON["status"] as! Int == 200 {
                
                if self.currentPageNo == 0 {
                    self.arrayCategoryVideoModel = []
                }
                if let metaDict = JSON["_meta"] as? NSDictionary {
                    self.pageCount = metaDict["pageCount"] as? Int ?? 0
                }
                
                if let listArray =  JSON["list"] as? NSArray {
                    for i in 0..<listArray.count {
                        if let dict = listArray[i] as? NSDictionary {
                            let objCategoryVideoModel = CategoryVideoModel()
                            objCategoryVideoModel.getCategoryVideoList(detail: dict)
                            self.arrayCategoryVideoModel.append(objCategoryVideoModel)
                        }
                    }
                }
                completion()
            } else {
                Proxy.shared.displayStatusCodeAlert(JSON["error"] as? String ?? "Error".localized)
            }
        })
    }
    // MARK: - Handle Designer Products
    func getVideoFilesList(categoryId: Int,_ completion:@escaping() -> Void) {
       
        let url = "\(Apis.KServerUrl)\(Apis.KVideosFiles)\(categoryId)&page=\(currentPageNoList)"
        WebServiceProxy.shared.getData(url, showIndicator: true, completion: { (JSON) in
            
            if JSON["status"] as! Int == 200 {
                
                if self.currentPageNoList == 0 {
                    self.arrayVideoListModel = []
                }
                if let metaDict = JSON["_meta"] as? NSDictionary {
                    self.pageCountList = metaDict["pageCount"] as? Int ?? 0
                }
                if let listArray =  JSON["list"] as? NSArray {
                    for i in 0..<listArray.count {
                        
                        if let dict = listArray[i] as? NSDictionary {
                            let objVideoListModel   = VideoListModel()
                            objVideoListModel.getVideoList(detail: dict)
                            self.arrayVideoListModel.append(objVideoListModel)
                        }
                    }
                }
                completion()
            } else {
                Proxy.shared.displayStatusCodeAlert(JSON["error"] as? String ?? "Error".localized)
            }
        })
    }
}
extension EditorialVC : UICollectionViewDelegate,UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return objEditorialVM.arrayCategoryVideoModel.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
       
        let cell = collVwEditorial.dequeueReusableCell(withReuseIdentifier: "EditorialCVC", for: indexPath) as! EditorialCVC
        
        let dictDetialVideo = objEditorialVM.arrayCategoryVideoModel[indexPath.row]
        
        cell.lblTitle.text = dictDetialVideo.categoryVideoTitle
        if objEditorialVM.selectIndex == indexPath.row {
            cell.lblTitle.textColor = UIColor.orange
        } else {
            cell.lblTitle.textColor = UIColor.white
        }
        return cell
        
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let dictDetialVideo = objEditorialVM.arrayCategoryVideoModel[indexPath.row]
        objEditorialVM.getVideoFilesList(categoryId: dictDetialVideo.videoCategoryId) {
            
            self.objEditorialVM.selectIndex = indexPath.row

            if self.objEditorialVM.arrayCategoryVideoModel.count == 0  {
                self.lblHeaderTitle.text    = ""
                self.lblVideoTitle.text     = ""
            }
            else {
                self.lblHeaderTitle.text    = self.objEditorialVM.arrayCategoryVideoModel[self.objEditorialVM.selectIndex].categoryVideoTitle
                self.lblVideoTitle.text     = self.objEditorialVM.arrayCategoryVideoModel[self.objEditorialVM.selectIndex].categoryVideoTitle
            }
            self.tblVwEditorial.reloadData()
            self.collVwEditorial.reloadData()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        if indexPath.row ==  self.objEditorialVM.arrayCategoryVideoModel.count - 1 {
            
            if  objEditorialVM.currentPageNo + 1  < objEditorialVM.pageCount {
                
                objEditorialVM.currentPageNo =  objEditorialVM.currentPageNo + 1
                objEditorialVM.getCategoryVideoList {
                    self.collVwEditorial.reloadData()
                }
            }
        }
    }
    
}
extension EditorialVC : UITableViewDataSource,UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return objEditorialVM.arrayVideoListModel.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        let cell                = tblVwEditorial.dequeueReusableCell(withIdentifier: "EditorialTVC", for: indexPath) as! EditorialTVC
        cell.selectionStyle     = .none
        
        let dictDetialVideo     = objEditorialVM.arrayVideoListModel[indexPath.row]
       
        cell.imgVwVideos.kf.setImage(with: URL(string: dictDetialVideo.videoThumb) ?? URL(string: dictDetialVideo.videoFile)!, placeholder: UIImage(named: "DUMMY_LAND_IMG"))
        cell.lblVideoTitle.text     = dictDetialVideo.categoryVideoTitle
        cell.lblTime.text           = dictDetialVideo.relativeTime
        cell.lblDescription.text    = dictDetialVideo.descriptionStr
        
        if dictDetialVideo.type_id  == EditorialType.TYPE_IMAGE.rawValue {
            cell.btnVideosStart.isHidden    = true
            cell.imageHeightConst.constant  = 200
        }
        else if dictDetialVideo.type_id  == EditorialType.TYPE_TEXT.rawValue {
            cell.btnVideosStart.isHidden    = true
            cell.imageHeightConst.constant  = 0
        }
        else {
            cell.imageHeightConst.constant  = 200
            
            cell.btnVideosStart.isHidden    = false
            cell.btnVideosStart.tag         = indexPath.row
            cell.btnVideosStart.addTarget(self, action: #selector(btnVideoStart(_:)), for: .touchUpInside)
        }
        return  cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let dictDetialVideo     = objEditorialVM.arrayVideoListModel[indexPath.row]
        
        if dictDetialVideo.type_id  == EditorialType.TYPE_TEXT.rawValue {
            tableView.estimatedRowHeight    = 50
            return UITableView.automaticDimension
        }
        else {
            tableView.estimatedRowHeight    = 50
            return UITableView.automaticDimension
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let dictDetialVideo     = objEditorialVM.arrayVideoListModel[indexPath.row]
        if dictDetialVideo.type_id  == EditorialType.TYPE_IMAGE.rawValue {
            
           // if dictDetialVideo.videoThumb != "" {
                let images = [
                    LightboxImage(imageURL: URL(string: dictDetialVideo.videoThumb) ?? URL(string: dictDetialVideo.videoFile)!)
                ]
                let controller                  = LightboxController(images: images)
                controller.dynamicBackground    = true
                present(controller, animated: true, completion: nil)
           // }
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        if indexPath.row ==  objEditorialVM.arrayVideoListModel.count - 1 {
            
            if  objEditorialVM.currentPageNoList + 1  < objEditorialVM.pageCountList {
                
                objEditorialVM.currentPageNoList =  objEditorialVM.currentPageNoList + 1
                objEditorialVM.getVideoFilesList(categoryId: objEditorialVM.arrayCategoryVideoModel[objEditorialVM.selectIndex].videoCategoryId, {
                    self.tblVwEditorial.reloadData()
                })
            }
        }
    }
    
    //Mark:- BtnVideoStart
    @objc func btnVideoStart(_ sender:UIButton) {
        
        let detailDict =  objEditorialVM.arrayVideoListModel[sender.tag]
        Proxy.shared.playVideo(detailDict.videoFile)
    }
}

