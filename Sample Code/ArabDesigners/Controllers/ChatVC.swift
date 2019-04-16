//
//  ChatVC.swift
//  ArabDesigners
//
//  Created by Shiv Charan Panjeta < shiv@ozvid.com > on 27/06/18.
//  Copyright © 2019 OZVID Technologies Pvt. Ltd. < www.ozvid.com >. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift

class ChatVC: UIViewController {
    
    
    //MARK:- IBOutlets
    @IBOutlet weak var btnSendMsg: CornerRoundedButton!
    @IBOutlet weak var constHeightBottom: NSLayoutConstraint!
    @IBOutlet weak var tblVWChat: UITableView!
    @IBOutlet weak var txtVwNewMsg: UITextView!
    @IBOutlet weak var viewBottom: UIView!
    
    var objChatVM  = ChatVM()

    //MARK: - 
    override func viewDidLoad() {
        super.viewDidLoad()
       
        objChatVM.currentPage = 0
        objChatVM.refresh.addTarget(self, action: #selector(self.refreshOldChat), for: UIControl.Event.valueChanged)
        
        tblVWChat.addSubview(objChatVM.refresh)
        
        objChatVM.getChat{
        
            self.tblVWChat.reloadData()
            self.scrollToBottom()
            self.objChatVM.timer = Timer.scheduledTimer(timeInterval: 5.0, target: self, selector: #selector(self.getSingleMsg), userInfo: nil, repeats: true)
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.managechatDetails(_:)), name: NSNotification.Name(rawValue: "updateOrderDetails"), object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.navigationController?.isNavigationBarHidden    = true
        self.tabBarController?.tabBar.isHidden              = true
        
        IQKeyboardManager.shared.enable             = false
        IQKeyboardManager.shared.enableAutoToolbar  = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
       
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
        
            self.objChatVM.timer.invalidate()
            
            IQKeyboardManager.shared.enable = true
            IQKeyboardManager.shared.enableAutoToolbar = true
        }
    }

    //MARK: - ManageNotification
    @objc func managechatDetails(_ notification: NSNotification) {
        
    }
    
    //MARK: - UIButtonActions
    @IBAction func btnActionBack(_ sender: Any) {
        self.tabBarController?.tabBar.isHidden = false
        Proxy.shared.popToBackVC(isAnimate: true, currentViewController: self)
    }
    
    @IBAction func btnActionSend(_ sender: Any) {
       
        self.txtVwNewMsg.resignFirstResponder()
        if txtVwNewMsg.text == "" {
            Proxy.shared.displayStatusCodeAlert("Please Enter some message".localized)
        }
        else {
           
            objChatVM.textMessage = txtVwNewMsg.text!
            self.btnSendMsg.isUserInteractionEnabled = false
           
            objChatVM.sendMessages {
                self.btnSendMsg.isUserInteractionEnabled = true
                self.txtVwNewMsg.text = ""
                self.tblVWChat.reloadData()
                self.scrollToBottom()
            }
        }
    }
    
    
    
    @objc func getSingleMsg()  {
        objChatVM.readNewMessages{ (isSuccess,JSON) in
            if isSuccess {
                self.btnSendMsg.isUserInteractionEnabled = true
                var arrNewLiveChat = [ChatModel]()
                self.objChatVM.totalPages = 0
                if let arrChat = JSON["details"] as? NSArray {
                    if arrChat.count>0 {
                        for i in 0..<arrChat.count{
                            if let dictfrnd = arrChat[i] as? NSDictionary {
                                let chatListModelObj = ChatModel()
                                chatListModelObj.chatDet(dictDet: dictfrnd)
                                arrNewLiveChat.append(chatListModelObj)
                            }
                        }
                        let geSortedNewMsgs = arrNewLiveChat.sorted(by:{$0.createdTime.localizedCompare($1.createdTime) == .orderedAscending})
                        for i in 0..<geSortedNewMsgs.count{
                            self.objChatVM.sortedArrChat.append(geSortedNewMsgs[i])
                        }
                        self.tblVWChat.reloadData()
                        self.scrollToBottom()
                    }
                }
            }
        }
    }
    
    //MARK:- RefershOldChat
    @objc func refreshOldChat() {
        if objChatVM.totalPages > objChatVM.currentPage {
            objChatVM.refresh.beginRefreshing()
            objChatVM.currentPage += 1
            objChatVM.getChat {
                self.tblVWChat.reloadData()
            }
        }
    }
    
    // MARK:- Scroll to bottom
    @objc func scrollToBottom() {
        let oldCount: Int = objChatVM.arrLiveChat.count
        if oldCount != 0 {
            let lastRowNumber: Int = tblVWChat.numberOfRows(inSection: 0) - 1
            if lastRowNumber > 0 {
                let ip: IndexPath = IndexPath(row: lastRowNumber, section: 0)
                tblVWChat.scrollToRow(at: ip, at: .bottom, animated: false)
            }
        }
    }
    
    // MARK:- HandleKeyboard
    
    @objc func keyboardWillShow(notification: Notification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            print("notification: Keyboard will show")
            
            constHeightBottom.constant = keyboardSize.height
        }
    }
    
    @objc func keyboardWillHide(_ notification: Notification) {
        constHeightBottom.constant = 0
    }
    
    //MARK: -
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}


