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

class ChatLongVC: UICollectionViewController, UITextFieldDelegate, UICollectionViewDelegateFlowLayout {
    
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
        }
    }
    
    var messages = [Message]()
    private let cellReuseIdentifier = "collectionCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        inputTextfield.delegate = self
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(MyCollectionViewCell.self, forCellWithReuseIdentifier: cellReuseIdentifier)
        //collectionView.register(UICollectionView.self, forCellWithReuseIdentifier: cellId)
        collectionView.backgroundColor = UIColor.white
        setupInputConponets()
        observeMessages()
    }
    
    func observeMessages() {
        let ref = Database.database().reference().child("mesages")
        ref.observe(.childAdded, with: { (snapshot) in
            for message in snapshot.children.allObjects as! [DataSnapshot] {
                if let dictionary = message.value as? [String : AnyObject] {

                       let fromId = dictionary["fromId"] as? String
                       let name = dictionary["name"] as? String
                       let text = dictionary["text"] as? String
                       let timestamp = dictionary["timestamp"] as? String
                       let toId = dictionary["toId"] as? String
                    self.messages.append(Message(fromId: fromId!, name: name!, text: text!, timestamp: timestamp ?? "", toId: toId!))
                }
            }
        }, withCancel: nil)
    }
    
    func setupInputConponets() {
        let containerView = UIView()
        containerView.backgroundColor = UIColor.white
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
        let timeStamp:NSNumber = NSNumber(value: Date().timeIntervalSince1970)
        let values = [
            "text": inputTextfield.text as Any,
            "name": user!.name,
            "toId": toId as Any,
            "timestamp": timeStamp,
            "fromId": fromId as Any] as [String : Any]
        childRef.updateChildValues(values)
        
        childRef.setValue(values) { (error, reference) in
            if error != nil {
                print(error?.localizedDescription as Any)
                return
            }
            let messageId = childRef.key
            let userMessageRef = Database.database().reference().child("user-messages").child(fromId!)
            userMessageRef.setValue([messageId: true])
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        handleSend()
        return true
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 5
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // get a reference to our storyboard cell
               let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellReuseIdentifier, for: indexPath as IndexPath) as! MyCollectionViewCell

               // Use the outlet in our custom class to get a reference to the UILabel in the cell
              // cell.myLabel.text = self.items[indexPath.item]
               cell.backgroundColor = UIColor.cyan // make cell more visible in our example project

               return cell
     //   let cell=collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath)
       // cell.backgroundColor = #colorLiteral(red: 0.1215686277, green: 0.01176470611, blue: 0.4235294163, alpha: 1)
        //return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.height, height: 80)
    }
    
}

class MyCollectionViewCell: UICollectionViewCell {

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
