//
//  ChatVM.swift
//  ArabDesigners
//
//  Created by Shiv Charan Panjeta < shiv@ozvid.com > on 27/06/18.
//  Copyright © 2019 OZVID Technologies Pvt. Ltd. < www.ozvid.com >. All rights reserved.
//


import Foundation
import UIKit
import SDWebImage

class ChatVM {
    
    //MARK:- Variables
    var arrLiveChat = [ChatModel]()
    var sortedArrChat = [ChatModel]()
    var chatUrl = String()
    var sendToId = Int()
    var currentPage = Int()
    var totalPages = Int()
    let refresh = UIRefreshControl()
    var textMessage = String()
    var timer = Timer()
    var objGetUserDetail = GetUserDetail()
    
    //MARK:- Get Message Methods
    func getChat(_ completion:@escaping() -> Void) {
        WebServiceProxy.shared.getData("\(Apis.KServerUrl)\(Apis.KGetAllMsg)?page=\(currentPage)", showIndicator: false, completion: { (JSON) in
            if JSON["status"] as! Int == 200 {
                if let metaDic = JSON["_meta"] as? NSDictionary {
                    if let totalCountVal = metaDic["pageCount"] as? Int {
                        self.totalPages = totalCountVal
                    }
                }
                if let detailsDict = JSON["user_details"] as? NSDictionary {
                    self.objGetUserDetail.setDetail(detailsDict)
                }
                
                
                if self.currentPage == 0 {
                    self.arrLiveChat.removeAll()
                    self.sortedArrChat.removeAll()
                    if let arrChat = JSON["list"] as? NSArray {
                        if arrChat.count>0 {
                            for i in 0..<arrChat.count{
                                if let dictfrnd = arrChat[i] as? NSDictionary {
                                    let chatListModelObj = ChatModel()
                                    chatListModelObj.chatDet(dictDet: dictfrnd)
                                    self.arrLiveChat.append(chatListModelObj)
                                }
                            }
                        }
                    }
                    self.sortedArrChat = self.arrLiveChat.sorted(by:{$0.createdTime.localizedCompare($1.createdTime) == .orderedAscending})
                }else {
                    var arrPageCountLiveChat = [ChatModel]()
                    self.refresh.endRefreshing()
                    var newPageSortedArr = [ChatModel]()
                    if let arrChat = JSON["list"] as? NSArray {
                        if arrChat.count>0 {
                            for i in 0..<arrChat.count{
                                if let dictfrnd = arrChat[i] as? NSDictionary {
                                    let chatListModelObj = ChatModel()
                                    chatListModelObj.chatDet(dictDet: dictfrnd)
                                    arrPageCountLiveChat.append(chatListModelObj)
                                }
                            }
                            newPageSortedArr = arrPageCountLiveChat.sorted(by:{$0.createdTime.localizedCompare($1.createdTime) == .orderedAscending})
                            
                            for i in 0..<self.sortedArrChat.count {
                                newPageSortedArr.append(self.sortedArrChat[i])
                            }
                            self.sortedArrChat = newPageSortedArr
                        }
                    }
                }
            }  else {
                Proxy.shared.displayStatusCodeAlert(JSON["error"] as? String ?? "Error".localized)
            }
            completion()
        })
    }
    
    
    
    //MARK:- SendMsg
    func sendMessages(_ completion:@escaping() -> Void) {
        let param = [
            "Chatmessage[message]":"\(textMessage)",
            "Chatmessage[to_user_id]" : objGetUserDetail.toUserId
            ]  as [String:AnyObject]
        WebServiceProxy.shared.postData("\(Apis.KServerUrl)\(Apis.KSendMsg)", params: param, showIndicator: false, completion: { (JSON) in
            if JSON["status"] as! Int == 200 {
                if let detailsDict = JSON["data"] as? NSDictionary {
                    let messageGet = ChatModel()
                    messageGet.chatDet(dictDet: detailsDict)
                    self.sortedArrChat.append(messageGet)
                }
                completion()
                
            } else {
                Proxy.shared.displayStatusCodeAlert(JSON["error"] as? String ?? "Error".localized)
            }
            completion()
        })
    }
    
    //MARK:- Read New Msg
    func readNewMessages(_ completion:@escaping(_ isSuccess:Bool, _ jsonResponse:NSDictionary)->Void) {
        WebServiceProxy.shared.getData("\(Apis.KServerUrl)\(Apis.KNewMsg)\(objGetUserDetail.toUserId)&page=\(currentPage)", showIndicator: false, completion: { (JSON) in
            if JSON["status"] as? Int == 200 {
                completion(true,JSON)
            }
        })
    }
}

extension ChatVC : UITableViewDelegate,UITableViewDataSource,UITextViewDelegate  {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return objChatVM.sortedArrChat.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var returnCell      = UITableViewCell()
        let dictChatDet     = objChatVM.sortedArrChat[indexPath.row]
        
        if dictChatDet.fromUserId == userModelObj.id {
            let cell = tableView.dequeueReusableCell(withIdentifier:"ChatTVC", for: indexPath) as! ChatTVC
            cell.lblSenderText.text = dictChatDet.message
            if dictChatDet.createdTime != "" {
                
                cell.lblSenderDate.text = dictChatDet.realTime
            }
            returnCell = cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier:"ChatReciverTVC", for: indexPath) as! ChatReciverTVC
            cell.lblReciverText.text = dictChatDet.message
            if dictChatDet.createdTime != "" {
                
                cell.lblReciverDate.text  = dictChatDet.realTime
            }
            returnCell = cell
        }
        return returnCell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        tblVWChat.estimatedRowHeight = 100
        return UITableView.automaticDimension
    }
    
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if (text as NSString).rangeOfCharacter(from: CharacterSet.newlines).location == NSNotFound {
            return true
        }
        txtVwNewMsg.resignFirstResponder()
        return false
    }
    
}


