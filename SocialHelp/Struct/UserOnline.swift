//
//  UserOnline.swift
//  SocialHelp
//
//  Created by Misael Rivera on 9/16/19.
//  Copyright © 2019 Misael Rivera. All rights reserved.
//

import Foundation

struct UserOnline {
    var id:String?
    var email:String?
    var latitude:Double?
    var longitude:Double?
    
    init(id:String, email:String, latitude:Double, longitude:Double) {
        self.id = id
        self.email = email
        self.latitude = latitude
        self.longitude = longitude
    }
}
