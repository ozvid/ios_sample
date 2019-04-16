//
//  VideosModel.swift
//  ArabDesigners
//
//  Created by Shiv Charan Panjeta < shiv@ozvid.com > on 3/11/19.
//  Copyright © 2019 OZVID Technologies Pvt. Ltd. < www.ozvid.com >. All rights reserved.
//

import Foundation

class CategoryVideoModel {
    var videoCategoryId = Int()
    var categoryVideoTitle = String()
    
    func getCategoryVideoList(detail: NSDictionary) {
        categoryVideoTitle   = detail["title"] as? String ?? ""
        videoCategoryId       = detail["id"] as? Int ?? 0
    }
}
class VideoListModel {
    
    var videoCategoryId = Int()
    var categoryVideoTitle = String()
    var videoFile       = String()
    var headerTitle     = String()
    var relativeTime    = String()
    var videoThumb      = String()
    var type_id         = Int()
    var descriptionStr  = String()
    
    func getVideoList(detail: NSDictionary) {
        
        categoryVideoTitle  = detail["video_category_title"] as? String ?? ""
        videoCategoryId     = detail["video_category_id"] as? Int ?? 0
        videoFile           = detail["video_file"] as? String ?? ""
        headerTitle         = detail["title"] as? String ?? ""
        relativeTime        = detail["relative_time"] as? String ?? ""
        videoThumb          = detail["video_thumb"] as? String ?? ""
        
        descriptionStr      = detail["description"] as? String ?? ""
        type_id         = detail["type_id"] as? Int ?? Int(detail["type_id"] as? String ?? "0") ?? 0
    }
}
