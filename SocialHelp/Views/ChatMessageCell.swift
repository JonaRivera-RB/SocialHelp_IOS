//
//  ChatMessageCell.swift
//  SocialHelp
//
//  Created by Misael Rivera on 9/22/19.
//  Copyright © 2019 Misael Rivera. All rights reserved.
//

import UIKit

class ChatMessageCell: UICollectionViewCell {
    
    let textView : UITextView = {
        let textView = UITextView()
        textView.text = "Simple text for now"
        textView.font = UIFont.systemFont(ofSize: 14)
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.backgroundColor = UIColor.clear
        textView.textColor = UIColor.white
        textView.isEditable = false
        textView.isScrollEnabled = false
        return textView
    }()
    
    let bubbleView : UIView = {
        let view = UIView()
        view.backgroundColor = #colorLiteral(red: 0.2196078449, green: 0.007843137719, blue: 0.8549019694, alpha: 1) //UIColor(red: 0, green: 137, blue: 249, alpha: 1)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 16
        view.layer.masksToBounds = true
        return view
    }()
    
    let imageProfile: UIImageView = {
        let imageview = UIImageView()
        imageview.image = #imageLiteral(resourceName: "defaultProfileImage")
        imageview.translatesAutoresizingMaskIntoConstraints = false
        imageview.layer.cornerRadius = 16
        imageview.layer.masksToBounds = true
        imageview.contentMode = .scaleAspectFill
        return imageview
    }()
    
    var bubbleWithAnchor : NSLayoutConstraint?
    var bubbleViewRigthAnchor : NSLayoutConstraint?
    var bubbleViewLeftAnchor : NSLayoutConstraint?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(bubbleView)
        addSubview(textView)
        addSubview(imageProfile)
        
        //ios constraint 9
        //x,y,w,h
        imageProfile.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 8).isActive = true
        imageProfile.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        imageProfile.widthAnchor.constraint(equalToConstant: 32).isActive = true
        imageProfile.heightAnchor.constraint(equalToConstant: 32).isActive = true
        
        bubbleViewRigthAnchor = bubbleView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -8)
        bubbleViewRigthAnchor?.isActive = true
        
        bubbleViewLeftAnchor = bubbleView.leftAnchor.constraint(equalTo: self.imageProfile.rightAnchor, constant: 8)
        //bubbleViewLeftAnchor?.isActive = true
        
        //bubbleView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -8).isActive = true
        bubbleView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        bubbleWithAnchor = bubbleView.widthAnchor.constraint(equalToConstant: 200)
        bubbleWithAnchor?.isActive = true
        bubbleView.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
        
        textView.leftAnchor.constraint(equalTo: self.bubbleView.leftAnchor, constant: 8).isActive = true
        textView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        textView.rightAnchor.constraint(equalTo: self.bubbleView.rightAnchor).isActive = true
        textView.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
