//
//  NewMessageCell.swift
//  SocialHelp
//
//  Created by Misael Rivera on 9/13/19.
//  Copyright © 2019 Misael Rivera. All rights reserved.
//

import UIKit
import Firebase

let imageCache = NSCache<AnyObject, AnyObject>()

class NewMessageCell: UITableViewCell {

    @IBOutlet weak var userNameLbl:UILabel!
       @IBOutlet weak var userEmailLbl:UILabel!
       @IBOutlet weak var userImageProgile:UIImageView!
       


       func updateNewMessageCell(userName:String, userEmail:String, urlImage:String) {
           userImageProgile.layer.cornerRadius = 20
           userImageProgile.clipsToBounds = true
           
           self.userNameLbl.text = userName
           self.userEmailLbl.text = userEmail
           
           if urlImage.isEmpty == false && urlImage != "" {
               if let cacheImage = imageCache.object(forKey: urlImage as AnyObject) as? UIImage {
                   userImageProgile.layer.cornerRadius = 20
                   userImageProgile.clipsToBounds = true
                   self.userImageProgile.image = cacheImage
                   return
               }
               
               Storage.storage().reference(forURL: (urlImage)).getData(maxSize: 10 * 1024 * 1024, completion: { (data, error) in
                   if let error = error?.localizedDescription {
                       print("error al traer imagen", error)
                       self.userImageProgile.image  = #imageLiteral(resourceName: "addUserToGroup")
                   }
                   else {
                       let image = UIImage(data: data!)
                       self.userImageProgile.image = image
                       imageCache.setObject(image!, forKey: urlImage as AnyObject)
                   }
               })
           }
           else {
               self.userImageProgile.image  = #imageLiteral(resourceName: "defaultProfileImage")
           }
       }

}
