//
//  BasicUserData.swift
//  SocialHelp
//
//  Created by Misael Rivera on 9/13/19.
//  Copyright © 2019 Misael Rivera. All rights reserved.
//

import Foundation

struct BasicUserData {
    var name = ""
    var email = ""
    var urlPhoto = ""
    var userID = ""
    
    init(name:String, email:String, urlPhoto:String, userID:String) {
        self.name = name
        self.email = email
        self.urlPhoto = urlPhoto
        self.userID = userID
    }
}
