//
//  NewMessagesVC.swift
//  SocialHelp
//
//  Created by Misael Rivera on 9/13/19.
//  Copyright © 2019 Misael Rivera. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

protocol NewChatVCDelegate {
    func showChat(user : BasicUserData)
}


class ChatsVC: UIViewController {
    
    var username:String = ""
    let cellId = "cellId"
    var timer:Timer?
    var messages = [MessageNS]()
    var messageDictionary  = [String : MessageNS]()
    private var chatsTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
        checkIfUserIsLoggedIn()
        cleanData()
        observeUserMessages()
    }
    func cleanData() {
        messages.removeAll()
        messageDictionary.removeAll()
        chatsTableView.reloadData()
    }
    
    func setupTableView() {
        
        let barHeight: CGFloat = UIApplication.shared.statusBarFrame.size.height
        let displayWidth: CGFloat = self.view.frame.width
        let displayHeight: CGFloat = self.view.frame.height
        
        chatsTableView = UITableView(frame: CGRect(x: 0, y: barHeight, width: displayWidth, height: displayHeight - barHeight))
        chatsTableView.register(UserCell.self, forCellReuseIdentifier: cellId)
        chatsTableView.dataSource = self
        chatsTableView.delegate = self
        self.view.addSubview(chatsTableView)
    }
    
    func observeUserMessages() {
        guard let uid = Auth.auth().currentUser?.uid else {
            return
        }
        
        let ref = Database.database().reference().child("user-messages").child(uid)
        ref.observe(.childAdded, with: { (snapshot) in
            let messageId = snapshot.key
            let messagesReference = Database.database().reference().child("mesages").child(messageId)
            
            messagesReference.observe(.value, with: { (snapshot) in
                if let dictionary = snapshot.value as? [String: AnyObject] {
                    let message = MessageNS()
                    message.setValuesForKeys(dictionary)
                    
                    if message.chatPartnerId() != "" {
                        let chatPartnerId = message.chatPartnerId()
                        self.messageDictionary[chatPartnerId] = message
                        self.messages = Array(self.messageDictionary.values)
                        self.messages.sort { (message1, message2) -> Bool in
                            return message1.timestamp!.intValue > message2.timestamp!.intValue
                        }
                    }
                    self.timer?.invalidate()
                    self.timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(self.handleReloadTableView), userInfo: nil, repeats: false)
                   
                }
            }, withCancel: nil)
        }, withCancel: nil)
    }
    
    @objc func handleReloadTableView() {
        DispatchQueue.main.async {
            self.chatsTableView.reloadData()
        }
    }
    /*
    func observeMessages() {
        let ref = Database.database().reference().child("mesages")
        ref.observe(.childAdded, with: { (snapshot) in
            if let dictionary = snapshot.value as? [String: AnyObject] {
                let message = MessageNS()
                message.setValuesForKeys(dictionary)
                
                if let toId = message.toId {
                    self.messageDictionary[toId] = message
                    self.messages = Array(self.messageDictionary.values)
                    self.messages.sort { (message1, message2) -> Bool in
                        return message1.timestamp!.intValue > message2.timestamp!.intValue
                    }
                }
                
                DispatchQueue.main.async {
                    self.chatsTableView.reloadData()
                }
                
            }
            
            
        }, withCancel: nil)
    }
    */
    
    func checkIfUserIsLoggedIn() {
        if Auth.auth().currentUser?.uid == nil {
            perform(#selector(handleLogout), with: nil, afterDelay: 0)
        }else {
            let uid = Auth.auth().currentUser?.uid
            DataServices.instance.REF_USERS.child(uid!).observeSingleEvent(of: .value) { (snapshot) in
                if let dictionary = snapshot.value as? [String:AnyObject] {
                    self.username = (dictionary["name"] as? String)!
                    
                    self.navigationController?.title = self.username
                }
            }
        }
    }
    
    @objc private func handleLogout() {
        do {
            try Auth.auth().signOut()
        }catch let logoutError {
            print(logoutError)
        }
        self.view.window?.rootViewController?.dismiss(animated: true, completion: nil)
    }
    
    
    func setView() {
        let containerView = UIView()
        containerView.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
    }
    
    @IBAction func NewChatBtnWasPressed(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let newMessageVC:NewChatVC = storyboard.instantiateViewController(withIdentifier: "ChatVC") as! NewChatVC
        newMessageVC.delegateNewChat = self
        newMessageVC.modalPresentationStyle = .fullScreen
        present(newMessageVC, animated: true, completion: nil)
    }
    
    func showChatLong(user : BasicUserData) {
        let chatloggVC = ChatLongVC(collectionViewLayout: UICollectionViewFlowLayout())
        chatloggVC.user = user
        navigationController?.pushViewController(chatloggVC, animated: true)
    }
}

extension ChatsVC : NewChatVCDelegate {
    func showChat(user : BasicUserData) {
        showChatLong(user: user)
    }
}

extension ChatsVC : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 72
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! UserCell
        let message = messages[indexPath.row]
        cell.message = message
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let message = messages[indexPath.row]
        
        let chatPartnerID = message.chatPartnerId()
        if chatPartnerID == "" {
            return
        }
        let ref = Database.database().reference().child("users").child(chatPartnerID)
        ref.observe(.value, with: { (snapshot) in
            guard let dictionary = snapshot.value as? [String : AnyObject]  else {
                return
            }
            //refactorizar

            let name = dictionary["name"] as? String
            let email = dictionary["email"] as? String
            let urlPhoto = dictionary["photo"] as? String
            
            let user  = BasicUserData(name: name!, email: email!, urlPhoto: urlPhoto!, userID: chatPartnerID)
            self.showChatLong(user: user)
            
        }, withCancel: nil)
    }
}
