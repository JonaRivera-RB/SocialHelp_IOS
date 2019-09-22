//
//  UserCell.swift
//  SocialHelp
//
//  Created by Misael Rivera on 9/21/19.
//  Copyright © 2019 Misael Rivera. All rights reserved.
//

import UIKit
import Firebase


class UserCell: UITableViewCell {
    
    let imageCache = NSCache<AnyObject, AnyObject>()
    
    var message: MessageNS? {
        didSet {
            setupNameAndProfileImage()
            detailTextLabel?.text = message?.text
            
            if let seconds = message?.timestamp?.doubleValue {
                let timestampDate = NSDate(timeIntervalSince1970: seconds)
                
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "hh:mm:ss a"
                timeLabel.text = dateFormatter.string(from: timestampDate as Date)
            }
        }
    }
    
    private func setupNameAndProfileImage() {
       
        
        if let id = message?.chatPartnerId() {
            let ref = DataServices.instance.REF_USERS.child(id)
            ref.observeSingleEvent(of: .value) { (snapshot) in
                if let dictionary = snapshot.value as? [String: AnyObject] {
                    self.textLabel?.text = dictionary["name"] as? String
                    
                    
                    if let urlImage = dictionary["photo"] as? String {
                        if let cacheImage = self.imageCache.object(forKey: urlImage as AnyObject) as? UIImage {
                            self.profileImageView.image = cacheImage
                        }
                        else {
                            Storage.storage().reference(forURL: (urlImage)).getData(maxSize: 10 * 1024 * 1024, completion: { (data, error) in
                                if let error = error?.localizedDescription {
                                    print("error al traer imagen", error)
                                    self.profileImageView.image  = #imageLiteral(resourceName: "addUserToGroup")
                                }
                                else {
                                    let image = UIImage(data: data!)
                                    self.profileImageView.image = image
                                    self.imageCache.setObject(image!, forKey: urlImage as AnyObject)
                                }
                            })
                        }
                    }
                    else {
                        self.profileImageView.image  = #imageLiteral(resourceName: "defaultProfileImage")
                    }
                }
            }
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        textLabel?.frame = CGRect(x: 64, y: textLabel!.frame.origin.y - 2, width: textLabel!.frame.width, height: textLabel!.frame.height)
        detailTextLabel?.frame = CGRect(x: 64, y: detailTextLabel!.frame.origin.y + 2, width: detailTextLabel!.frame.width, height: detailTextLabel!.frame.height)
    }
    
    let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 24
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    let timeLabel: UILabel = {
        var label = UILabel()
        label.text = "HH:MM:SS"
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = UIColor.lightGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        
        addSubview(profileImageView)
        addSubview(timeLabel)
        
        //need x,y, height anchors
        profileImageView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 8).isActive = true
        profileImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 48).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 48).isActive = true
        
        //need x,y, height anchors
        timeLabel.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        timeLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 20).isActive = true
        timeLabel.widthAnchor.constraint(equalToConstant: 100).isActive = true
        timeLabel.heightAnchor.constraint(equalTo: textLabel!.heightAnchor).isActive = true
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
