//
//  ChatLongVC.swift
//  SocialHelp
//
//  Created by Misael Rivera on 9/13/19.
//  Copyright © 2019 Misael Rivera. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class ChatLongVC: UICollectionViewController, UITextFieldDelegate {
    
    let inputTextfield : UITextField = {
        let textFiled = UITextField()
        textFiled.placeholder = "Introduzca mensaje..."
        textFiled.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        textFiled.translatesAutoresizingMaskIntoConstraints = false
        return textFiled
    }()
    
    var user:BasicUserData? {
        didSet {
            navigationItem.title = user?.name
            observeMessages()
        }
    }
    
    func observeMessages() {
        guard let uid = Auth.auth().currentUser?.uid else {
            return
        }
        
        let userReferences = Database.database().reference().child("user-messages").child(uid)
        userReferences.observe(.childAdded, with: { (snapshot) in
            
            let messageId = snapshot.key
            let messageRef = Database.database().reference().child("mesages").child(messageId)
            
            messageRef.observe(.value, with: { (snapshot) in
                
                guard let dictionary = snapshot.value as? [String : AnyObject] else {
                    return
                }
                let message = MessageNS()
                message.setValuesForKeys(dictionary)
                
                if message.chatPartnerId() == self.user?.userID {
                    self.messages.append(message)
                    
                    DispatchQueue.main.async {
                        self.collectionView.reloadData()
                    }
                }
                
            }, withCancel: nil)
            
        }, withCancel: nil)
    }
    
    var messages = [MessageNS]()
    
    private var chatCollectionView: UICollectionView!
    let cellId = "cellId"
    private let cellReuseIdentifier = "collectionCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        inputTextfield.delegate = self
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.contentInset = UIEdgeInsets(top: 8, left: 0, bottom: 58, right: 0)
        collectionView.scrollIndicatorInsets = UIEdgeInsets(top: 0, left: 0, bottom: 58, right: 0)
        collectionView.alwaysBounceVertical = true
        collectionView.register(ChatMessageCell.self, forCellWithReuseIdentifier: cellId)
        if self.traitCollection.userInterfaceStyle == .dark {
            collectionView.backgroundColor = UIColor.black
        }else{
            collectionView.backgroundColor = UIColor.white
        }
        setupInputConponets()
        observeMessages()
    }
    
    func setupInputConponets() {
        let containerView = UIView()
        if self.traitCollection.userInterfaceStyle == .dark {
            containerView.backgroundColor = UIColor.black
        }else{
            containerView.backgroundColor = UIColor.white
        }
        containerView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(containerView)
        
        //IOS 9 constraint anchors
        //x, y, w, h
        containerView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        if #available(iOS 11.0, *) {
            containerView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        } else {
            // Fallback on earlier versions
        }
        containerView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        containerView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        
        let sendButton = UIButton(type: .system)
        sendButton.setTitle("Enviar", for: .normal)
        sendButton.translatesAutoresizingMaskIntoConstraints = false
        sendButton.addTarget(self, action: #selector(handleSend), for: .touchUpInside)
        containerView.addSubview(sendButton)
        
        //IOS9 constraint anchors
        //x, y, w, h
        sendButton.rightAnchor.constraint(equalTo: containerView.rightAnchor).isActive = true
        sendButton.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
        sendButton.widthAnchor.constraint(equalToConstant: 80).isActive = true
        sendButton.heightAnchor.constraint(equalTo: containerView.heightAnchor).isActive = true
        
        
        containerView.addSubview(inputTextfield)
        //x,y, w, h
        inputTextfield.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 8).isActive = true
        inputTextfield.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
        inputTextfield.rightAnchor.constraint(equalTo: sendButton.leftAnchor).isActive = true
        inputTextfield.heightAnchor.constraint(equalTo: containerView.heightAnchor).isActive = true
        
        let separatorLineview = UIView()
        separatorLineview.backgroundColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        separatorLineview.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(separatorLineview)
        
        //x,y,w,h
        separatorLineview.leftAnchor.constraint(equalTo: containerView.leftAnchor).isActive = true
        separatorLineview.topAnchor.constraint(equalTo: containerView.topAnchor).isActive = true
        separatorLineview.widthAnchor.constraint(equalTo: containerView.widthAnchor).isActive = true
        separatorLineview.heightAnchor.constraint(equalToConstant: 1).isActive = true
    }
    
    @objc func handleSend() {
        let ref = Database.database().reference().child("mesages")
        let childRef = ref.childByAutoId()
        
        let toId = user?.userID
        let fromId = Auth.auth().currentUser?.uid
        let timeStamp = NSDate().timeIntervalSince1970
        let values = [
            "text": inputTextfield.text!,
            "name": user!.name,
            "toId": toId!,
            "timestamp": timeStamp,
            "fromId": fromId as Any] as [String : Any]
        
        childRef.updateChildValues(values) { (error, reference) in
            if error != nil {
                print(error?.localizedDescription as Any)
                return
            }
            
            self.inputTextfield.text = nil
            
            guard let messageId = childRef.key else {
                return
            }
            
            let userMessageRef = Database.database().reference().child("user-messages").child(fromId!)
            userMessageRef.updateChildValues([messageId: true])
            
            let recipinetUserMessagesref = Database.database().reference().child("user-messages").child(toId!)
            recipinetUserMessagesref.updateChildValues([messageId: true])
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        handleSend()
        return true
    }
    
    func estimateFrameForText(text : String) -> CGRect {
        let size  = CGSize(width: 200, height: 1000)
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        return NSString(string: text).boundingRect(with: size, options: options, attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 12.0)]  , context: nil)
    }
}


extension ChatLongVC : UICollectionViewDelegateFlowLayout {
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messages.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! ChatMessageCell
        
        let message = messages[indexPath.item]
        cell.textView.text = message.text
        if message.fromId == Auth.auth().currentUser?.uid {
            cell.bubbleView.backgroundColor = UIColor.blue
            cell.imageProfile.isHidden = true
            cell.bubbleViewRigthAnchor?.isActive = true
            cell.bubbleViewLeftAnchor?.isActive = false
        }else {
            cell.bubbleView.backgroundColor = UIColor.gray
            cell.imageProfile.isHidden = false
            cell.bubbleViewRigthAnchor?.isActive = false
            cell.bubbleViewLeftAnchor?.isActive = true
        }
        cell.bubbleWithAnchor?.constant = estimateFrameForText(text: message.text!).width + 32
        return cell
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        collectionView?.collectionViewLayout.invalidateLayout()
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var height:CGFloat = 80
        
        if let text = messages[indexPath.item].text {
            height = estimateFrameForText(text: text).height + 20
        }
        
        return CGSize(width: view.frame.width, height: height)
    }
}
