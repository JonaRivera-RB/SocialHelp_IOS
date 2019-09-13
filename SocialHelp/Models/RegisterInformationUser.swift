//
//  RegisterInformationUser.swift
//  SocialHelp
//
//  Created by Misael Rivera on 6/1/19.
//  Copyright © 2019 Misael Rivera. All rights reserved.
//

import Foundation

struct RegisterInformationUser {
    var firstName = ""
    var lastName = ""
    var gender = ""
    var phoneNumber = ""
    var password = ""
    var confirmPassword = ""
    var email = ""
    
    init(firstName:String,lastName:String,gender:String, phoneNumber:String, password:String, confirmPassword:String, email:String) {
        self.firstName = firstName
        self.lastName = lastName
        self.gender = gender
        self.phoneNumber = phoneNumber
        self.password = password
        self.confirmPassword = confirmPassword
        self.email = email
    }
}
