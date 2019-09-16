//
//  UserData.swift
//  SocialHelp
//
//  Created by Misael Rivera on 9/15/19.
//  Copyright © 2019 Misael Rivera. All rights reserved.
//

import Foundation

struct UserData : Codable{
    var name = ""
    var lastName = ""
    var email = ""
    var phoneNumber = ""
    var urlPhoto = ""
    var memberSince = ""
    
    init(name:String,lastName:String,email:String,phoneNumber:String,urlPhoto:String,memberSince:String) {
        self.name = name
        self.lastName = lastName
        self.email = email
        self.phoneNumber = phoneNumber
        self.urlPhoto = urlPhoto
        self.memberSince = memberSince
    }
}

class UserData2 : NSObject {
    
    var confirm_password:String?
    var email:String?
    var gender:String?
    var id:String?
    var last_name:String?
    var memberSince:String?
    var name:String?
    var password:String?
    var phone_number:String?
    var photo:String?
}
