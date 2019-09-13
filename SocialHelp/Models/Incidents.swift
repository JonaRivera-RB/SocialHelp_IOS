//
//  Incidents.swift
//  SocialHelp
//
//  Created by Misael Rivera on 9/1/19.
//  Copyright © 2019 Misael Rivera. All rights reserved.
//

import Foundation

class Incidents {
    var city : String = ""
    var date : String = ""
    var description : String = ""
    var latitude : Double = 0.0
    var longitude : Double = 0.0
    var title : String = ""
    var type : String = ""
    var userId : String = ""
    var zone : String = ""
    
    init(city:String, date:String, description:String, latitude:Double, longitude:Double, title:String, type:String, userId:String, zone:String) {
        self.city = city
        self.date = date
        self.description = description
        self.latitude = latitude
        self.longitude = longitude
        self.title = title
        self.type = type
        self.userId = userId
        self.zone = zone
    }
}
